#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F getTemporaryFile && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

getTemporaryFile() {
    # Return a temporary file absolute pathname
    requireArguments $# 0
    requireDirectoryIn boDirTemp

    requireCommand mktemp
    # shellcheck disable=SC2154
    if mktemp "${boDirTemp}"/XXXXXXXX; then
        :
    else
        abortOnFail $? "from mktemp ${boDirTemp}/XXXXXXXX"
    fi

    return 0
}
declare -frx getTemporaryFile

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireDirectoryIn.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
