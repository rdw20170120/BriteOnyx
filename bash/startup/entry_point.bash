#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

>/dev/null umask -S u=rwx,g=,o=

remember "${BASH_SOURCE[0]}"

# Configure for XDG standard
_Script="${boFramework}"/bash/startup/XDG.bash
require "${_Script}" && source "${_Script}"

declare -rx boFileTemplateGit=${XDG_CONFIG_HOME}/git/template.txt

# User portion of PATH
# shellcheck disable=SC2154
boPathExeFramework=${boFramework}/bash/bin
declare -rx boPathExeFramework
boPathExeUserGeneral=${HOME}/bin
declare -rx boPathExeUserGeneral
boPathExeUserBash=${XDG_CONFIG_HOME}/bash/bin
declare -rx boPathExeUserBash
# Order matters!
# Framework-specific executables override user executables (for now)
# Bash-specific executables override general executables
boPathUser=${boPathExeFramework}
boPathUser+=":${boPathExeUserBash}"
boPathUser+=":${boPathExeUserGeneral}"
declare -x boPathUser

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boDirLib=${boFramework}/bash/lib
declare -rx boDirLib

# Run all "first" scripts to establish the foundation of Bash environment
_Script="${boFramework}"/bash/startup/f/all.bash
require "${_Script}" && source "${_Script}"

if [[ -t 1 ]]; then
    # Since we have a TTY (terminal) connected, and presumably a user,
    # run all "interaction" scripts
    _Script="${boFramework}"/bash/startup/i/all.bash
    require "${_Script}" && source "${_Script}"
fi

# Run all "last" scripts to finish Bash environment
_Script="${boFramework}"/bash/startup/l/all.bash
require "${_Script}" && source "${_Script}"

logDone "BriteOnyx framework successfully activated in ${boFramework}"

###################################################################################################
: <<'DisabledContent'
# NOTE: Debugging
# source $(dirname ${BASH_SOURCE})/onError.bash
# trap 'onError "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR
# trap 'echo "Hello there, I caught exit $? from $(caller), ${FUNC_NAME}, ${LINENO}, ${BASH_LINENO}"' EXIT

Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
