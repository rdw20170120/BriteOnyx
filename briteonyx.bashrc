#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
# Install BriteOnyx framework
_Script="${HOME}"/.config/bash/install-source.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}" \
        BriteOnyx 0.4.0 \
        https://github.com/rdw20170120/BriteOnyx.git
    # shellcheck disable=SC2154
    declare boFramework=${boInstalledInto}/framework
    >&2 echo "INFO: boFramework=${boFramework}"
else
    >&2 echo "FATAL: Missing script '${_Script}'"
    return 1
fi

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework instead
boFramework=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/framework
>&2 echo "INFO: boFramework=${boFramework}"

###################################################################################################
# Bootstrap BriteOnyx framework
_Script="${boFramework}"/bash/startup/bootstrap.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}"
else
    >&2 echo "FATAL: Missing script '${_Script}'"
    return 1
fi
requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################
# Configure BriteOnyx framework
requireBriteOnyx
source "$(require "${boFramework}"/bash/startup/from_project_profile.bash)"

###################################################################################################
# Finish project-specific configuration
# TODO: implement, as needed
# TODO: changeDirectoryIn prjHome

###################################################################################################
# MUST be the last executable lines, to make the resulting shell 'habitable'
set -o pipefail
set +o errexit
set +o nounset
doctor

###################################################################################################
# Execute project scripts when testing BriteOnyx
if [[ -v boIsTesting ]]; then
    >&2 echo "INFO: boIsTesting is defined, executing project scripts"
    # TODO: implement
fi

###################################################################################################
: <<'DisabledContent'
# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/changeDirectoryIn.bash
source "${boDirLib}"/forbidVariable.bash
source "${boDirLib}"/absolute.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/maybeCreateDirectoryTree.bash
source "${boDirLib}"/requireDirectory.bash
source "${boDirLib}"/requireDirectoryIn.bash

logExecuting "${BASH_SOURCE[0]}"

logActivity 'Activating this project for this Bash session'

forbidVariable prjHome
prjHome=$(parentOf "${BASH_SOURCE[0]}")
declare -rx prjHome
logVariable prjHome
requireDirectoryIn prjHome

forbidVariable prjDirTmp
prjDirTmp="${prjHome}"/.tmp
declare -rx prjDirTmp
logVariable prjDirTmp
maybeCreateDirectoryTree "${prjDirTmp}"

# Use relative path for project scripts
# so it works in project directory
# and all subdirectories (subprojects)
forbidVariable prjPathExe
prjPathExe=./bin
declare -x prjPathExe
logVariable prjPathExe

forbidVariable prjDirLib
prjDirLib=${prjHome}/lib
declare -rx prjDirLib
logVariable prjDirLib
requireDirectoryIn prjDirLib

_Script=${prjDirLib}/project_override.bash
require "${_Script}" && source "${_Script}"

changeDirectoryIn prjHome

logDone "Project successfully activated in ${prjHome}"

unset _Script
DisabledContent
