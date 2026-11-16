#!/usr/bin/env bash
# shellcheck disable=SC1090
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
    >&2 echo "ERROR: Aborting, cannot execute, MUST source script '$0'"
    return 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 0
fi

###################################################################################################
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

###################################################################################################
# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

###################################################################################################
# Use account-level XDG configuration, if available
_Script=${HOME}/.config/XDG.env
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing ${_Script}"
    source "${_Script}"
else
    >&2 echo "ERROR: Missing script ${_Script}"
fi

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
# shellcheck disable=SC2034
boFramework="$(dirname "${BASH_SOURCE[0]}")"/framework
>&2 echo "boFramework=${boFramework}"

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
DisabledContent
