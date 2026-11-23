#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

###################################################################################################
if [[ -v boIsTesting ]]; then
    PS4='+${BASH_SOURCE[0]}> '
    # set -o verbose
    set -o errtrace
    set -o functrace
    set -o xtrace
fi

###################################################################################################
# Kickstart Bash
_Script=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/kickstart.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}"
else
    >&2 echo "ERROR: Missing script '${_Script}'"
    exit 1
fi
configureShellForScripting
requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
boProject=$(parentOf "${BASH_SOURCE[0]}")
boFramework=${boProject}/framework
>&2 echo "INFO: boFramework=${boFramework}"

###################################################################################################
# Configure BriteOnyx framework
requireBriteOnyx
sourceScript "${boFramework}"/bash/from_project_profile.bash

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

configureShellForInteracting
