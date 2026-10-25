#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

declare -F ran >/dev/null && return 0

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireVariable.bash

_boPrefixRan=.ran_
export _boPrefixRan

startup() {
    # Show tracking files touched during startup script execution
    requireArguments $# 0

    # 'fd' options:
    # -a = --absolute-path
    # -s = --case-sensitive
    # -F = --fixed-strings
    # -L = --follow
    # -H = --hidden
    # -I = --no-ignore
    # -t = --type
    # -X = --exec-batch

    # 'gls' options:
    # TODO: consider using the TIME_STYLE environment variable
    # -n = --numeric-uid-gid
    # -r = --reverse
    # -t = --time=mtime

    logActivity "Showing which BriteOnyx startup scripts ran"

    requireCommand fd
    requireCommand gls
    requireVariable _boPrefixRan
    requireVariable HOME
    requireVariable XDG_CONFIG_HOME
    requireVariable boFormatDateGls
    requireVariable boFramework
    requireVariable boHome

    declare _CmdFd
    _CmdFd=$(which fd)
    declare -r _CmdFd
    declare _CmdGls
    _CmdGls=$(which gls)
    declare -r _CmdGls

    declare _Prefix=${_CmdFd}
    _Prefix+=' --exclude .git'
    _Prefix+=' --no-ignore-vcs'
    _Prefix+=' --one-file-system'
    _Prefix+=' -tf'
    _Prefix+=' -aFHILs'
    declare -r _Prefix

    declare _Suffix=${_boPrefixRan}
    _Suffix+=' -X'
    _Suffix+=" ${_CmdGls}"
    # shellcheck disable=SC2154
    _Suffix+=" --time-style=+${boFormatDateGls}"
    _Suffix+=' -nrt'
    _Suffix+=' {}'
    declare -r _Suffix

    declare _Command1=${_Prefix}
    # shellcheck disable=SC2154
    _Command1+=" --search-path ${boFramework}"
    # shellcheck disable=SC2154
    _Command1+=" --search-path ${boHome}"
    _Command1+=" --search-path ${XDG_CONFIG_HOME}"
    _Command1+=" ${_Suffix}"
    declare -r _Command1

    declare _Command2=${_Prefix}
    _Command2+=" --max-depth 1"
    _Command2+=" --search-path ${HOME}"
    _Command2+=" ${_Suffix}"
    declare -r _Command2

    # logVariable _Command1
    # logVariable _Command2

    {
        ${_Command1}
        ${_Command2}
    } | awk '{print $6, $7}' | sort
}
export -f startup

###################################################################################################
: <<'DisabledContent'

if type gls &>/dev/null; then
    :
else
    logUnavailable gls
    # TODO: Implement 'ran' using 'ls' if 'gls' is unavailable
fi

Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
