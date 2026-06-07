#!/bin/sh -e

CONFIG_TIMEOUT="${CONFIG_TIMEOUT:-15}"
CONFIG_BASE_URL="https://git.savannah.gnu.org/cgit/config.git/plain"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ASSET_DIR="${ROOT_DIR}/assets"

fetch_config_file() {
  file="$1"
  url="${CONFIG_BASE_URL}/${file}"
  tmp="${file}.tmp"

  echo "Fetching ${file} from Savannah, timeout ${CONFIG_TIMEOUT}s..."

  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL --connect-timeout 5 --max-time "${CONFIG_TIMEOUT}" "${url}" -o "${tmp}"; then
      mv "${tmp}" "${file}"
      chmod +x "${file}"
      return 0
    fi
  elif command -v wget >/dev/null 2>&1; then
    if wget --timeout="${CONFIG_TIMEOUT}" --tries=1 -O "${tmp}" "${url}"; then
      mv "${tmp}" "${file}"
      chmod +x "${file}"
      return 0
    fi
  fi

  echo "Falling back to safe ${file}."
  rm -f "${tmp}"
  cp "${ASSET_DIR}/${file}" "${file}"
  chmod +x "${file}"
}

fetch_config_file config.guess
fetch_config_file config.sub
