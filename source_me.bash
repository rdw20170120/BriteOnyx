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
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

###################################################################################################
# Remember that we ran this script
boPrefixRan=.ran_
declare -rx boPrefixRan
touch "$(dirname -- "${BASH_SOURCE[0]}")"/"${boPrefixRan}""$(basename -- "${BASH_SOURCE[0]}")"

###################################################################################################
# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

###################################################################################################
# TODO: 'exec' a new Bash shell, using the project profile script

###################################################################################################
: <<'DisabledContent'
DisabledContent
