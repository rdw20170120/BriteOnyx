#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
logExecuting ${BASH_SOURCE}

# NOTE: this script MUST be called from each project script,
# since each runs in a new subshell

logDebug "Overriding some configuration for this project for this Bash session"

# Modify PATH for the project
requireDirectoryIn prjPathBin
requireVariable PATH
# shellcheck disable=SC2154
PATH=${prjPathBin}:${PATH}
export PATH
logVariable PATH

# Disable Bash command hashing so that this works
set +h

###############################################################################
: <<'DisabledContent'
DisabledContent
