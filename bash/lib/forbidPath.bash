#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F forbidPath >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

forbidPath() {
  # Forbid path $1
  # $1 = path that is forbidden
  requireArguments $# 1
  requireValue "$1"

  [[ ! -e "$1" ]]
  abortOnFail $? "Forbidden path $1 exists"

  return 0
}
export -f forbidPath

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
