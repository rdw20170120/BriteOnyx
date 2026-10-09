#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

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
DisabledContent
