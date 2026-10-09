#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1090,SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

if type gdircolors &>/dev/null; then
  # shellcheck disable=SC2154
  source ${boDirLib}/logging.bash
  source ${boDirLib}/prepareToSourceOptional.bash

  # NOTE: I manually copied and edited `dircolors-database-custom.out`
  gdircolors --bourne-shell $(dirname ${BASH_SOURCE})/dircolors-database-custom.out \
    >$(dirname ${BASH_SOURCE})/dircolors-LS_COLORS-custom.out

  _Script=$(dirname ${BASH_SOURCE})/dircolors-LS_COLORS-custom.out
  prepareToSourceOptional ${_Script} && source ${_Script}

  # NOTE: Valid `$LS_COLORS` syntax for `gls`
  # is invalid syntax for Apple macOS `ls`
  # NO: export LSCOLORS="${LS_COLORS}"
else
  logUnavailable gdircolors
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
