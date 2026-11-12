#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F forbidVariable && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

forbidVariable() {
    # Forbid variable $1
    # $1 = variable name that is forbidden
    requireArguments $# 1
    requireValue "$1"
    local -r Name=$1
    local -r Value=${!Name:-undefined_variable}

    if [[ "${Value}" != "undefined_variable" ]]; then
        abortOnFail 1 "Forbidden variable '$1' exists"
    fi
}
declare -frx forbidVariable

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
