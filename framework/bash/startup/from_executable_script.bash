#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail

###################################################################################################
if [[ -v boNO ]]; then
    log "WARN: Found 'boNO' defined, disabling BriteOnyx"
    exit 1
fi

###################################################################################################
# Remember that we ran this script
# shellcheck disable=SC2154
touch "${boFramework}"/bash/startup/.ran_from_executable_script.bash
