#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F requireFileIn >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

requireValueIn() {
    # Require value referenced in variable $1
    # $1 = variable holding reference to value that is required
    requireArguments $# 1
    requireVariable "$1"
    local -r Name=$1

    requireValue "${!Name}"

    return 0
}
export -f requireValueIn

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireValue.bash
source "${boDirLib}"/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
