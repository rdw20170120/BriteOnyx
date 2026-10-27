#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

>/dev/null umask -S u=rwx,g=,o=

# shellcheck disable=SC2154
touch "$(command dirname -- "${BASH_SOURCE[0]}")"/"${boPrefixRan}""$(command basename -- "${BASH_SOURCE[0]}")"

# To safely test this script,
# try: bash -c '. source_me.bash'

# Uncomment for debugging/development
boLogLevel=7
declare -x boLogLevel

_Script=${HOME}/.config/XDG.env
if [[ -r "${_Script}" ]]; then
    echo "TRACE: Sourcing ${_Script}"
    source "${_Script}"
else
    echo "WARN: Could not source script ${_Script}"
fi

# Since this is BriteOnyx's project repository, use it as the framework
boFramework="$(command dirname -- "${BASH_SOURCE[0]}")"

# Install BriteOnyx framework, if necessary
# REF: https://github.com/rdw20170120/BriteOnyx
_Script=${boFramework}/installBriteOnyx.bash
if [[ -r "${_Script}" ]]; then
    echo "TRACE: Sourcing ${_Script}"
    source "${_Script}"
else
    echo "WARN: Could not source script ${_Script}"
fi

if [[ -v boDirLib ]]; then
    # BriteOnyx framework is initialized, so now we can use it
    # shellcheck disable=SC2154
    source "$(require "${boDirLib}"/changeDirectoryIn.bash)"

    changeDirectoryIn boFramework
    # TODO: changeDirectoryIn prjDirRoot
fi

unset _Script

###############################################################################
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


logDone "Project successfully activated in ${prjDirRoot}"

unset _Script

Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
