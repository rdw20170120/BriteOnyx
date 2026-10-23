#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F parentOf >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

parentOf() {
    # Return the parent directory for filesystem entry $1
    # $1 = filesystem entry
    requireArguments $# 1
    requireValue "$1"
    requireCommand dirname

    # shellcheck disable=SC2046
    echo -n $(dirname "$1")

    return 0
}
export -f parentOf

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireValue.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
