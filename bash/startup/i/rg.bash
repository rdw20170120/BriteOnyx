#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128,SC2139
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

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

  alias sooner="clear; rg --one-file-system ${rgpSooner}"
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
