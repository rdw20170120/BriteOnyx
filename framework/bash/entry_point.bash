#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:

sourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx

# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/bootstrap.bash
import core

# Export and freeze reference to BriteOnyx framework
declare -grx boFramework

assembleAll
logDone "BriteOnyx framework successfully activated in ${boFramework}"
