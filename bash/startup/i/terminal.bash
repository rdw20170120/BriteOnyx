#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
if [[ "${boOS}" = macOS ]]; then
  if [[ -v COLORTERM ]]; then
    # Activate color for `ls` output on Apple macOS
    export CLICOLOR=1
  fi
fi

###################################################################################################
: <<'DisabledContent'
# NOTE: I don't seem to need any of this.
# Address it if I ever have a need.

################################################################################
if type tput &> /dev/null; then
  # TODO: whether `tput init` overrides my Ghostty color theme
  # How do I tell?
  tput init
else
  logUnavailable tput
fi

################################################################################
# Set a fancy prompt
# (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

################################################################################
# Uncomment for a colored prompt,
# if the terminal has the capability;
# turned off by default
# to not distract the user:
# the focus in a terminal window
# should be on the output of commands,
# not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support;
    # assume it's compliant with Ecma-48 (ISO/IEC-6429).
    # Lack of such support is extremely rare,
    # and such a case
    # would tend to support setf rather than setaf.
    color_prompt=yes
  else
    color_prompt=
  fi
fi

################################################################################
# If this is an xterm
# set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
  *)
    ;;
esac

unset color_prompt force_color_prompt

DisabledContent
