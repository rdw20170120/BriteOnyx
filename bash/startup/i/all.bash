#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

source $(dirname ${BASH_SOURCE})/terminal.bash
source $(dirname ${BASH_SOURCE})/color.bash
logTrace "Connected to a TTY, configuring for user interaction"
source $(dirname ${BASH_SOURCE})/bash.bash
source $(dirname ${BASH_SOURCE})/dircolors.bash
source $(dirname ${BASH_SOURCE})/fd.bash
source $(dirname ${BASH_SOURCE})/ghostty.bash
source $(dirname ${BASH_SOURCE})/git.bash
source $(dirname ${BASH_SOURCE})/grep.bash
source $(dirname ${BASH_SOURCE})/less.bash
source $(dirname ${BASH_SOURCE})/ls.bash
source $(dirname ${BASH_SOURCE})/nvim.bash
source $(dirname ${BASH_SOURCE})/rg.bash

###################################################################################################
: <<'DisabledContent'
DisabledContent
