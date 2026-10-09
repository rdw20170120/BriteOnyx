#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireScript >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

requireScript() {
  # Require script $1
  # $1 = script that is required
  requireArguments $# 1
  requireValue "$1"

  [[ -r "$1" ]]
  abortOnFail $? "Missing script '$1'"

  return 0
}
export -f requireScript

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
