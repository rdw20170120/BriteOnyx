#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# TODO: Troubleshooting Bash
# source $(parentOf ${BASH_SOURCE})/set.bash
# source $(parentOf ${BASH_SOURCE})/shopt.bash

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "$(parentOf "${BASH_SOURCE[0]}")"/locale.bash
source "$(parentOf "${BASH_SOURCE[0]}")"/machine.bash
source "$(parentOf "${BASH_SOURCE[0]}")"/temp.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
