#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash
source ${boDirLib}/requireCommand.bash

requireCommand mkdir

export boDirTemp=${HOME}/tmp
if [[ ! -e "${boDirTemp}" ]]; then
  logAction "Creating directory '${boDirTemp}'"
  mkdir "${boDirTemp}"
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
