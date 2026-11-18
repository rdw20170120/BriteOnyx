#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx
# shellcheck disable=SC2154
source "$(require "${boFramework}"/bash/startup/entry_point.bash)"

[[ -v boIsTesting ]] && exit 0

###################################################################################################
: <<'DisabledContent'
DisabledContent
