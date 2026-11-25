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

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boFrameworkLib=${boFramework}/bash/lib
declare -grx boFrameworkLib

# TODO: importFromFramework core

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -grx boFramework

###################################################################################################
assembleAll
# TODO: logDone "BriteOnyx framework successfully activated in ${boFramework}"
