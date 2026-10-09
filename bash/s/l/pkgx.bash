#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

# https://github.com/pkgxdev/dev
export PKGX_DIR=${HOME}/.pkgx
if type pkgx &>/dev/null; then
  set +o nounset
  # TODO: Capture script, then `source` it
  eval "$(pkgx --quiet dev --shellcode)"
  set -o nounset
else
  logUnavailable pkgx
  if type curl &>/dev/null; then
    # Install pkgx
    # TODO: Capture script, then `source` it
    curl -fsS https://pkgx.sh | sh
  else
    logUnavailable curl
  fi
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
