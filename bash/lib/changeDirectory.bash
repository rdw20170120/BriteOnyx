#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F changeDirectory >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

changeDirectory() {
    # Change current working directory to $1
    # $1 = target directory
    requireArguments $# 1
    requireDirectory "$1"

    logDebug "Changing to directory $1"
    requireCommand cd
    execute cd "$1"

    # TODO: Check against `${PWD}`
    # TODO: requireCommand pwd
    # TODO: Check against `$(pwd)`

    return 0
}
export -f changeDirectory

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/execute.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireDirectory.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
