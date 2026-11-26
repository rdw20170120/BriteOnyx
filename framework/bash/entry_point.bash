#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:

>&2 echo "TRACE: Executing ${BASH_SOURCE[0]}"

# Show shell options during development/testing
set -o
shopt

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
configureShellForScripting
requireBriteOnyx

###################################################################################################
# Bootstrap BriteOnyx framework
# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/bootstrap.bash

import core

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -grx boFramework

###################################################################################################
assembleAll
# TODO: logDone "BriteOnyx framework successfully activated in ${boFramework}"
