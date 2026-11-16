#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# FIX: remove after development/testing
set -eu

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "WARN: Executing--but only for testing--script '$0'"
    # FIX: allow this script to be executed during development
    # FIX: re-enable this condition after development and testing
    # >&2 echo "ERROR: Aborting, cannot execute, MUST source script '$0'"
    # return 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 0
fi

###################################################################################################
# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

###################################################################################################
# Launch a new interactive Bash shell, configured with the project's profile script
_Dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
_Script=${_Dir}/briteonyx.bashrc
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    # Bash options order matters (long first, short last)
    if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
        # FIX: remove this condition after development and testing
        # Allow this script to be executed during development, and without 'exec'
        bash --noprofile --rcfile "${_Script}" -i
    else
        # Normal behavior, when this script is properly 'source'd
        exec bash --noprofile --rcfile "${_Script}" -i
    fi
else
    >&2 echo "ERROR: Missing script '${_Script}'"
    return 1
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
