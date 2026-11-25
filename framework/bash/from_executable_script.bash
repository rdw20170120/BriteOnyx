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
# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash

###################################################################################################
# TODO: logDone "BriteOnyx framework successfully activated in ${boFramework}"
