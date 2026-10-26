#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireCommand && return 0

remember "${BASH_SOURCE[0]}"

# NO: logExecuting "${BASH_SOURCE[0]}"

requireCommand() {
    # Require command $1
    # $1 = command that is required
    requireArguments $# 1
    requireValue "$1"

    # TODO: warn about wasted effort to require Bash builtins
    # TODO: create an `isCommand ` function

    # shellcheck disable=SC2086
    if type $1 &>/dev/null; then
        :
    else
        abortOnFail $? "Missing command '$1'"
    fi

    return 0
}
declare -frx requireCommand

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
