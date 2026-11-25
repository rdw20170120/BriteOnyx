#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx

# TODO: logExecuting "${BASH_SOURCE[0]}"
# TODO: logActivity 'Activating this project for this Bash session'

# Use relative path for project executables directory
# so it works in project home directory
# and all subdirectories (subprojects)
boProjectDirExe=./bin
declare -grx boProjectDirExe

# Yes, it is redundant perhaps to have both 'boPrjDirExe' and 'boPrjPathExe'
# but they serve different purposes
# 'boPrjDirExe' is THE (relative) directory for project executables
# 'boPrjPathExe' is the project's portion of PATH, providing a hook for extension
# shellcheck disable=SC2034
boProjectPathExe=${boProjectDirExe}
declare -grx boProjectPathExe

# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash

# TODO: forbidVariable boProject
# TODO: logVariable boProject
# TODO: declare -grx boProject
# TODO: requireDirectoryIn boProject
# TODO: changeDirectoryIn boProject
# shellcheck disable=SC2154,SC2164
cd "${boProjectHome}"

# TODO: forbidVariable boPrjDirExe
# TODO: declare -x boPrjDirExe
# TODO: logVariable boPrjDirExe

# TODO: forbidVariable boPrjPathExe
# TODO: declare -x boPrjPathExe
# TODO: logVariable boPrjPathExe

###################################################################################################
# TODO: logDone "BriteOnyx framework successfully activated in ${boFramework}"
