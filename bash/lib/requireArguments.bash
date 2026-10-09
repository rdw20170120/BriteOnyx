#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F requireArguments >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
# NO: logExecuting ${BASH_SOURCE}

requireArguments() {
  # Require that caller received expected number of arguments
  # $1 = actual number of arguments (from $#) received by caller
  # $2 = expected number of arguments

  if [[ $# -ne 2 ]]; then
    logError "Function 'requireArguments' requires 2 arguments instead of $#"
    exit 127
  fi
  if [[ $1 -ne $2 ]]; then
    logError "Requires $2 argument(s) instead of $1"
    exit 1
  fi

  return 0
}
export -f requireArguments

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
