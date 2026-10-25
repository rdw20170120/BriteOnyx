#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F requireArguments >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
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
export -f requireArguments

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
