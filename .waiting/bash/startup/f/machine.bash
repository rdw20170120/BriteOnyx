#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# shellcheck disable=SC2155
[[ -v boARCH ]] || export boARCH=$(uname -m)

# shellcheck disable=SC2155
[[ -v boOS ]] || export boOS=$(uname)
# Change reference to Apple macOS for readability
[[ "${boOS}" = 'Darwin' ]] && export boOS=macOS

if [[ "${boOS}" = macOS ]]; then
    # Tell Apple macOS to shut up about `zsh` already!
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
