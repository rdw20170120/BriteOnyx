#!/usr/bin/env bash
# vim: set ft=bash:

requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################

>&2 echo "TODO: implement bootstrap"

importFromFramework() {
    >&2 echo "TODO: implement ${FUNCNAME[0]}"
    return 0
}
declare -frx importFromFramework

library() {
    # Return absolute path of named ($1) library script,
    # OR abort with an error
    # $1 = (partial) name of library script
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
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
