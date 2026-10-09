#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireDirectory >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

requireDirectory() {
  # Require directory $1
  # $1 = directory that is required
  requireArguments $# 1
  requireValue "$1"

  if [[ ! -d "$1" ]]; then
    abortOnFail 1 "Missing directory '$1'"
  fi

  return 0
}
export -f requireDirectory

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireValue.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
