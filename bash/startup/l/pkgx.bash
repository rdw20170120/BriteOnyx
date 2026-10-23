#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash

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
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
