#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
# boLogLevel=7
# export boLogLevel

# Skip if already declared
>/dev/null declare -F FUNCTION_NAME && return 0

remember "${BASH_SOURCE[0]}"

# NO: logExecuting "${BASH_SOURCE[0]}"
logExecuting "${BASH_SOURCE[0]}"

FUNCTION_NAME() {
    executing "${BASH_SOURCE[0]}" "${FUNCNAME[0]}"
    # TODO: DESCRIPTION
    # TODO: requireArguments $# 0
    # TODO: logArgument "$1" 1 'DESCRIPTION'

    # TODO: implement

    return 0
}
declare -frx FUNCTION_NAME

# NOTE: include only those functions actually used in this script
# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/changeDirectory.bash
source "${boDirLib}"/changeDirectoryIn.bash
source "${boDirLib}"/execute.bash
source "${boDirLib}"/forbidPath.bash
source "${boDirLib}"/forbidVariable.bash
source "${boDirLib}"/getTemporaryFile.bash
source "${boDirLib}"/gitStatusIsClean.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/maybeCreateDirectoryTree.bash
source "${boDirLib}"/maybeDeleteDirectoryTree.bash
source "${boDirLib}"/maybeDeleteFile.bash
source "${boDirLib}"/prepareToSourceOptional.bash
source "${boDirLib}"/requireArguments.bash
source "${boDirLib}"/requireCommand.bash
source "${boDirLib}"/requireDirectory.bash
source "${boDirLib}"/requireDirectoryIn.bash
source "${boDirLib}"/requireFile.bash
source "${boDirLib}"/requireFileIn.bash
source "${boDirLib}"/requireScript.bash
source "${boDirLib}"/requireValue.bash
source "${boDirLib}"/requireValueIn.bash
source "${boDirLib}"/requireVariable.bash
source "${boDirLib}"/showRan.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
