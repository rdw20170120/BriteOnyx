#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

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
