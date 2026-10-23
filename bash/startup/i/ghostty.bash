#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

# I am using Ghostty as my terminal.
# I have configured Ghostty
# with "Solarized Dark Higher Contrast"
# as my color theme.
# Ghostty imports its color themes
# from iTerm2.
#
# Ghostty exports COLORTERM=truecolor

# REF: https://ghostty.org/docs/features/theme
# REF: https://iterm2colorschemes.com/

if type ghostty &>/dev/null; then
    # Set in `${XDG_CONFIG_HOME}/ghostty/config`:
    # Reported by `ghostty +show-config` as `theme`
    # TODO: Do I actually need this?  What do I need?
    export boColorTheme='Solarized Dark Higher Contrast'
else
    logUnavailable ghostty
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
