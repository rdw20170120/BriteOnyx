#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

# BASH_SOURCE[0]=environment appears to indicate that a script was executed at the CLI prompt
# TODO: What does BASH_LINENO[0]=0 mean?

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "FATAL: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

###################################################################################################

absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")
    if [[ $# -ne 1 ]]; then
        >&2 echo "FATAL: Function 'absolute' requires 1 argument instead of $#"
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
        >&2 echo "FATAL: Function 'baseOf' requires 1 argument instead of $#"
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
        >&2 echo "FATAL: Function 'dirOf' requires 1 argument instead of $#"
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

executing() {
    # Acknowledge that function $2 defined in script $1 is executing now
    # Calling this function should be the first executable line
    # in every significant function--with few low-level exceptions.
    # $1 = pathname of defining script (e.g., from "${BASH_SOURCE[0]}")
    # $2 = name of executing function (e.g., from "${FUNCNAME[0]}")
    if [[ $# -ne 2 ]]; then
        >&2 echo "FATAL: Function 'executing' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Function=$2
    local _Pathname=$1
    _Pathname=$(absolute "${_Pathname}")

    # shellcheck disable=SC2034
    if >/dev/null declare -F logCall; then
        logCall "${_Function}"
    fi

    # TODO: verify that executing function is part of the current BriteOnyx framework

    return 0
}
declare -frx executing

parentOf() {
    # Return parent directory of pathname $1
    # $1 = pathname of a file system entry
    if [[ $# -ne 1 ]]; then
        >&2 echo "FATAL: Function 'parentOf' requires 1 argument instead of $#"
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
        >&2 echo "FATAL: Function 'require' requires 1 argument instead of $#"
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
        >&2 echo "FATAL: Found 'boNO' defined, BriteOnyx is explicitly disabled"
        return 1
    fi
    if [[ -v boFramework ]]; then
        if [[ ! -d "${boFramework}" ]]; then
            >&2 echo "FATAL: 'boFramework' does not reference a directory, need BriteOnyx"
            return 1
        fi
    else
        >&2 echo "FATAL: Missing 'boFramework', need BriteOnyx"
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
        >&2 echo "FATAL: Function 'requireToBeExecuted' requires 2 arguments instead of $#"
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
        >&2 echo "FATAL: Function 'requireToBeSourced' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Executable=$1
    local _Script=$2

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

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
    set -o verbose; set -o errtrace; set -o functrace ; set -o xtrace
    # Code to troubleshoot
    set +o errtrace; set +o functrace ; set +o xtrace ; set +o verbose
DisabledContent
