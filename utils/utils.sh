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