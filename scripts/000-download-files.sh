#!/bin/bash
set -euo pipefail

MANIFEST="../download-manifest.txt"
DOWNLOAD_DIR="../downloads"

echo "Downloading files to ${DOWNLOAD_DIR}"

mkdir -p "$DOWNLOAD_DIR"

while IFS= read -r line || [[ -n "$line" ]]; do
    # handle Windows line endings
    line="${line%$'\r'}"

    # skip blanks/comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    url=$(awk '{print $1}' <<< "$line")
    filename=$(awk '{print $2}' <<< "$line")
    expected_sha=$(awk '{print $3}' <<< "$line")

    filepath="$DOWNLOAD_DIR/$filename"
    tmpfile="${filepath}.tmp"

    # URL + filename only → always download
    if [[ -z "${expected_sha:-}" ]]; then
        echo "No SHA provided, force downloading: $filepath"
        curl -L -o "$tmpfile" "$url"
        mv "$tmpfile" "$filepath"
        echo "Downloaded: $filepath"
        continue
    fi

    # SHA mode → cache check
    if [[ -f "$filepath" ]]; then
        actual_sha=$(sha256sum "$filepath" | awk '{print $1}')

        if [[ "$actual_sha" == "$expected_sha" ]]; then
            echo "OK (cached): $filepath"
            continue
        else
            echo "SHA mismatch, re-downloading: $filepath"
        fi
    else
        echo "Missing file, downloading: $filepath"
    fi

    curl -L -o "$tmpfile" "$url"

    actual_sha=$(sha256sum "$tmpfile" | awk '{print $1}')

    if [[ "$actual_sha" == "$expected_sha" ]]; then
        mv "$tmpfile" "$filepath"
        echo "OK: $filepath"
    else
        echo "FAIL: $filepath"
        echo "Expected: $expected_sha"
        echo "Got:      $actual_sha"
        rm -f "$tmpfile"
        exit 1
    fi

done < "$MANIFEST"

echo "All files verified."