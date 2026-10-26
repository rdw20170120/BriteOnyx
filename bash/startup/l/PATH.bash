#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# Remember original (as-is) PATH, which may have been captured earlier
[[ -v boPathOriginal ]] || export boPathOriginal=${PATH}

# Remember native PATH, which could and should be optimized by the user
# TODO: Research whether I can remove some of Apple's PATH entries
[[ -v boPathNative ]] || export boPathNative=${boPathOriginal}

# Homebrew
# TODO: move this to the `brew.bash` script
boPathHomebrew=${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin
declare -rx boPathHomebrew

# NO: I CANNOT safely use CoreUtils without breaking macOS
# NO: boManCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman
# NO: boPathCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin
# NO: I CANNOT safely use CoreUtils without breaking macOS
# NO: boPathSystem=${boPathCoreUtils}:${boPathHomebrew}:${boPathNative}
# NO: I CANNOT safely use CoreUtils without breaking macOS
# export boManCoreUtils=TODO
# GNU must be after macOS man pages, so both can be found by `man`
# MANPATH=${MANPATH}:${boManCoreUtils}

# System portion of PATH
# Order matters!
boPathSystem=
[[ -v boPathHomebrew ]] && boPathSystem+=${boPathHomebrew}
boPathSystem+=:${boPathNative}
declare -x boPathSystem

# Final PATH
# Order matters!
# shellcheck disable=SC2154
PATH=${boPathUser}:${boPathSystem}
declare -x PATH

# Remember native and original system MANPATH
# TODO: separate MANPATH to its own script
# TODO: Research whether I can remove some of Apple's MANPATH entries
[[ -v boManOriginal ]] ||
    boManOriginal=${MANPATH} &&
    declare -x boManOriginal
[[ -v boManNative ]] ||
    boManNative=${boManOriginal} &&
    declare -x boManNative

# Final MANPATH
MANPATH=${boManNative}
declare -x MANPATH

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
