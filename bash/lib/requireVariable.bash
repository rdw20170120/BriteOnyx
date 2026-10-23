#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F requireVariable >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
# NO: logExecuting "${BASH_SOURCE[0]}"

requireVariable() {
    # Require variable $1
    # $1 = name of variable that is required
    requireArguments $# 1
    requireValue "$1"
    local -r _Name=$1
    local -r _Value=${!_Name:-something_unexpected}

    if [[ ${_Value} == something_unexpected ]]; then
        abortOnFail 1 "Undefined variable '${_Name}'"
    fi

    return 0
}
export -f requireVariable

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireValue.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
