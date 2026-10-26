#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# Remember native and original system PATH
# TODO: Research whether I can remove some of Apple's PATH entries
[[ -v boPathOriginal ]] || export boPathOriginal=${PATH}
[[ -v boPathNative ]] || export boPathNative=${boPathOriginal}

# Homebrew
export boPathHomebrew=${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin
# NO: I CANNOT safely use CoreUtils without breaking macOS
# NO: export boPathCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin
# NO: export boManCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman

# System portion of PATH
# NOTE: Order matters!
export boPathSystem=${boPathHomebrew}:${boPathNative}

# NO: I CANNOT safely use CoreUtils without breaking macOS
# NO: export boPathSystem=${boPathCoreUtils}:${boPathHomebrew}:${boPathNative}

# Final PATH
# NOTE: Order matters!
# shellcheck disable=SC2154
export PATH=${boPathUser}:${boPathSystem}

# TODO: separate MANPATH to its own script
# Remember native and original system MANPATH
# TODO: Research whether I can remove some of Apple's MANPATH entries
[[ -v boManOriginal ]] || export boManOriginal=${MANPATH}
export boManNative=${boManOriginal}

# Final MANPATH
MANPATH=${boManNative}
# NO: I CANNOT safely use CoreUtils without breaking macOS
# export boManCoreUtils=TODO
# GNU must be after macOS man pages, so both can be found by `man`
# MANPATH=${MANPATH}:${boManCoreUtils}
export MANPATH

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
