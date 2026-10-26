#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireVariable && return 0

remember "${BASH_SOURCE[0]}"

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
declare -frx requireVariable

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
