#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F requireFile >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

requireFile() {
    # Require file $1
    # $1 = file that is required
    requireArguments $# 1
    requireValue "$1"

    [[ -r "$1" ]] || abortOnFail 1 "Missing file '$1'"

    return 0
}
export -f requireFile

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
