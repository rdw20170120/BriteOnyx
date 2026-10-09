#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

if [[ -t 1 ]]; then
  # NOTE: These are based on my current Ghostty color theme,
  # so I need to refactor this appropriately
  # TODO: I am using 0 where the color is not actually represented in the palette
  # TODO: Pick colors above index 15 (if I can) for those colors
  export boIndexColorBlack=0
  export boIndexColorDarkBlack=0
  export boIndexColorDarkBlue=4
  export boIndexColorDarkCyan=6
  export boIndexColorDarkGray=0
  export boIndexColorDarkGreen=2
  export boIndexColorDarkMagenta=13
  export boIndexColorDarkRed=1
  export boIndexColorDarkWhite=8
  export boIndexColorDarkYellow=3
  export boIndexColorLiteBlack=0
  export boIndexColorLiteBlue=12
  export boIndexColorLiteCyan=14
  export boIndexColorLiteGray=0
  export boIndexColorLiteGreen=10
  export boIndexColorLiteMagenta=13
  export boIndexColorLiteRed=9
  export boIndexColorLiteWhite=8
  export boIndexColorLiteYellow=15
  export boIndexColorWhite=8

  # shellcheck disable=SC2155
  export _boColorBad="$(
    tput bold
    tput setaf ${boIndexColorLiteRed}
  )"
  # shellcheck disable=SC2155
  export _boColorDebug="$(
    tput bold
    tput setaf ${boIndexColorDarkBlue}
  )"
  # shellcheck disable=SC2155
  export _boColorError="$(
    tput bold
    tput setaf ${boIndexColorDarkRed}
  )"
  # shellcheck disable=SC2155
  export _boColorGood="$(
    tput bold
    tput setaf ${boIndexColorLiteGreen}
  )"
  # shellcheck disable=SC2155
  export _boColorInfo="$(
    tput bold
    tput setaf ${boIndexColorWhite}
  )"
  # shellcheck disable=SC2155
  export _boColorTrace="$(
    tput bold
    tput setaf ${boIndexColorDarkCyan}
  )"
  # shellcheck disable=SC2155
  export _boColorWarn="$(
    tput bold
    tput setaf ${boIndexColorDarkYellow}
  )"
fi

###################################################################################################
: <<'DisabledContent'
Installed `xtermcontrol`
Can now get current terminal color definitions via `xtermcontrol --get-colorN` for color N
Can now set terminal color via `xtermcontrol --colorN=COLOR`, such as `--color0=`#000000``
TODO: Implement a function to capture the existing color definitions
TODO: Write those definitions to a file
DisabledContent
