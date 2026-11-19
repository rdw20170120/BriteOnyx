#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

requireBriteOnyx

###################################################################################################
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boDirLib=${boFramework}/bash/lib
declare -rx boDirLib

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -rx boFramework

###################################################################################################
# logDone "BriteOnyx framework successfully activated in ${boFramework}"
