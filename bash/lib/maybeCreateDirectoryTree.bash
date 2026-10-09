#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F maybeCreateDirectoryTree >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

maybeCreateDirectoryTree() {
  # Create directory tree $1, if it does not already exist
  # $1 = directory tree to maybe create
  requireArguments $# 1
  requireValue "$1"
  requireCommand mkdir

  if [[ -d "$1" ]]; then
    logDebug "Directory already exists: $1"
  else
    logAction "Creating directory: $1"
    mkdir -p "$1"
    abortOnFail $? "from 'mkdir -p $1'"
  fi
  requireDirectory "$1"

  return 0
}
export -f maybeCreateDirectoryTree

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/logging.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash
source ${boDirLib}/requireDirectory.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
