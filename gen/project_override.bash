#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

logExecuting "${BASH_SOURCE[0]}"

# This script uses the BriteOnyx framework
# This script MUST be called from each project script,
# since each executes in a new subshell

###############################################################################
: <<'DisabledContent'
logDebug 'Overriding some configuration for this project for this Bash session'

# Modify PATH for this project
# NOTE: project scripts override the rest of PATH
requireDirectoryIn prjPathBin
requireVariable PATH
# shellcheck disable=SC2154
PATH=${prjPathBin}:${PATH}
export PATH
logVariable PATH

# Disable Bash command hashing so that PATH works dynamically
set +h

Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
