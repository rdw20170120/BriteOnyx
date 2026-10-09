#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireValue >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
# NO: logExecuting ${BASH_SOURCE}

requireValue() {
  # Require value $1
  # $1 = value that is required
  requireArguments $# 1

  if [[ -z "$1" ]]; then
    abortOnFail 1 "Missing value"
  fi

  return 0
}
export -f requireValue

# shellcheck disable=SC2154
source ${boDirLib}/abortOnFail.bash
source ${boDirLib}/requireArguments.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
