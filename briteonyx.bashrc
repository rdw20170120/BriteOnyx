#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

###################################################################################################
if [[ -v boIsTesting ]]; then
    PS4='+${BASH_SOURCE[0]}> '
    # set -o verbose
    set -o errtrace
    set -o functrace
    set -o xtrace
fi

###################################################################################################
# Install BriteOnyx framework
_Script="${HOME}"/.config/bash/install-source.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}" \
        BriteOnyx 0.4.0 \
        https://github.com/rdw20170120/BriteOnyx.git
    # shellcheck disable=SC2154
    declare boHome=${boInstalledInto}
    declare boFramework=${boHome}/framework
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
_Script="${boFramework}"/bash/bootstrap.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}"
else
    >&2 echo "FATAL: Missing script '${_Script}'"
    return 1
fi
requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################
source "$(require "${HOME}"/.config/XDG.env)"
source "$(require "${XDG_CONFIG_HOME}"/BriteOnyx.env)"
source "$(require "${XDG_CONFIG_HOME}"/MANPATH.env)"
source "$(require "${XDG_CONFIG_HOME}"/PATH.env)"
set -euo pipefail

###################################################################################################
# Configure BriteOnyx framework
requireBriteOnyx
source "$(require "${boFramework}"/bash/from_project_profile.bash)"

###################################################################################################
# Finish project-specific configuration
# TODO: logExecuting "${BASH_SOURCE[0]}"
# TODO: logActivity 'Activating this project for this Bash session'

# TODO: forbidVariable prjHome
prjHome=$(parentOf "${BASH_SOURCE[0]}")
declare -rx prjHome
# TODO: logVariable prjHome
# TODO: requireDirectoryIn prjHome
# TODO: changeDirectoryIn prjHome
cd "${prjHome}"

# Use relative path for project executables directory
# so it works in project home directory
# and all subdirectories (subprojects)
# TODO: forbidVariable prjDirExe
prjDirExe=./bin
# TODO: declare -x prjDirExe
# TODO: logVariable prjDirExe

# Yes, it is redundant perhaps to have both 'prjDirExe' and 'prjPathExe'
# but they serve different purposes
# 'prjDirExe' is THE (relative) directory for project executables
# 'prjPathExe' is the project's portion of PATH, providing a hook for extension
# TODO: forbidVariable prjPathExe
# shellcheck disable=SC2034
prjPathExe=${prjDirExe}
# TODO: declare -x prjPathExe
# TODO: logVariable prjPathExe

###################################################################################################
# Apply changes to paths
source "$(require "${XDG_CONFIG_HOME}"/MANPATH.env)"
source "$(require "${XDG_CONFIG_HOME}"/PATH.env)"
set -euo pipefail

###################################################################################################
# Execute project scripts when testing BriteOnyx
if [[ -v boIsTesting ]]; then
    >&2 echo "INFO: boIsTesting is defined, executing project scripts"
    pwd
    project-clean
    project-commit
    project-compile
    project-ctags
    project-format
    project-generate
    project-lint
    project-pull
    project-push
    project-quality
    project-tag
    project-test
    exit 0
fi

###################################################################################################
# MUST be the last executable lines, to make the resulting shell 'habitable'
set -o pipefail
set +o errexit
set +o nounset
set +o errtrace
set +o functrace
set +o xtrace
set +o verbose
doctor
