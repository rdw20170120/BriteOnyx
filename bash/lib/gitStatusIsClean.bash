#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F gitStatusIsClean >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
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
export -f gitStatusIsClean

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
