#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

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
