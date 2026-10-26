#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F maybeDeleteFile && return 0

remember "${BASH_SOURCE[0]}"

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
declare -frx maybeDeleteFile

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
