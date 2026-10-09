#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# Remember native and original system PATH
# TODO: Research whether I can remove some of Apple's PATH entries
[[ -v boPathOriginal ]] || export boPathOriginal=${PATH}
export boPathNative=${boPathOriginal}

# Homebrew
export boPathHomebrew=${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin

# NO: I CANNOT safely use CoreUtils without breaking macOS
# export boPathCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin
# export boManCoreUtils=${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman

# System portion of PATH
# NOTE: Order matters!
export boPathSystem=${boPathHomebrew}:${boPathNative}

# NO: I CANNOT safely use CoreUtils without breaking macOS
# export boPathSystem=${boPathCoreUtils}:${boPathHomebrew}:${boPathNative}

# Final PATH
# NOTE: Order matters!
# shellcheck disable=SC2154
export PATH=${boPathUser}:${boPathSystem}

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
DisabledContent
