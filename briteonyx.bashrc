#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# FIX: remove after development/testing
set -eu

###################################################################################################
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

###################################################################################################
requireToBeSourced "$0" "${BASH_SOURCE[0]}"

###################################################################################################
# Uncomment for debugging/development
# boLogLevel=7
# declare -x boLogLevel

###################################################################################################
# Since this is BriteOnyx's project repository, use it as the framework
# shellcheck disable=SC2034
boFramework="$(dirname "${BASH_SOURCE[0]}")"/framework
>&2 echo "boFramework=${boFramework}"

# FIX: for development/testing
exit 0

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
DisabledContent
