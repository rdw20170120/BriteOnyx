#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

alias fd='fd --follow --hidden --ignore-vcs --one-file-system'

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
