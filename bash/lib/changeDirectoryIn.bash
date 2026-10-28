#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F changeDirectoryIn && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

changeDirectoryIn() {
    # Require directory referenced in variable $1
    # $1 = variable holding reference to directory that is required
    requireArguments $# 1
    requireVariable "$1"
    local -r Name=$1

    changeDirectory "${!Name}"

    return 0
}
declare -frx changeDirectoryIn

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/changeDirectory.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
