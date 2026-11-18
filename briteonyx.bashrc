#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
# shellcheck disable=SC2034
boFramework=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/framework
>&2 echo "boFramework=${boFramework}"

###################################################################################################
_Script="${boFramework}"/bash/startup/bootstrap.bash
if [[ -r ${_Script} ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}"
else
    >&2 echo "FATAL: Missing script '${_Script}'"
    return 1
fi

###################################################################################################
source "$(require "${boFramework}"/bash/startup/from_project_profile.bash)"

###################################################################################################
# Finish project-specific configuration
# TODO: implement, as needed

###################################################################################################
# MUST be the last executable lines, to make the resulting shell 'habitable'
set -o pipefail
set +o errexit
set +o nounset
set +o emacs
set -o vi

###################################################################################################
: <<'DisabledContent'
# NOTE: override BriteOnyx framework for local development
# since this is the BriteOnyx project repository
boFramework=$(parentOf "${BASH_SOURCE[0]}")
declare -rx boFramework

# This script uses the BriteOnyx framework
# shellcheck disable=SC2154
source "${boFramework}"/bash/startup/from_script.bash

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

forbidVariable prjDirRoot
prjDirRoot=$(parentOf "${BASH_SOURCE[0]}")
declare -rx prjDirRoot
logVariable prjDirRoot
requireDirectoryIn prjDirRoot

forbidVariable prjDirTmp
prjDirTmp="${prjDirRoot}"/.tmp
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
prjDirLib=${prjDirRoot}/lib
declare -rx prjDirLib
logVariable prjDirLib
requireDirectoryIn prjDirLib

_Script=${prjDirLib}/project_override.bash
require "${_Script}" && source "${_Script}"

changeDirectoryIn prjDirRoot

logDone "Project successfully activated in ${prjDirRoot}"

unset _Script
DisabledContent
