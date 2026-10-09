#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireFileIn >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

requireValueIn() {
  # Require value referenced in variable $1
  # $1 = variable holding reference to value that is required
  requireArguments $# 1
  requireVariable "$1"
  local -r Name=$1

  requireValue "${!Name}"

  return 0
}
export -f requireValueIn

# shellcheck disable=SC2154
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash
source ${boDirLib}/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
