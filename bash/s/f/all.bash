#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# TODO: Troubleshooting Bash
# source $(dirname ${BASH_SOURCE})/set.bash
# source $(dirname ${BASH_SOURCE})/shopt.bash
# shellcheck disable=SC2154
source ${boDirLib}/logging.bash
source $(dirname ${BASH_SOURCE})/locale.bash
source $(dirname ${BASH_SOURCE})/machine.bash
source $(dirname ${BASH_SOURCE})/temp.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
