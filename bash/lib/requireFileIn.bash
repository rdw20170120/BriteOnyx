#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireFileIn >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

requireFileIn() {
  # Require file referenced in variable $1
  # $1 = variable holding reference to file that is required
  requireArguments $# 1
  requireVariable "$1"
  local -r Name=$1

  requireFile "${!Name}"

  return 0
}
export -f requireFileIn

# shellcheck disable=SC2154
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireFile.bash
source ${boDirLib}/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
