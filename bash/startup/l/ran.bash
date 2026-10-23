#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

declare -F ran >/dev/null && return 0

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireVariable.bash

# REFACTOR: create environment variable for tracking file prefix `.ran_`
_Prefix=.ran_

if type gls &>/dev/null; then
    # Show tracking files touched during startup script execution
    requireVariable boFormatDateGls
    # shellcheck disable=SC2139,SC2154
    alias ran="gls \
    --color=auto \
    --time-style='+${boFormatDateGls}' \
    -AFhlrt \
    ${HOME}/${_Prefix}* \
    ${XDG_CONFIG_HOME}/${_Prefix}* \
    ${boFramework}/bash/lib/${_Prefix}* \
    ${boFramework}/bash/startup/${_Prefix}* \
    ${boFramework}/bash/startup/f/${_Prefix}* \
    ${boFramework}/bash/startup/i/${_Prefix}* \
    ${boFramework}/bash/startup/l/${_Prefix}* \
  "
    unset _Pattern
else
    logUnavailable gls
    # TODO: Implement `ran` using `ls` if `gls` is unavailable
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
