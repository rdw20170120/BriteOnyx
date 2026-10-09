#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

if type ghostty &>/dev/null; then
  # Set in `~/.config/ghostty/config`:
  # Reported by `ghostty +show-config` as `theme`
  # TODO: Do I actually need this?  What do I need?
  export boColorTheme='Solarized Dark Higher Contrast'
else
  logUnavailable ghostty
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
