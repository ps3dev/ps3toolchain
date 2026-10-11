#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
cd archives || exit 1

ARCHIVE="archives.txt"
WGET="wget --tries=5 --timeout=15 --quiet --show-progress"

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

# -----------------------------------------------------------------------------
# fetch <url> <dest>
# -----------------------------------------------------------------------------
fetch() {
    url="$1"
    dest="$2"
    $WGET -O "$dest" "$url" || {
        echo "  !! Download failed: $url" >&2
        rm -f "$dest"
        return 1
    }
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

    # If already present, verify immediately — size alone is not enough.
    if [ -f "$file" ]; then
        if [ "$sha" = "-" ]; then
            echo "  -- no checksum, skipping re-download of existing file"
            return 0
        fi
        if verify_sha256 "$file" "$sha"; then
            echo "  -- already good"
            return 0
        fi
        echo "  -- existing file failed verification, re-downloading..."
        rm -f "$file"
    fi

    # First attempt
    fetch "$url" "$file"

    # Verify, with one retry on mismatch
    if [ "$sha" != "-" ]; then
        if ! verify_sha256 "$file" "$sha"; then
            echo "  -- retrying download..."
            rm -f "$file"
            fetch "$url" "$file"
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

run_one() {
    target="$1"
    found=0
    while IFS= read -r line; do
        case "$line" in
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
    [ "$found" -eq 1 ] || {
        echo "Not found: $target" >&2
        exit 1
    }
}

# -----------------------------------------------------------------------------
if [ "$#" -eq 0 ]; then
    run_all
else
    run_one "$1"
fi