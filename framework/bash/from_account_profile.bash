#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx

declare -grx boAccount=${HOME}

# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash

###################################################################################################
# TODO: logDone "BriteOnyx framework successfully activated in ${boFramework}"
