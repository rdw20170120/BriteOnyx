#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

sourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx

logActivity 'Activating this project for this Bash session'

declare -grx boProjectHome
boProjectPath=./bin
declare -grx boProjectPath
# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash
# shellcheck disable=SC2154,SC2164
cd "${boProjectHome}"

logDone "BriteOnyx framework successfully activated in '${boProjectHome}'"
