#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F changeDirectoryIn >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

changeDirectoryIn() {
  # Require directory referenced in variable $1
  # $1 = variable holding reference to directory that is required
  requireArguments $# 1
  requireVariable "$1"
  local -r Name=$1

  changeDirectory "${!Name}"

  return 0
}
export -f changeDirectoryIn

# shellcheck disable=SC2154
source ${boDirLib}/changeDirectory.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
