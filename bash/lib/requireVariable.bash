#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireVariable >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

requireVariable() {
  # Require variable $1
  # $1 = name of variable that is required
  requireArguments $# 1
  requireValue "$1"
  local -r _Name=$1
  local -r _Value=${!_Name:-something_unexpected}

  if [[ ${_Value} == something_unexpected ]]; then
    abortOnFail 1 "Undefined variable '${_Name}'"
  fi

  return 0
}
export -f requireVariable

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
