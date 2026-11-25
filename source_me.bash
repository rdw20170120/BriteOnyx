#!/usr/bin/env bash
# vim: set ft=bash:

>&2 echo "TRACE: Executing ${BASH_SOURCE[0]}"

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, cannot execute, MUST source script '$0'"
    exit 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "ERROR: Found 'boNO' defined, BriteOnyx is explicitly disabled"
    return 1
fi

###################################################################################################
# Launch a new interactive Bash shell, configured by the project's profile script
_Script=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/briteonyx/.bashrc
if [[ -r "${_Script}" ]]; then
    # Order of Bash options matters (long first, short last)
    # shellcheck disable=SC2037
    _Cmd="bash --noprofile --rcfile ${_Script} -i"
    if [[ -v boIsTesting ]]; then
        >&2 echo "DEBUG: boIsTesting is defined, skipping 'exec'"
        >&2 echo "TRACE: Launching subshell with script '${_Script}'"
        ${_Cmd}
    else
        >&2 echo "TRACE: 'exec'ing into new shell with script '${_Script}'"
        exec ${_Cmd}
        # NOTE: in typical use, nothing past this line will execute due to 'exec'
    fi
else
    >&2 echo "ERROR: Missing script '${_Script}'"
    return 1
fi
