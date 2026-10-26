#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F getAbsolutePath && return 0

remember "${BASH_SOURCE[0]}"

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
declare -frx getAbsolutePath

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
