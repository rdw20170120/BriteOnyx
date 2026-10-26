#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F execute && return 0

remember "${BASH_SOURCE[0]}"

logExecuting "${BASH_SOURCE[0]}"

execute() {
    # Execute command-with-arguments $@, wrapping it for error handling

    logDebug "Executing: $*"
    # shellcheck disable=SC2068
    if $@; then
        :
    else
        abortOnFail $? "from $*"
    fi

    return 0
}
declare -frx execute

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/logging.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
