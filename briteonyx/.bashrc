#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

>&2 echo "TRACE: Executing ${BASH_SOURCE[0]}"

###################################################################################################
# Kickstart Bash
_Script=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/kickstart.bash
if [[ -r "${_Script}" ]]; then
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}"
else
    >&2 echo "ERROR: Missing script '${_Script}'"
    return 1
fi
requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
boProjectHome=$(parentOf "${BASH_SOURCE[0]}")
boFramework=${boProjectHome}/framework
>&2 echo "INFO: boFramework=${boFramework}"

###################################################################################################
# Configure BriteOnyx framework
sourceRequiredScript "${XDG_CONFIG_HOME}"/bash/ALL.bash
sourceRequiredScript "${boProjectHome}"/ALL.bash
sourceRequiredScript "${boFramework}"/bash/from_project_profile.bash
configureShellForInteracting

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
    # Don't forget to 'exit', for testing
    exit 0
fi
