#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F changeDirectory >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

changeDirectory() {
  # Change current working directory to $1
  # $1 = target directory
  requireArguments $# 1
  requireDirectory "$1"
  requireCommand cd
  requireCommand pwd

  logDebug "Changing to directory $1"
  cd "$1"
  abortOnFail $? "from 'cd $1'"
  # TODO: Check against `${PWD}`
  # TODO: Check against `$(pwd)`

  return 0
}
export -f changeDirectory

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/logging.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash
source ${boDirLib}/requireDirectory.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
