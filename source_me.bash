#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "FATAL: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, cannot execute, MUST source script '$0'"
    exit 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "FATAL: Found 'boNO' defined, BriteOnyx is explicitly disabled"
    return 1
fi

###################################################################################################
# Launch a new interactive Bash shell, configured by the project's profile script
_Script=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/briteonyx.bashrc
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    # Order of Bash options matters (long first, short last)
    # shellcheck disable=SC2037
    _Cmd="bash --noprofile --rcfile ${_Script} -i"
    if [[ -v boIsTesting ]]; then
        >&2 echo "INFO: boIsTesting is defined, skipping 'exec'"
        ${_Cmd}
    else
        exec ${_Cmd}
        # NOTE: in typical use, nothing past this line will execute due to 'exec'
    fi
else
    >&2 echo "FATAL: Missing script '${_Script}'"
    return 1
fi

###################################################################################################
: <<'DisabledContent'
# To safely test this script:
# try:
alias retest='bash -c ". source_me.bash"'
DisabledContent
