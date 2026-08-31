#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="../scripts"

echo "      # ------------------------"
echo "      # Build steps"
echo "      # ------------------------"

for script in "$SCRIPT_DIR"/*.sh; do
    filename="$(basename "$script" .sh)"

    # Remove numeric prefix and convert dashes to spaces
    name="${filename#[0-9][0-9][0-9]-}"
    name="${name//-/ }"

    # Capitalize first letter of each word
    name="$(echo "$name" | sed -E 's/(^| )([a-z])/\1\u\2/g')"

    echo "      - name: Build $name"
    echo "        working-directory: ./build"
    echo "        run: ../scripts/$(basename "$script")"
    echo
done