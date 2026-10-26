#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F gitStatusIsClean && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

gitStatusIsClean() {
    # Return whether status of git working directory $1 is clean
    # $1 = git working directory
    # Exit code 0 = clean
    # Exit code 1 = dirty
    requireArguments $# 1

    requireCommand git
    requireCommand wc

    changeDirectory "$1"
    logDebug "Gathering status of this git repository"
    # TODO: REFACTOR: to improve error handling
    local -ir _Count=$(git status --porcelain | wc -l)
    if [[ ${_Count} -gt 0 ]]; then
        return 1
    fi

    return 0
}
declare -frx gitStatusIsClean

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/changeDirectory.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
