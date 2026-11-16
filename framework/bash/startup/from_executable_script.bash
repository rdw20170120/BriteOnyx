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
    >&2 echo "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "WARN: Found 'boNO' defined, disabling BriteOnyx"
    return 1
fi

# TODO: implement

###################################################################################################
# Freeze reference to BriteOnyx framework
declare -r boFramework

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
    set -o verbose
    set -o errtrace; set -o functrace ; set -o xtrace
    # Code to troubleshoot
    set +o errtrace; set +o functrace ; set +o xtrace ; set +o verbose
DisabledContent
