#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F abortOnFail >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
# NO: logExecuting ${BASH_SOURCE}

abortOnFail() {
  # Abort execution on fail of previous command
  # $1 = exit status of previous command (from $?)
  # $2 = OPTIONAL message to print on fail

  if [[ "$#" -lt 1 ]] || [[ "$#" -gt 2 ]]; then
    logError "Requires 1-2 argument(s) instead of $#"
    # NOTE: This is one of the VERY few exceptions for calling `exit` from a function
    exit 127
  fi
  local -ir Status=$1
  if [[ ${Status} -ne 0 ]]; then
    if [[ -z "$2" ]]; then
      logBad "Aborting with status ${Status}: Last command failed"
    else
      logBad "Aborting with status ${Status}: $2"
    fi
    # NOTE: This is one of the VERY few exceptions for calling `exit` from a function
    exit ${Status}
  fi

  return 0
}
export -f abortOnFail

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
