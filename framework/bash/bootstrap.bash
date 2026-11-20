#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

###################################################################################################

absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'absolute' requires 1 argument instead of $#"
        exit 1
    fi

    local _Pathname=$1

    if [[ -d "${_Pathname}" ]]; then
        cd -- "${_Pathname}"
        _Result=$(pwd -P)
    else
        cd -- "$(dirname -- "${_Pathname}")"
        _Result=$(pwd -P)/$(basename -- "${_Pathname}")
    fi

    echo "${_Result}"
}
declare -frx absolute

baseOf() {
    # Return base of pathname $1
    # $1 = pathname of a file system entry
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'baseOf' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(basename -- "${_Result}")

    echo "${_Result}"
}
declare -frx baseOf

dirOf() {
    # Return directory of pathname $1, self if it is a directory
    # $1 = pathname of a file system entry
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'dirOf' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1

    if [[ ! -d "${_Result}" ]]; then
        _Result=$(dirname -- "${_Result}")
    fi

    _Result=$(absolute "${_Result}")
    echo "${_Result}"
}
declare -frx dirOf

library() {
    # Return absolute path of named ($1) library script,
    # OR abort with an error
    # $1 = (partial) name of library script
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'library' requires 1 argument instead of $#"
        exit 1
    fi

    local _Name=$1

    # shellcheck disable=SC2154
    _Result=${boFrmLib}/${_Name}.bash
    if [[ -r "${_Result}" ]]; then
        require "${_Result}"
        return 0
    else
        >&2 echo "DEBUG: did not find library '${_Result}'"
    fi
    _Result=${boFrmLib}/${_Name}
    if [[ -d "${_Result}" ]]; then
        _Result=${boFrmLib}/${_Name}/ALL.bash
        require "${_Result}"
        return 0
    else
        >&2 echo "DEBUG: did not find library '${_Result}'"
    fi
    _Result="ERROR: could not find a library for '${_Name}'"
    require "${_Result}"
}
declare -frx library

parentOf() {
    # Return parent directory of pathname $1
    # $1 = pathname of a file system entry
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'parentOf' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(dirname -- "${_Result}")
    _Result=$(absolute "${_Result}")

    echo "${_Result}"
}
declare -frx parentOf

require() {
    # Require script $1, expecting it to be invoked via Bash 'source' command
    # Return absolute pathname of script
    # $1 = pathname of script about to be invoked via "source"
    if [[ $# -ne 1 ]]; then
        >&2 echo "ERROR: Function 'require' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(absolute "${_Result}")

    if [[ -r "${_Result}" ]]; then
        >&2 echo "TRACE: Required script '${_Result}'"
    else
        >&2 echo "ERROR: Could not find readable script '${_Result}'"
        exit 1
    fi

    echo "${_Result}"
}
declare -frx require

requireBriteOnyx() {
    # Require BriteOnyx framework
    # No arguments

    if [[ -v boNO ]]; then
        >&2 echo "ERROR: Found 'boNO' defined, BriteOnyx is explicitly disabled"
        return 1
    fi
    if [[ -v boFramework ]]; then
        if [[ ! -d "${boFramework}" ]]; then
            >&2 echo "ERROR: 'boFramework' does not reference a directory, need BriteOnyx"
            return 1
        fi
    else
        >&2 echo "ERROR: Missing 'boFramework', need BriteOnyx"
        return 1
    fi

    return 0
}
declare -frx requireBriteOnyx

requireToBeExecuted() {
    # Require the calling script to be executed, NOT 'source'd
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    if [[ $# -ne 2 ]]; then
        >&2 echo "ERROR: Function 'requireToBeExecuted' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Executable=$1
    local _Script=$2

    if [[ -z "${_Script}" ]]; then
        >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
        return 1
    fi
    if [[ "${_Script}" != "${_Executable}" ]]; then
        >&2 echo "ERROR: Aborting, cannot source, MUST execute script '${_Executable}'"
        exit 1
    fi

    return 0
}
declare -frx requireToBeExecuted

requireToBeSourced() {
    # Require the calling script to be 'source'd, NOT executed
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    if [[ $# -ne 2 ]]; then
        >&2 echo "ERROR: Function 'requireToBeSourced' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Executable=$1
    local _Script=$2

    if [[ "${_Executable}" != bash ]]; then
        >&2 echo "DEBUG: executable '$0' is NOT 'bash' in '${_Script}'"
    fi
    if [[ -z "${_Script}" ]]; then
        >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
        return 1
    fi
    if [[ "${_Script}" == "${_Executable}" ]]; then
        >&2 echo "ERROR: Aborting, cannot execute, MUST source script '${_Executable}'"
        return 1
    fi

    return 0
}
declare -frx requireToBeSourced
