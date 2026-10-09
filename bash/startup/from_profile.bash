#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

source $(dirname ${BASH_SOURCE})/entry_point.bash

# shellcheck disable=SC2154
source ${boDirLib}/changeDirectory.bash

changeDirectory ${HOME}

# Disable `errexit` in user's session
# TODO: in an `EXIT` `trap`
set +o errexit
# Disable `trap` in user's session
trap --

###################################################################################################
: <<'DisabledContent'
DisabledContent
