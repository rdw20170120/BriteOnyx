#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

source "$(dirname "${BASH_SOURCE[0]}")"/brew.bash
source "$(dirname "${BASH_SOURCE[0]}")"/ran.bash
source "$(dirname "${BASH_SOURCE[0]}")"/pkgx.bash
source "$(dirname "${BASH_SOURCE[0]}")"/PATH.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
