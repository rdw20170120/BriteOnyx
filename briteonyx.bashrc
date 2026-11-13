#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# TODO: remove after development/testing
set -eu

###################################################################################################
# Trivial logging, for now
log() { >&2 printf '%s\n' "$1"; }

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    log "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    log "ERROR: Aborting, cannot execute, MUST source script '$0'"
    return 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    log "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 0
fi

###################################################################################################
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

###################################################################################################
# Remember that we ran this script
boRan=.ran=
touch "$(dirname "${BASH_SOURCE[0]}")"/"${boRan}""$(basename "${BASH_SOURCE[0]}")"

###################################################################################################
# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

###################################################################################################
# Use account-level XDG configuration, if available
_Script=${HOME}/.config/XDG.env
if [[ -r "${_Script}" ]]; then
    log "TRACE: Sourcing ${_Script}"
    source "${_Script}"
else
    log "ERROR: Missing script ${_Script}"
fi

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
# shellcheck disable=SC2034
boFramework="$(dirname "${BASH_SOURCE[0]}")"/framework
log "boFramework=${boFramework}"

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
DisabledContent
