#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F parentOf && return 0

remember "${BASH_SOURCE[0]}"

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
declare -frx parentOf

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
