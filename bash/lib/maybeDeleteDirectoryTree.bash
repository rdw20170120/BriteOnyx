#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F maybeDeleteDirectoryTree && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

maybeDeleteDirectoryTree() {
    # Delete directory tree $1, if it exists
    # $1 = directory tree to maybe delete
    requireArguments $# 1
    requireValue "$1"

    if [[ -e "$1" ]]; then
        if [[ -d "$1" ]]; then
            logAction "Deleting directory tree: $1"
            requireCommand rm
            execute rm -fr "$1"
        else
            abortOnFail 1 "Could not delete non-directory: $1"
        fi
    else
        logDebug "No filesystem entry exists: $1"
    fi
    forbidPath "$1"

    return 0
}
declare -frx maybeDeleteDirectoryTree

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
