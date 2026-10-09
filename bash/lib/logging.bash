#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail

declare -F _log >/dev/null && return 0
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})
# NO: logExecuting ${BASH_SOURCE}

[[ -v boLogLevel ]] || export boLogLevel=5

# NOTE: These variables are prefixed with `_`
# to make them "private"
# so that they will not pollute the output
# of various commands that list variables
# TODO: Assign generic defaults to these

[[ -v _boColorBad ]] || export _boColorBad=
[[ -v _boColorDebug ]] || export _boColorDebug=
[[ -v _boColorError ]] || export _boColorError=
[[ -v _boColorGood ]] || export _boColorGood=
[[ -v _boColorInfo ]] || export _boColorInfo=
# shellcheck disable=SC2155
[[ -v _boColorReset ]] || export _boColorReset=$(tput sgr0)
[[ -v _boColorTrace ]] || export _boColorTrace=
[[ -v _boColorWarn ]] || export _boColorWarn=

_log() {
  # Log message $1 at priority level $2 with a UTC timestamp
  # $1 = message to log
  # $2 = priority (just one letter)
  # $3 = level (0=nothing, 1=only highest, 6+=everything)
  # $4 = terminal control codes to match priority level styling
  # TODO: Switch to `gdate` to add nanoseconds
  requireArguments $# 4
  requireCommand date

  local -r Text="$1"
  local -r Priority="$2"
  local -ir Level="$3"
  local -r Control="$4"
  local -r Reset="${_boColorReset}"
  local -r Timestamp=$(date -u +"%Y%m%d %H%M%SZ")

  if [[ "${Level}" -le "${boLogLevel}" ]]; then
    1>&2 echo "${Control}[${Timestamp} ${Priority}] ${Text}${Reset}"
  fi
}
export -f _log

logBad() {
  # Log message $1 at BAD priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "B" 1 "${_boColorBad}"
}
export -f logBad

logDebug() {
  # Log message $1 at DEBUG priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "D" 7 "${_boColorDebug}"
}
export -f logDebug

logError() {
  # Log message $1 at ERROR priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "E" 2 "${_boColorError}"
}
export -f logError

logGood() {
  # Log message $1 at GOOD priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "G" 5 "${_boColorGood}"
}
export -f logGood

logInfo() {
  # Log message $1 at INFO priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "I" 4 "${_boColorInfo}"
}
export -f logInfo

logTrace() {
  # Log message $1 at TRACE priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "T" 6 "${_boColorTrace}"
}
export -f logTrace

logWarn() {
  # Log message $1 at WARN priority level
  # $1 = message to log
  requireArguments $# 1
  _log "$1" "W" 3 "${_boColorWarn}"
}
export -f logWarn

###################################################################################################

logAction() {
  # Log message $1 about a script action
  # $1 = message
  requireArguments $# 1
  logInfo "$1"
}
export -f logAction

logActivity() {
  # Log message $1 about a script activity
  # $1 = message
  requireArguments $# 1
  logInfo "$1..."
}
export -f logActivity

logCall() {
  # Log message about calling function $1
  # $1 = name of function being called
  requireArguments $# 1
  logTrace "Called $1"
}
export -f logCall

logDone() {
  # Log message $1 about successfully completing a script activity
  # $1 = message
  requireArguments $# 1
  logGood "$1"
}
export -f logDone

logExecuting() {
  # Log message about executing $1
  # $1 = script pathname, or command being executed
  requireArguments $# 1
  logTrace "Executing $1"
}
export -f logExecuting

logUnavailable() {
  # Log message that command $1 is unavailable
  # $1 = command that is unavailable
  requireArguments $# 1
  logTrace "Skipping command, missing:  $1"
}
export -f logUnavailable

logValue() {
  # Log the value $1 described as $2
  # $1 = value to log
  # $2 = description of that value
  requireArguments $# 2
  logDebug "'$2' = '$1'"
}
export -f logValue

logVariable() {
  # Log the name and value of variable $1
  # $1 = name of variable to log
  requireArguments $# 1
  local -r Name=$1

  requireVariable ${Name}
  logValue "${!Name}" ${Name}
}
export -f logVariable

# shellcheck disable=SC2154
source ${boDirLib}/requireArguments.bash
source ${boDirLib}/requireCommand.bash
source ${boDirLib}/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
