#!/bin/bash
# Build the project.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && \
  pwd)"
readonly SCRIPT_DIR
. "${SCRIPT_DIR}/lib/utils.sh"

main() {
  # copy the source files to the build directory
  local build_target="${SCRIPT_DIR}/dist"
  local source_dir="${SCRIPT_DIR}/src"
  logfun cp -r "${source_dir}/" "${build_target}"

  # replace the placeholder with the actual value
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (BSD sed)
    logfun sed -i "" "s|REDIRECT_URL|${REDIRECT_URL}|g" \
      "${build_target}/js/main.js"
  else
    # Linux (GNU sed)
    logfun sed -i "s|REDIRECT_URL|${REDIRECT_URL}|g" \
      "${build_target}/js/main.js"
  fi
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
  log "start"
  main "$@"
  log "end"
fi
