#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F getTemporaryFile >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
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
export -f getTemporaryFile

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
