#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

source "$(dirname "${BASH_SOURCE[0]}")"/terminal.bash
source "$(dirname "${BASH_SOURCE[0]}")"/color.bash
logTrace "Connected to a TTY, configuring for user interaction"
source "$(dirname "${BASH_SOURCE[0]}")"/bash.bash
source "$(dirname "${BASH_SOURCE[0]}")"/dircolors.bash
source "$(dirname "${BASH_SOURCE[0]}")"/fd.bash
source "$(dirname "${BASH_SOURCE[0]}")"/ghostty.bash
source "$(dirname "${BASH_SOURCE[0]}")"/git.bash
source "$(dirname "${BASH_SOURCE[0]}")"/grep.bash
source "$(dirname "${BASH_SOURCE[0]}")"/less.bash
source "$(dirname "${BASH_SOURCE[0]}")"/ls.bash
source "$(dirname "${BASH_SOURCE[0]}")"/nvim.bash
source "$(dirname "${BASH_SOURCE[0]}")"/rg.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
