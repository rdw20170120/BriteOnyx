#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# TODO: Use this script instead to test XDG configuration values

###################################################################################################
: <<'DisabledContent'
DisabledContent
