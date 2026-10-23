#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

>/dev/null umask -S u=rwx,g=,o=

source "${XDG_CONFIG_HOME}"/BO.env

# TODO: Customize command-line editing
# TODO: Customize command-line searching
# TODO: Implement support for scripts to properly use `trap` to cleanup
# TODO: Migrate from using `alias` to creating Bash functions

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
export boDirLib=${boFramework}/bash/lib

# Run all "first" scripts to establish the foundation of Bash environment
source "$(dirname "${BASH_SOURCE[0]}")"/f/all.bash

if [[ -t 1 ]]; then
    # Since we have a TTY (terminal) connected, and presumably a user,
    # Run all "interaction" scripts
    source "$(dirname "${BASH_SOURCE[0]}")"/i/all.bash
fi

# Run all "last" scripts to finish Bash environment
source "$(dirname "${BASH_SOURCE[0]}")"/l/all.bash

logDone "BriteOnyx framework successfully activated in ${boFramework}"

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace

# NOTE: Debugging
# source $(dirname ${BASH_SOURCE})/onError.bash
# trap 'onError "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR
# trap 'echo "Hello there, I caught exit $? from $(caller), ${FUNC_NAME}, ${LINENO}, ${BASH_LINENO}"' EXIT
DisabledContent
