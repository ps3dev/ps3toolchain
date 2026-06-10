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