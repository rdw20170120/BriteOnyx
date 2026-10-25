#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Declare only once--the first time--otherwise skip
declare -F FUNCTION_NAME >/dev/null && return 0

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"
logExecuting "${BASH_SOURCE[0]}"
# NO: logExecuting "${BASH_SOURCE[0]}"

FUNCTION_NAME() {
    # DESCRIPTION
    logCall FUNCTION_NAME
    requireArguments $# 0
    logArgument "$1" 1 'DESCRIPTION'

    # TODO: implement

    return 0
}
declare -fx FUNCTION_NAME

# Dependencies:
# NOTE: include only those functions actually used in this script
# shellcheck disable=SC2154
source "${boDirLib}"/abortOnFail.bash
source "${boDirLib}"/changeDirectory.bash
source "${boDirLib}"/changeDirectoryIn.bash
source "${boDirLib}"/execute.bash
source "${boDirLib}"/forbidPath.bash
source "${boDirLib}"/forbidVariable.bash
source "${boDirLib}"/getAbsolutePath.bash
source "${boDirLib}"/getTemporaryFile.bash
source "${boDirLib}"/gitStatusIsClean.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/maybeCreateDirectoryTree.bash
source "${boDirLib}"/maybeDeleteDirectoryTree.bash
source "${boDirLib}"/maybeDeleteFile.bash
source "${boDirLib}"/parentOf.bash
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

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
