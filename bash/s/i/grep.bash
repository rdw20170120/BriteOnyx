#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

export GREP_OPTIONS='--binary-file=without-match --color=auto'

###################################################################################################
: <<'DisabledContent'
DisabledContent
