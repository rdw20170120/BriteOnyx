#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail

###################################################################################################
if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    log "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    exit 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    log "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 1
fi

###################################################################################################
# Remember that we ran this script
# shellcheck disable=SC2154
touch "${boFramework}"/bash/startup/.ran_from_project_profile.bash
