#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F getAbsolutePath >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
logExecuting ${BASH_SOURCE}

getAbsolutePath() {
  # Return the absolute pathname of file system entry $1
  # NO: `readlink` returns the target of a link, rather than the link itself
  # NO: `realpath` returns the target of a link, rather than the link itself
  logCall getAbsolutePath
  requireArguments $# 1
  logValue $1 '1 pathname'

  requireCommand basename
  requireCommand cd
  requireCommand dirname
  requireCommand pwd

  local Base
  local Dir
  local Pathname=$1
  local Result
  Base=$(basename "${Pathname}")
  Dir=$(dirname "${Pathname}")

  if [[ -d "${Pathname}" ]]; then
    Result=$(cd "${Pathname}" && pwd)
  else
    Result="$(cd "${Dir}" && pwd)/${Base}"
  fi

  echo "${Result}"
  return 0
}
export -f getAbsolutePath

# shellcheck disable=SC2154
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
