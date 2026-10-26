#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireCommand.bash

requireCommand mkdir

export boDirTemp=${HOME}/tmp
if [[ ! -e "${boDirTemp}" ]]; then
    logAction "Creating directory '${boDirTemp}'"
    mkdir "${boDirTemp}"
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
