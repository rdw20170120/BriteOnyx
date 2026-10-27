#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

declare -F showRan >/dev/null && return 0

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireDirectoryIn.bash
source "${boDirLib}"/requireValueIn.bash

showRan() {
    # Show files tracking which scripts ran during BriteOnyx startup
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

    logActivity "Showing which BriteOnyx showRan scripts ran"

    requireCommand fd
    requireCommand gls
    requireDirectoryIn HOME
    requireDirectoryIn XDG_CONFIG_HOME
    requireDirectoryIn boFramework
    requireDirectoryIn boHome
    requireValueIn boFormatDateGls
    requireValueIn boPrefixRan

    declare _CmdFd
    _CmdFd=$(which fd)
    declare -r _CmdFd
    declare _CmdGls
    _CmdGls=$(which gls)
    declare -r _CmdGls

    # TODO: use `execute`
    declare _Prefix=${_CmdFd}
    _Prefix+=' --exclude .git'
    _Prefix+=' --no-ignore-vcs'
    _Prefix+=' --one-file-system'
    _Prefix+=' -tf'
    _Prefix+=' -aFHILs'
    declare -r _Prefix

    # shellcheck disable=SC2154
    declare _Suffix=${boPrefixRan}
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
declare -frx showRan

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
