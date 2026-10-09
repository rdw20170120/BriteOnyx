#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F prepareToSourceOptional >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

prepareToSourceOptional() {
  # Prepare to `source` optional script $1,
  # returning 0 if the script is found and
  # returning 1 if the script is not found
  # $1 = script that is required
  #
  # Should be invoked like this:
  # _Script=DIR/SCRIPT.bash
  # prepareToSourceOptional "${_Script}"; source "${_Script}"
  # unset _Script
  requireArguments $# 1
  requireValue "$1"
  requireVariable _Script

  if [[ -r "$1" ]]; then
    # shellcheck disable=SC2154
    logTrace "Sourcing optional script:  ${_Script}"
  else
    logTrace "Skipping optional script, missing:  ${_Script}"
    return 1
  fi

  return 0
}
export -f prepareToSourceOptional

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash
source ${boDirLib}/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
