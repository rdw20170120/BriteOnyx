#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

# NOTE: Apple macOS handles `LANG`
# and that handles most everything else
# So there seems to be no need to configure locale further on macOS

###################################################################################################
: <<'DisabledContent'
DisabledContent
