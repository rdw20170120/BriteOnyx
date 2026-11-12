#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireValue && return 0

remember "${BASH_SOURCE[0]}"

# NO: logExecuting "${BASH_SOURCE[0]}"

requireValue() {
    # Require value $1
    # $1 = value that is required
    requireArguments $# 1

    if [[ -z "$1" ]]; then
        abortOnFail 1 "Missing value"
    fi

    return 0
}
declare -frx requireValue

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/requireArguments.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
