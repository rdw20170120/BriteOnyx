#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

source "$(dirname "${BASH_SOURCE[0]}")"/entry_point.bash

# shellcheck disable=SC2154
source "${boDirLib}"/changeDirectory.bash

changeDirectory "${HOME}"

# Disable `errexit` in user's session
# TODO: in an `EXIT` `trap`
set +o errexit
# Disable `trap` in user's session
trap --

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
