#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F requireScript >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

requireScript() {
    # Require script $1
    # NOTE: this is intended for scripts to be `source`d, not executed
    # $1 = script that is required (to be readable, not necessarily executable)
    requireArguments $# 1
    requireValue "$1"

    requireFile "$1"
    [[ -r "$1" ]] || abortOnFail 1 "File not readable: '$1'"

    return 0
}
export -f requireScript

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireFile.bash
source "${boDirLib}"/requireValue.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
