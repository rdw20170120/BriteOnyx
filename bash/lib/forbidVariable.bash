#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F forbidVariable >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

forbidVariable() {
  # Forbid variable $1
  # $1 = variable name that is forbidden
  requireArguments $# 1
  requireValue "$1"
  local -r Name=$1
  local -r Value=${!Name:-undefined_variable}

  if [[ "${Value}" != "undefined_variable" ]]; then
    abortOnFail 1 "Forbidden variable '$1' exists"
  fi
}
export -f forbidVariable

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
