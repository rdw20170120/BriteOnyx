#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireValueIn && return 0

remember "${BASH_SOURCE[0]}"

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
declare -frx requireValueIn

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
