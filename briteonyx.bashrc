#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail

###################################################################################################
if [[ -v boNO ]]; then
    log "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 0
fi

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
    log "WARN: Could not source script ${_Script}"
fi

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
# shellcheck disable=SC2034
boFramework="$(dirname -- "${BASH_SOURCE[0]}")"/framework
log "boFramework=${boFramework}"

###################################################################################################
# Freeze reference to BriteOnyx framework
declare -r boFramework

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
DisabledContent
