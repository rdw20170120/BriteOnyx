#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

>/dev/null umask -S u=rwx,g=,o=

remember "${BASH_SOURCE[0]}"

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boDirLib=${boFramework}/bash/lib
declare -rx boDirLib

# shellcheck disable=SC2154
source "$(require "${boDirLib}"/checkUsability.bash)"
source "$(require "${boDirLib}"/showRan.bash)"

# Reconfigure for usability
set +o errexit
set +o errtrace
set +o functrace
set +o hashall
set +o interactive-comments
# TODO: refactor to my customizations
set +o emacs
set -o vi
checkUsability

# shellcheck disable=SC2154
logDone "BriteOnyx framework successfully activated in ${boFramework}"

###################################################################################################
: <<'DisabledContent'

# User portion of PATH
# shellcheck disable=SC2154
boPathExeFramework=${boFramework}/bash/bin
declare -rx boPathExeFramework
boPathExeUserBash=${XDG_CONFIG_HOME}/bash/bin
declare -rx boPathExeUserBash
boPathExeUserGeneral=${HOME}/bin
declare -rx boPathExeUserGeneral
# Order matters!
# Framework-specific executables override user executables
# Bash-specific executables override general executables
boPathUser=${boPathExeFramework}
boPathUser+=":${boPathExeUserBash}"
boPathUser+=":${boPathExeUserGeneral}"
declare -x boPathUser

# Run all "first" scripts to establish the foundation of Bash environment
source "$(require "${boFramework}"/bash/startup/f/all.bash)"

if [[ -t 1 ]]; then
    # Since we have a TTY (terminal) connected, and presumably a user,
    # run all "interaction" scripts
    source "$(require "${boFramework}"/bash/startup/i/all.bash)"
fi

# Run all "last" scripts to finish Bash environment
source "$(require "${boFramework}"/bash/startup/l/all.bash)"

# TODO: debugging
# source $(parentOf ${BASH_SOURCE})/onError.bash
# trap 'onError "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR
# trap 'echo "Hello there, I caught exit $? from $(caller), ${FUNC_NAME}, ${LINENO}, ${BASH_LINENO}"' EXIT

Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
