#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F maybeCreateDirectoryTree && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

maybeCreateDirectoryTree() {
    # Create directory tree $1, if it does not already exist
    # $1 = directory tree to maybe create
    requireArguments $# 1
    requireValue "$1"

    if [[ -d "$1" ]]; then
        logDebug "Directory already exists: $1"
    else
        logAction "Creating directory: $1"
        requireCommand mkdir
        execute mkdir -p "$1"
    fi
    requireDirectory "$1"

    return 0
}
declare -frx maybeCreateDirectoryTree

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/execute.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireDirectory.bash
source "${boDirLib}"/requireValue.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
