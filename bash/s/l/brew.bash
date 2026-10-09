#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

# shellcheck disable=SC2154
if [[ "${boOS}" = macOS ]]; then
  if type brew &>/dev/null; then
    case "${boARCH}" in
    arm64)
      # NOTE: Apple macOS running on Apple Silicon
      export HOMEBREW_PREFIX=/opt/homebrew
      ;;
    x86_64)
      # NOTE: Apple macOS running on Intel CPU
      export HOMEBREW_PREFIX=/usr/local
      ;;
    *)
      logBad "HOMEBREW_PREFIX is UNKNOWN for architecture '${boARCH}'"
      unset HOMEBREW_PREFIX
      ;;
    esac

    export boPathHomebrewBefore=${PATH}
    # TODO: Capture script, then `source` it
    eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
    export boPathHomebrewAfter=${PATH}
    export boPathHomebrew=${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin
  else
    logUnavailable brew
  fi
else
  logWarn "Running on ${boOS} rather than 'macOS', so 'brew' is irrelevant"
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
