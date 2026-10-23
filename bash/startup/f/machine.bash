#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

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
