#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash

if type less &>/dev/null; then
    export PAGER=less
    if type lesspipe &>/dev/null; then
        # Make less more friendly for non-text input files, see lesspipe(1)
        # TODO: Consider installing `lesspipe`
        # TODO: Capture script, then `source` it
        eval "$(SHELL=/bin/sh lesspipe)"
    else
        logUnavailable lesspipe
    fi
else
    logUnavailable less
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
