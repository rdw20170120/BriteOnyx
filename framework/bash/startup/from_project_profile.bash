#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# TODO: remove after development/testing
set -eu

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
    return 1
fi

###################################################################################################
# Remember that we ran this script
# shellcheck disable=SC2154
touch "${boFramework}"/bash/startup/${boRan}from_project_profile.bash

# TODO: implement

###################################################################################################
# Freeze reference to BriteOnyx framework
declare -r boFramework

###################################################################################################
# MUST be the last executable lines, to make the resulting shell 'habitable'
set -o pipefail
set +o errexit
set +o nounset
unset _Script

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
    set -o verbose
    set -o errtrace; set -o functrace ; set -o xtrace
    # Code to troubleshoot
    set +o errtrace; set +o functrace ; set +o xtrace ; set +o verbose
DisabledContent
