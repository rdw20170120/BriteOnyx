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
DisabledContent
