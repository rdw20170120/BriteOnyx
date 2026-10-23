#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F prepareToSourceOptional >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

prepareToSourceOptional() {
    # Prepare to `source` optional script $1,
    # returning 0 if the script is found and
    # returning 1 if the script is not found
    # $1 = script that is required
    #
    # Should be invoked like this:
    # _Script=DIR/SCRIPT.bash
    # prepareToSourceOptional "${_Script}"; source "${_Script}"
    # unset _Script
    requireArguments $# 1
    requireValue "$1"
    requireVariable _Script

    if [[ -r "$1" ]]; then
        # shellcheck disable=SC2154
        logTrace "Sourcing optional script:  ${_Script}"
    else
        logTrace "Missing optional script, skipping:  ${_Script}"
        return 1
    fi

    return 0
}
export -f prepareToSourceOptional

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireValue.bash
source "${boDirLib}"/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
