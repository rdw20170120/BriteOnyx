#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash

# Apple macOS handles `LANG`
# and that handles most everything else
# So there seems to be no need
# to configure locale further
# on macOS

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
