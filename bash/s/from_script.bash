#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2086
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

source $(dirname ${BASH_SOURCE})/entry_point.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
