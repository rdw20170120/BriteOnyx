#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F getTemporaryFile >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

getTemporaryFile() {
  # Return a temporary file absolute pathname
  # Uses `$boDirTemp`
  requireArguments $# 0
  requireDirectoryIn boDirTemp
  requireCommand mktemp

  # shellcheck disable=SC2154
  mktemp ${boDirTemp}/XXXXXXXX
  abortOnFail $? "from 'mktemp'"

  return 0
}
export -f getTemporaryFile

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash
source ${boDirLib}/requireDirectoryIn.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
