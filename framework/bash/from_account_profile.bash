#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

# TODO: consider whether this can be refactored into a 'from_profile.bash' script

requireToBeSourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx
# shellcheck disable=SC2154
source "$(require "${boFramework}"/bash/entry_point.bash)"
