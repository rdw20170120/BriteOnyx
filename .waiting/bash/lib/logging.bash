#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F _log && return 0

remember "${BASH_SOURCE[0]}"

# NO: logExecuting "${BASH_SOURCE[0]}"

[[ -v boLogLevel ]] || export boLogLevel=5

# NOTE: These variables are prefixed with `_`
# to make them "private"
# so that they will "less" pollute the output
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
    # $3 = level (0=nothing, 1=only highest, 7+=everything)
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
declare -frx _log

logBad() {
    # Log message $1 at BAD priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "B" 1 "${_boColorBad}"
}
declare -frx logBad

logDebug() {
    # Log message $1 at DEBUG priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "D" 7 "${_boColorDebug}"
}
declare -frx logDebug

logError() {
    # Log message $1 at ERROR priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "E" 2 "${_boColorError}"
}
declare -frx logError

logGood() {
    # Log message $1 at GOOD priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "G" 5 "${_boColorGood}"
}
declare -frx logGood

logInfo() {
    # Log message $1 at INFO priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "I" 4 "${_boColorInfo}"
}
declare -frx logInfo

logTrace() {
    # Log message $1 at TRACE priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "T" 6 "${_boColorTrace}"
}
declare -frx logTrace

logWarn() {
    # Log message $1 at WARN priority level
    # $1 = message to log
    requireArguments $# 1
    _log "$1" "W" 3 "${_boColorWarn}"
}
declare -frx logWarn

###################################################################################################

logAction() {
    # Log message $1 about a script action
    # $1 = message
    requireArguments $# 1
    logInfo "$1"
}
declare -frx logAction

logActivity() {
    # Log message $1 about a script activity
    # $1 = message
    requireArguments $# 1
    logInfo "$1..."
}
declare -frx logActivity

logArgument() {
    # Log argument with value $1, index $2, described as $3
    # $1 = argument value
    # $2 = argument positional index
    # $3 = description of that value
    requireArguments $# 3
    logTrace "$2 $3 = '$1'"
}
declare -frx logArgument

logCall() {
    # Log message about calling function $1
    # $1 = name of function being called
    requireArguments $# 1
    logTrace "Called $1"
}
declare -frx logCall

logDone() {
    # Log message $1 about successfully completing a script activity
    # $1 = message
    requireArguments $# 1
    logGood "$1"
}
declare -frx logDone

logExecuting() {
    # Log message about executing $1
    # $1 = script pathname, or command being executed
    requireArguments $# 1
    logTrace "Executing $1"
}
declare -frx logExecuting

logUnavailable() {
    # Log message that command $1 is unavailable
    # $1 = command that is unavailable
    requireArguments $# 1
    logTrace "Skipping command, missing:  $1"
}
declare -frx logUnavailable

logValue() {
    # Log the value $1 described as $2
    # $1 = value to log
    # $2 = description of that value
    requireArguments $# 2
    logDebug "'$2' = '$1'"
}
declare -frx logValue

logVariable() {
    # Log the name and value of variable $1
    # $1 = name of variable to log
    requireArguments $# 1
    local -r Name=$1

    requireVariable "${Name}"
    logValue "${!Name}" "${Name}"
}
declare -frx logVariable

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireVariable.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
