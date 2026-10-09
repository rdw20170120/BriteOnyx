#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

source $(dirname ${BASH_SOURCE})/brew.bash
source $(dirname ${BASH_SOURCE})/ran.bash
source $(dirname ${BASH_SOURCE})/pkgx.bash
source $(dirname ${BASH_SOURCE})/PATH.bash

logDone "Bash startup has completed successfully."

###################################################################################################
: <<'DisabledContent'
DisabledContent
