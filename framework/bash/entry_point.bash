#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx
configureShellForScripting

###################################################################################################
# Bootstrap BriteOnyx framework
# shellcheck disable=SC2154
sourceScript "${boFramework}"/bash/bootstrap.bash

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boFrmLib=${boFramework}/bash/lib
declare -rx boFrmLib

# TODO: importFromFramework core

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -rx boFramework
# logDone "BriteOnyx framework successfully activated in ${boFramework}"
