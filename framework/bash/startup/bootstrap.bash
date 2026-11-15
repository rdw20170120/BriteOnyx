#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# TODO: remove after development/testing
set -eu

# TODO: refactor these into their own declaration scripts

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    log "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    log "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'absolute' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Pathname
    _Pathname=$1

    if [[ -d "${_Pathname}" ]]; then
        cd -- "${_Pathname}"
        _Result=$(pwd -P)
    else
        cd -- "$(dirname -- "${_Pathname}")"
        _Result=$(pwd -P)/$(basename -- "${_Pathname}")
    fi

    echo "${_Result}"
}
# declare -frx absolute

baseOf() {
    # Return base of pathname $1
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'baseOf' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Result
    _Result=$1
    _Result=$(basename -- "${_Result}")

    echo "${_Result}"
}
# declare -frx baseOf

dirOf() {
    # Return directory of pathname $1, self if it is a directory
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'dirOf' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Result
    _Result=$1

    if [[ ! -d "${_Result}" ]]; then
        _Result=$(dirname -- "${_Result}")
    fi

    _Result=$(absolute "${_Result}")
    echo "${_Result}"
}
# declare -frx dirOf

executing() {
    # Acknowledge that function $2 defined in script $1 is executing now
    # Calling this function should be the first executable line
    # in every significant function--with few low-level exceptions.
    # $1 = pathname of defining script (e.g., from "${BASH_SOURCE[0]}")
    # $2 = name of executing function (e.g., from "${FUNCNAME[0]}")

    if [[ $# -ne 2 ]]; then
        log "FATAL: Function 'executing' requires 2 arguments instead of $#"
        exit 1
    fi

    declare _Function
    _Function=$2
    declare _Pathname
    _Pathname=$1
    _Pathname=$(absolute "${_Pathname}")

    if >/dev/null declare -F logCall; then
        logCall "${_Function}"
    fi

    # TODO: verify that executing function is part of the current BriteOnyx framework

    return 0
}
# declare -frx executing

parentOf() {
    # Return parent directory of pathname $1
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'parentOf' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Result
    _Result=$1
    _Result=$(dirname -- "${_Result}")
    _Result=$(absolute "${_Result}")

    echo "${_Result}"
}
# declare -frx dirOf

remember() {
    # Remember that we ran script $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'remember' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Pathname
    _Pathname=$1
    _Pathname=$(absolute "${_Pathname}")

    # Remember that we executed the script,
    # but not by (problematic) logging during shell startup
    # shellcheck disable=SC2154
    touch "$(dirname -- "${_Pathname}")"/"${boPrefixRan}""$(basename -- "${_Pathname}")"

    return 0
}
# declare -frx remember

require() {
    # Require script $1, expecting it to be invoked via Bash 'source' command
    # Return absolute pathname of script
    # $1 = pathname of script about to be invoked via "source"

    if [[ $# -ne 1 ]]; then
        log "FATAL: Function 'require' requires 1 argument instead of $#"
        exit 1
    fi

    declare _Result
    _Result=$1
    _Result=$(absolute "${_Result}")

    if [[ ! -r "$1" ]]; then
        log "ERROR: Could not find readable script $1"
        exit 1
    fi

    echo "${_Result}"
}
# declare -frx require
