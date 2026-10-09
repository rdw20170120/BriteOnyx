#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

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
DisabledContent
