#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# TODO: remove after development/testing
set -eu
# NO: set -EeTu
set -o pipefail

###################################################################################################
# Trivial logging, for now
log() { >&2 printf '%s\n' "$1"; }

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    log "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
# Allow this script to be executed during development
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    log "WARN: Executing--but only for testing--script '$0'"
    # TODO: re-enable this condition after development and testing
    # log "ERROR: Aborting, cannot execute, MUST source script '$0'"
    # return 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    log "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 0
fi

###################################################################################################
# Remember that we ran this script
boRan=.ran=
_Dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
touch "${_Dir}"/"${boRan}""$(basename "${BASH_SOURCE[0]}")"

###################################################################################################
# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

###################################################################################################
# Launch a new interactive Bash shell, configured with the project's profile script
_Script=${_Dir}/briteonyx.bashrc
if [[ -r "${_Script}" ]]; then
    log "TRACE: Sourcing script '${_Script}'"
    # Bash options order matters (long first, short last)
    if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
        # TODO: remove this condition after development and testing
        # Allow this script to be executed during development, and without 'exec'
        bash --noprofile --rcfile "${_Script}" -i
    else
        # Normal behavior, when this script is properly 'source'd
        exec bash --noprofile --rcfile "${_Script}" -i
    fi
else
    log "ERROR: Missing script '${_Script}'"
    return 1
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
