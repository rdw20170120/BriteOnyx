#!/usr/bin/env bash
# vim: set ft=bash:

sourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx

###################################################################################################
# Establish reference to framework library of Bash functions
# shellcheck disable=SC2154
boFrameworkLib=${boFramework}/bash/lib
declare -grx boFrameworkLib

###################################################################################################

_checkForLibrary() {
    # Maybe import the Bash library functions associated with name $2 in directory $1
    # $1 = directory that might contain library script
    # $2 = name that might be associated with library script
    requireArguments "${FUNCNAME[0]}" $# 2
    local _Dir=$1
    local _Name=$2

    logDebug "Checking for Bash library at '${_Dir}/${_Name}'"
    [[ -d "${_Dir}" ]] || return 1
    [[ -f "${_Dir}/${_Name}" ]] || return 1

    # Set calling function's local variable as result
    _Script=${_Dir}/${_Name}
    return 0
}
declare -frx _checkForLibrary

import() {
    # Import the Bash library functions associated with name $1
    # $1 = (partial) name of library script
    # TODO: Add support for account-specific and project-specific libraries
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Name=$1

    local _Script=
    _checkForLibrary "${boFrameworkLib}" "${_Name}" ||
        _checkForLibrary "${boFrameworkLib}" "${_Name}".bash ||
        _checkForLibrary "${boFrameworkLib}/${_Name}" "ALL.bash" ||
        {
            logError "Could not find a framework library for '${_Name}'"
            return 1
        }
    sourceRequiredScript "${_Script}"
}
declare -frx import
