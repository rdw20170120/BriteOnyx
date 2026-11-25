#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

>&2 echo "TRACE: Executing ${BASH_SOURCE[0]}"

# Show shell options during development/testing
set -o
shopt

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
configureShellForScripting
requireBriteOnyx

# TODO: logExecuting "${BASH_SOURCE[0]}"
# TODO: logActivity 'Activating this account for this Bash session'

# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash

###################################################################################################
# shellcheck disable=SC2154,SC2164
cd "${boAccountHome}"
# TODO: logDone "BriteOnyx framework successfully activated in ${boAccountHome}"
