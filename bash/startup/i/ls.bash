#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# shellcheck disable=SC2154
source ${boDirLib}/logging.bash

if type ls &>/dev/null; then
  # Apple macOS
  # NOTE: `ls` uses `strftime 3` which does not have a format code for subseconds
  export boFormatDateLs="%Y%m%d_%H%M%S"

  # ls -A = include hidden files
  # ls -D = specify date format
  # ls -F = classify nodes with a suffix
  # ls -G = enable color
  # ls -h = use human-readable size unit suffixes
  # ls -l = long format
  # ls -R = recursive
  # ls -X = stay on one device
  alias la='ls -D "${boFormatDateLs}" -AFGhl'
  alias lc='ls -FG'
  alias ll='ls -D "${boFormatDateLs}" -FGhl'
  alias lr='ls -D "${boFormatDateLs}" -FGhlRX'
  alias lR='ls -D "${boFormatDateLs}" -AFGhlRX'

  # Configure colors for `ls`, see `man ls` for details
  # Attributes are:
  #  1.  directory
  #  2.  symbolic link
  #  3.  socket
  #  4.  pipe
  #  5.  executable
  #  6.  block special
  #  7.  character special
  #  8.  executable with setuid
  #  9.  executable with setgid
  # 10.  directory writable by others with sticky
  # 11.  directory writable by others without sticky
  # 12.  dataless file (empty?)
  ################ ddllssppeebbccuugg+s-see
  export LSCOLORS='exExGxgxdxFxFxBxBxBxBxHx'
else
  logUnavailable ls
fi

if type gls &>/dev/null; then
  # GNU coreutils (for Linux, but installed on Apple macOS)
  # NOTE: `gls` uses the same formatting as `gdate` which includes a format code for subseconds
  export boFormatDateGls="%Y%m%d_%H%M%S.%N"

  # gls -A = include hidden files
  # gls -F = classify nodes with a suffix
  # gls -h = use human-readable size unit suffixes
  # gls -l = long format
  # gls -R = recursive
  # gls does not seem to have a flag for staying on one device
  alias gla='gls \
    --color=auto \
    --time-style="+${boFormatDateGls}" \
  -AFhl \
  '
  alias glc='gls \
    --color=auto \
    -F \
  '
  alias gll='gls \
    --color=auto \
    --time-style="+${boFormatDateGls}" \
  -Fhl \
  '
  alias glr='gls \
    --color=auto \
    --time-style="+${boFormatDateGls}" \
  -FhlR \
  '
  alias glR='gls \
    --color=auto \
    --time-style="+${boFormatDateGls}" \
  -AFhlR \
  '
else
  logUnavailable gls
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
