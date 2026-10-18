#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F gitStatusIsClean >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

gitStatusIsClean() {
  # Return whether status of git working directory $1 is clean
  # $1 = git working directory
  # Exit code 0 = clean
  # Exit code 1 = dirty
  requireArguments $# 1

  requireCommand git
  requireCommand wc

  changeDirectory $1
  logTrace "Gathering status of this git repository"
  local -ir _Count=$(git status --porcelain | wc -l)
  if [[ ${_Count} -gt 0 ]]; then
    return 1
  fi

  return 0
}
export -f gitStatusIsClean

# shellcheck disable=SC2154
source ${boDirLib}/changeDirectory.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
