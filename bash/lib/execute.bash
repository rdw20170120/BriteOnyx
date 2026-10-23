#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F execute >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
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
export -f execute

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
