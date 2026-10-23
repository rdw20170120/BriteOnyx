#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F maybeDeleteFile >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

maybeDeleteFile() {
    # Delete file $1, if it exists
    # $1 = file to maybe delete
    requireArguments $# 1
    requireValue "$1"

    if [[ -e "$1" ]]; then
        if [[ -f "$1" ]]; then
            logAction "Deleting file: $1"
            requireCommand rm
            execute rm "$1"
        else
            abortOnFail 99 "Could not delete non-file: $1"
        fi
    else
        logDebug "No filesystem entry exists: $1"
    fi
    forbidPath "$1"

    return 0
}
export -f maybeDeleteFile

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/execute.bash
source "${boDirLib}"/forbidPath.bash
source "${boDirLib}"/logging.bash
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
