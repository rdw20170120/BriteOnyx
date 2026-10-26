#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

if type gdircolors &>/dev/null; then
    # shellcheck disable=SC2154
    source "${boDirLib}"/logging.bash
    source "${boDirLib}"/prepareToSourceOptional.bash

    # NOTE: I manually copied and edited `dircolors-database-custom.out`
    >"$(dirname "${BASH_SOURCE[0]}")"/dircolors-LS_COLORS-custom.out gdircolors \
        --bourne-shell \
        "$(dirname "${BASH_SOURCE[0]}")"/dircolors-database-custom.out

    _Script="$(dirname "${BASH_SOURCE[0]}")"/dircolors-LS_COLORS-custom.out
    prepareToSourceOptional "${_Script}" && source "${_Script}"

    # Valid `$LS_COLORS` syntax for `gls` is invalid syntax for Apple macOS `ls`
    # NO: export LSCOLORS="${LS_COLORS}"
else
    logUnavailable gdircolors
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
