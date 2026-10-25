#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F getAbsolutePath >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"

getAbsolutePath() {
    # Return the absolute pathname of file system entry $1
    # NO: `readlink` returns the target of a link, rather than the link itself
    # NO: `realpath` returns the target of a link, rather than the link itself
    logCall getAbsolutePath
    requireArguments $# 1
    logArgument "$1" 1 'pathname'

    requireCommand basename
    requireCommand cd
    requireCommand dirname
    requireCommand pwd

    local Base
    local Dir
    local Pathname=$1
    local Result
    Base=$(basename "${Pathname}")
    Dir=$(dirname "${Pathname}")

    if [[ -d "${Pathname}" ]]; then
        Result=$(cd "${Pathname}" && pwd)
    else
        Result="$(cd "${Dir}" && pwd)/${Base}"
    fi

    echo "${Result}"
    return 0
}
export -f getAbsolutePath

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
