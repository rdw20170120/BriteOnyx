#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F maybeDeleteFile >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

maybeDeleteFile() {
  # Delete file $1, if it exists
  # $1 = file to maybe delete
  requireArguments $# 1
  requireValue "$1"
  requireCommand rm

  if [[ -e "$1" ]]; then
    if [[ -f "$1" ]]; then
      logAction "Deleting file: $1"
      rm "$1"
      abortOnFail $? "from 'rm $1'"
    else
      abortOnFail 99 "Could not delete non-file: $1"
    fi
  else
    logDebug "No filesystem entry exists: $1"
  fi
  forbidPath "$1"

  return 0
}
export -f maybeDeleteFile

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/forbidPath.bash
source ${boDirLib}/logging.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
