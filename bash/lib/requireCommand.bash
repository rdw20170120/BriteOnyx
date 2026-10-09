#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireCommand >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
# NO: logExecuting ${BASH_SOURCE}

requireCommand() {
  # Require command $1
  # $1 = command that is required
  requireArguments $# 1
  requireValue "$1"

  &>/dev/null type $1
  abortOnFail $? "Missing command '$1'"

  return 0
}
export -f requireCommand

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
