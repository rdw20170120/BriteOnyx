#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

if type rg &>/dev/null; then
    RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME}/rg/.ripgreprc
    export RIPGREP_CONFIG_PATH

    # My overrides
    # TODO: Remove unneeded types
    # TODO: Add desired but missing types

    alias ra='rg -.LS --one-file-system'

    # Regular expression patterns to use with `rg`
    export rgpFix='\bFIX\b'
    export rgpFunction='^\w+\(\)'
    export rgpNote='\bNOTE\b'
    export rgpToDo='\bTODO\b'

    export rgpSooner="'${rgpFix}|${rgpToDo}'"

    # shellcheck disable=SC2139
    alias sooner="clear; rg --one-file-system ${rgpSooner}"
fi

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
