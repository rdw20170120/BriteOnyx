#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireDirectory && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

requireDirectory() {
    # Require directory $1
    # $1 = directory that is required
    requireArguments $# 1
    requireValue "$1"

    if [[ ! -d "$1" ]]; then
        abortOnFail 1 "Missing directory '$1'"
    fi

    return 0
}
declare -frx requireDirectory

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireValue.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
