#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

alias base-fd='fd'
alias fd='fd --follow --hidden --no-ignore-vcs --one-file-system'

###################################################################################################
: <<'DisabledContent'
DisabledContent
