#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# FIX: remove after development/testing
set -eu

requireToBeSourced "$0" "${BASH_SOURCE[0]}"

# TODO: implement

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -rx boFramework
requireBriteOnyx

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
    set -o verbose
    set -o errtrace; set -o functrace ; set -o xtrace
    # Code to troubleshoot
    set +o errtrace; set +o functrace ; set +o xtrace ; set +o verbose
DisabledContent
