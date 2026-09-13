#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
cd archives || exit 1

ARCHIVE="archives.txt"
# 15s was aborting slow Sourceware transfers. Keep the partial file and resume.
WGET_OPTS=(--continue --tries=20 --timeout=60 --waitretry=5 --retry-connrefused --quiet --show-progress)

# -----------------------------------------------------------------------------
# verify_sha256 <file> <expected_sha>
# Returns 0 on match, 1 on mismatch or error.
# -----------------------------------------------------------------------------
verify_sha256() {
    file="$1"
    expected="$2"
    out=$(sha256sum "$file" 2>/dev/null) || {
        echo "  !! sha256sum failed: $file" >&2
        return 1
    }
    set -- $out
    actual="$1"
    if [ "$actual" != "$expected" ]; then
        echo "  !! SHA256 mismatch: $file" >&2
        echo "     expected: $expected" >&2
        echo "     got:      $actual"  >&2
        return 1
    fi
    return 0
}

file_size() {
    wc -c < "$1" | tr -d ' '
}

# -----------------------------------------------------------------------------
# mirror_urls <url>
# Prints the primary URL plus GNU/kernel.org fallbacks.
# -----------------------------------------------------------------------------
mirror_urls() {
    url="$1"
    file="$(basename "$url")"
    printf '%s\n' "$url"

    case "$url" in
        */binutils/releases/*|*/gnu/binutils/*)
            printf '%s\n' \
                "https://ftpmirror.gnu.org/gnu/binutils/${file}" \
                "https://ftp.gnu.org/gnu/binutils/${file}" \
                "https://sourceware.org/pub/binutils/releases/${file}" \
                "https://mirrors.kernel.org/sourceware/binutils/releases/${file}"
            ;;
        */gcc/releases/*|*/gnu/gcc/*)
            ver="${file%.tar.*}"
            printf '%s\n' \
                "https://ftpmirror.gnu.org/gnu/gcc/${ver}/${file}" \
                "https://ftp.gnu.org/gnu/gcc/${ver}/${file}" \
                "https://sourceware.org/pub/gcc/releases/${ver}/${file}" \
                "https://gcc.gnu.org/pub/gcc/releases/${ver}/${file}"
            ;;
        */gdb/releases/*|*/gnu/gdb/*)
            printf '%s\n' \
                "https://ftpmirror.gnu.org/gnu/gdb/${file}" \
                "https://ftp.gnu.org/gnu/gdb/${file}" \
                "https://sourceware.org/pub/gdb/releases/${file}"
            ;;
        */newlib/*)
            printf '%s\n' \
                "https://sourceware.org/pub/newlib/${file}" \
                "https://mirrors.kernel.org/sourceware/newlib/${file}"
            ;;
    esac
}

# -----------------------------------------------------------------------------
# fetch <dest> <url> [url...]
# Resumes into dest; does not delete a partial file on failure.
# -----------------------------------------------------------------------------
fetch() {
    dest="$1"
    shift
    url=""
    for url in "$@"; do
        [ -n "$url" ] || continue
        echo "  -> $url"
        if wget "${WGET_OPTS[@]}" -O "$dest" "$url"; then
            return 0
        fi
        echo "  !! failed, trying next mirror..." >&2
    done
    echo "  !! Download failed: ${1:-$url}" >&2
    return 1
}

# -----------------------------------------------------------------------------
# download <sha> <size> <url> [rename]
# -----------------------------------------------------------------------------
download() {
    sha="$1"
    size="$2"
    url="$3"
    rename="${4:-}"
    file="${rename:-$(basename "$url")}"

    printf '==> %s\n' "$file"

    if [ -f "$file" ]; then
        if [ "$sha" = "-" ]; then
            echo "  -- no checksum, skipping re-download of existing file"
            return 0
        fi
        if verify_sha256 "$file" "$sha"; then
            echo "  -- already good"
            return 0
        fi
        actual=$(file_size "$file")
        if [ "$size" != "-" ] && [ "$actual" -lt "$size" ]; then
            echo "  -- incomplete (${actual}/${size} bytes), resuming..."
        else
            echo "  -- existing file failed verification, re-downloading..."
            rm -f "$file"
        fi
    fi

    # Unique mirror list, primary URL first.
    urls=$(mirror_urls "$url" | awk 'NF && !seen[$0]++')

    # shellcheck disable=SC2086
    fetch "$file" $urls

    if [ "$sha" != "-" ]; then
        if ! verify_sha256 "$file" "$sha"; then
            echo "  -- checksum failed, retrying from another mirror..."
            rm -f "$file"
            # shellcheck disable=SC2086
            fetch "$file" $urls
            verify_sha256 "$file" "$sha" || {
                rm -f "$file"
                echo "  !! Giving up on $file" >&2
                return 1
            }
        fi
    fi

    echo "  -- ok"
}

# -----------------------------------------------------------------------------
# parse_line <line> -> prints "sha\tsize\turl\trename" or returns 1
# -----------------------------------------------------------------------------
parse_line() {
    line="$1"
    [ -z "$line" ] && return 1
    set -- $line
    [ "$#" -lt 3 ] && return 1
    sha="$1"; size="$2"; url="$3"
    rename=""
    shift 3
    if [ "${1:-}" = "->" ]; then
        rename="${2:-}"
    fi
    printf '%s\t%s\t%s\t%s\n' "$sha" "$size" "$url" "$rename"
}

# -----------------------------------------------------------------------------
# run_all / run_one
# -----------------------------------------------------------------------------
run_all() {
    ../config/get-config-scripts.sh
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        parsed=$(parse_line "$line") || continue
        IFS="$(printf '\t')" read -r sha size url rename <<EOF
$parsed
EOF
        download "$sha" "$size" "$url" "$rename"
    done < "$ARCHIVE"
}

# Guess a GNU/sourceware URL when archives.txt has no matching line.
guess_url() {
    file="$1"
    case "$file" in
        binutils-*.tar.*)
            printf 'https://ftpmirror.gnu.org/gnu/binutils/%s\n' "$file"
            ;;
        gcc-*.tar.*)
            ver="${file%.tar.*}"
            printf 'https://ftpmirror.gnu.org/gnu/gcc/%s/%s\n' "$ver" "$file"
            ;;
        newlib-*.tar.*)
            printf 'https://sourceware.org/pub/newlib/%s\n' "$file"
            ;;
        gdb-*.tar.*)
            printf 'https://ftpmirror.gnu.org/gnu/gdb/%s\n' "$file"
            ;;
        *)
            return 1
            ;;
    esac
}

run_one() {
    target="$1"
    found=0
    while IFS= read -r line; do
        case "$line" in
            \#*|"") continue ;;
            *"$target"*) ;;
            *) continue ;;
        esac
        parsed=$(parse_line "$line") || continue
        IFS="$(printf '\t')" read -r sha size url rename <<EOF
$parsed
EOF
        download "$sha" "$size" "$url" "$rename"
        found=1
        break
    done < "$ARCHIVE"
    [ "$found" -eq 1 ] && return 0

    if url=$(guess_url "$target"); then
        echo "Not in $ARCHIVE; fetching $url" >&2
        download "-" "-" "$url" "$target"
        return 0
    fi

    echo "Not found: $target" >&2
    echo "Add a line to archives/archives.txt or use a GNU/sourceware tarball name." >&2
    exit 1
}

# -----------------------------------------------------------------------------
if [ "$#" -eq 0 ]; then
    run_all
else
    run_one "$1"
fi
