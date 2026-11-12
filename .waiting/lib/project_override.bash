#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# This script uses the BriteOnyx framework
# This script MUST be called from each project script,
# since each executes in a new subshell

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireValueIn.bash

logExecuting "${BASH_SOURCE[0]}"

# Modify PATH for this project
# NOTE: disable Bash command hashing so that PATH works dynamically
set +h
# Project scripts override the rest of boPathUser,
# which overrides the rest of PATH
requireValueIn boPathUser
requireValueIn prjPathExe
# shellcheck disable=SC2154
boPathUser=${prjPathExe}:${boPathUser}
declare -x boPathUser
logVariable boPathUser

# Recalculate PATH
# shellcheck disable=SC2154
source "$(require "${boFramework}"/startup/l/PATH.bash)"

# shellcheck disable=SC2154
source "$(require "${prjDirLib}"/reference.bash)"

###############################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
