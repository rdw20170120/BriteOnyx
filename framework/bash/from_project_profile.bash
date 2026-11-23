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
boPrjDirExe=./bin

# Yes, it is redundant perhaps to have both 'boPrjDirExe' and 'boPrjPathExe'
# but they serve different purposes
# 'boPrjDirExe' is THE (relative) directory for project executables
# 'boPrjPathExe' is the project's portion of PATH, providing a hook for extension
# shellcheck disable=SC2034
boPrjPathExe=${boPrjDirExe}

# shellcheck disable=SC2154
sourceScript "${boFramework}"/bash/entry_point.bash

# TODO: forbidVariable boProject
# TODO: logVariable boProject
# TODO: declare -grx boProject
# TODO: requireDirectoryIn boProject
# TODO: changeDirectoryIn boProject
cd "${boProject}"

# TODO: forbidVariable boPrjDirExe
# TODO: declare -x boPrjDirExe
# TODO: logVariable boPrjDirExe

# TODO: forbidVariable boPrjPathExe
# TODO: declare -x boPrjPathExe
# TODO: logVariable boPrjPathExe

###################################################################################################
# logDone "BriteOnyx framework successfully activated in ${boFramework}"
