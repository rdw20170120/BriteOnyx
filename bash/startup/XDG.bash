#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# TODO: requireDirectoryIn HOME

# Apply XDG standard defaults to make them explicit
# NO: XDG_RUNTIME_HOME, too complicated
declare -x XDG_CACHE_HOME=${HOME}/.cache
declare -x XDG_CONFIG_DIRS=/etc/xdg
declare -x XDG_CONFIG_HOME=${HOME}/.config
# TODO: move Ghostty reference
declare -x XDG_DATA_DIRS=/usr/local/share:/usr/share:/Applications/Utilities/Ghostty.app/Contents/Resources
declare -x XDG_DATA_HOME=${HOME}/.local/share
declare -x XDG_STATE_HOME=${HOME}/.local/state

# Described in standard, but not given a name
declare -x XDG_ExeHome=${HOME}/.local/bin

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
