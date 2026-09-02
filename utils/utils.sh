#!/usr/bin/env bash
set -eo pipefail

# Extract an archive, with pv progress if available.
# Usage: extract <archive> [extra tar args...]
extract() {
    local archive="$1"
    shift

    if [ ! -f "$archive" ]; then
        echo "extract: not a file: $archive" >&2
        return 1
    fi

    local -a flag=()
    case "$archive" in
        *.tar.xz|*.txz)   flag=(-J) ;;
        *.tar.gz|*.tgz)   flag=(-z) ;;
        *.tar.bz2|*.tbz2) flag=(-j) ;;
        *.tar.zst)        flag=(--zstd) ;;
        *.tar)            flag=() ;;
        *)
            echo "extract: unknown archive type: $archive" >&2
            return 1
            ;;
    esac

    if command -v pv >/dev/null 2>&1; then
        pv -pterab "$archive" | tar "${flag[@]}" -xf - "$@"
    else
        echo "  (pv not found, extracting without progress)"
        tar "${flag[@]}" -xf "$archive" "$@"
    fi
}

# Unpack only if the source directory is not already present.
# Usage: unpack_if_needed <archive> <srcdir>
unpack_if_needed() {
    local archive="$1" srcdir="$2"
    if [ -d "$srcdir" ]; then
        echo "Already unpacked: $srcdir"
        return 0
    fi
    echo "Unpacking $srcdir"
    extract "$archive"
}

# Apply a patch once. Shared trees (newlib) are patched by an earlier
# script; re-applying fails because new files already exist.
# Usage: apply_patch <patchfile> <srcdir>
apply_patch() {
    local patchfile="$1" srcdir="$2"
    if [ ! -f "$patchfile" ]; then
        echo "apply_patch: missing $patchfile" >&2
        return 1
    fi
    local stamp="$srcdir/.ps3-patched-$(basename "$patchfile")"
    if [ -f "$stamp" ]; then
        echo "Already patched: $srcdir ($(basename "$patchfile"))"
        return 0
    fi
    patch -p1 --batch --forward -d "$srcdir" < "$patchfile"
    touch "$stamp"
}

# Replace GNU config.guess/config.sub so hosts like aarch64-apple-darwin
# are recognized. newlib 1.20 (and other old trees) ship copies that reject
# Apple Silicon. Always refresh, including rebuilds after a failed configure.
# Usage: refresh_config_scripts <srcdir> [srcdir...]
refresh_config_scripts() {
    if [ $# -lt 1 ]; then
        echo "refresh_config_scripts: missing source directory" >&2
        return 1
    fi
    ../config/get-config-scripts.sh
    local src_guess="../archives/config.guess"
    local src_sub="../archives/config.sub"
    if [ ! -f "$src_guess" ] || [ ! -f "$src_sub" ]; then
        echo "refresh_config_scripts: missing $src_guess or $src_sub" >&2
        return 1
    fi
    local dest
    for dest in "$@"; do
        if [ ! -d "$dest" ]; then
            echo "refresh_config_scripts: not a directory: $dest" >&2
            return 1
        fi
        echo "Refreshing config.guess/config.sub in $dest"
        find "$dest" -name config.guess -exec cp "$src_guess" {} \;
        find "$dest" -name config.sub -exec cp "$src_sub" {} \;
    done
}