#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

umask -S u=rwx,g=,o= >/dev/null

source ${XDG_CONFIG_HOME}/BO.env

# TODO: Customize command-line editing
# TODO: Customize command-line searching
# TODO: Implement support for scripts to properly use `trap` to cleanup
# TODO: Migrate from using `alias` to creating Bash functions

# NOTE: Debugging
# source $(dirname ${BASH_SOURCE})/onError.bash
# trap 'onError "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR
# trap 'echo "Hello there, I caught exit $? from $(caller), ${FUNC_NAME}, ${LINENO}, ${BASH_LINENO}"' EXIT

# Establish reference to script library of Bash functions
# shellcheck disable=SC2154
export boDirLib=${boFramework}/bash/lib

# Run all "first" scripts to establish the foundation of the Bash environment
source $(dirname ${BASH_SOURCE})/f/all.bash

if [[ -t 1 ]]; then
  # Run all "interaction" scripts when connected to a terminal (and so have a user)
  source $(dirname ${BASH_SOURCE})/i/all.bash
fi

# Run all of my "last" scripts to finish my Bash environment
source $(dirname ${BASH_SOURCE})/l/all.bash

###################################################################################################
: <<'DisabledContent'
# NOTE: For debugging Bash:
set -o verbose
set -o xtrace

DisabledContent
