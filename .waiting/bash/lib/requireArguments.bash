#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F requireArguments && return 0

remember "${BASH_SOURCE[0]}"

# NO: logExecuting "${BASH_SOURCE[0]}"

requireArguments() {
    # Require that caller received expected number of arguments
    # $1 = actual number of arguments (from $#) received by caller
    # $2 = expected number of arguments

    # TODO: enhance to accept a range of expected arguments (X-Y)

    if [[ $# -ne 2 ]]; then
        logError "Function 'requireArguments' requires 2 arguments instead of $#"
        exit 127
    fi
    if [[ $1 -ne $2 ]]; then
        logError "Requires $2 argument(s) instead of $1"
        exit 1
    fi

    return 0
}
declare -frx requireArguments

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
