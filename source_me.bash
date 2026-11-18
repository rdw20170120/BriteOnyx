#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "FATAL: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, cannot execute, MUST source script '$0'"
    exit 1
fi

###################################################################################################
if [[ -v boNO ]]; then
    >&2 echo "FATAL: Found 'boNO' defined, BriteOnyx is explicitly disabled"
    return 1
fi

###################################################################################################
# Launch a new interactive Bash shell, configured by the project's profile script
_Script=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/briteonyx.bashrc
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    # Order of Bash options matters (long first, short last)
    # shellcheck disable=SC2037
    _Cmd="bash --noprofile --rcfile ${_Script} -i"
    if [[ -v boIsTesting ]]; then
        ${_Cmd}
    else
        >&2 echo "ERROR: boIsTesting is NOT defined"
        # TODO: exec ${_Cmd}
    fi
else
    >&2 echo "ERROR: Missing script '${_Script}'"
    return 1
fi

unset _Script

# NOTE: MUST be the last executable line, to make the resulting shell 'habitable'
set +EeTu

###################################################################################################
: <<'DisabledContent'
# To safely test this script:
# try:
alias retest='bash -c ". source_me.bash"'

if [[ -v boDirLib ]]; then
    # BriteOnyx framework is initialized, so now we can use it

    # Dependencies:
    # shellcheck disable=SC2154
    source "$(require "${boDirLib}"/changeDirectoryIn.bash)"

    changeDirectoryIn boFramework
    # TODO: changeDirectoryIn prjDirRoot
fi

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
DisabledContent
