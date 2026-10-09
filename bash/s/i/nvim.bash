#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2016,SC2046,SC2086,SC2096,SC2128,SC2139
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# NOTE: I am running LazyVim
set +o emacs
set -o vi

export EDITOR=nvim
export VISUAL="${EDITOR}"
alias edit="${EDITOR}"

# LazyVim's default plugins recognize these special comments:
#
# FIX plus BUG, FIXME, FIXIT, ISSUE
# HACK
# NOTE plus INFO
# PERF plus OPTIM, OPTIMIZE, PERFORMANCE
# TEST plus FAILED, PASSED, TESTING
# TODO
# WARN plus WARNING, XXX
#
# I will use only the first variants of each.

# Define sets of Files to edit
# TODO: refactor for general reuse

getBashConfigFiles() {
  echo "\
${HOME}/.bash_login \
${HOME}/.bash_logout \
${HOME}/.bash_profile_NO \
${HOME}/.bashrc \
${HOME}/.profile \
"
}
export -f getBashConfigFiles

getEnvConfigFiles() {
  echo "\
${XDG_CONFIG_HOME}/*.env \
"
}
export -f getEnvConfigFiles

getUserExecutableFiles() {
  echo "\
${HOME}/bin/* \
"
}
export -f getUserExecutableFiles

getBashExecutableFiles() {
  echo "\
${boFramework}/bash/bin/* \
"
}
export -f getBashExecutableFiles

getBashLibraryFiles() {
  echo "\
${boFramework}/bash/lib/*.bash \
"
}
export -f getBashLibraryFiles

getBashStartupFiles() {
  echo "\
${boFramework}/bash/s/*.bash \
${boFramework}/bash/s/f/*.bash \
${boFramework}/bash/s/i/*.bash \
${boFramework}/bash/s/l/*.bash \
"
}
export -f getBashStartupFiles

_Files=''
_Files+=' $(getBashConfigFiles)'
_Files+=' $(getBashExecutableFiles)'
_Files+=' $(getBashLibraryFiles)'
_Files+=' $(getBashStartupFiles)'
_Files+=' $(getEnvConfigFiles)'
alias edit-config-bash-all="${EDITOR}${_Files}"

_Files=''
_Files+=' $(getBashExecutableFiles)'
alias edit-config-bash-exe="${EDITOR}${_Files}"

_Files=''
_Files+=' $(getBashLibraryFiles)'
alias edit-config-bash-lib="${EDITOR}${_Files}"

_Files=''
_Files+=' $(getBashConfigFiles)'
_Files+=' $(getBashLibraryFiles)'
_Files+=' $(getBashStartupFiles)'
_Files+=' $(getEnvConfigFiles)'
alias edit-config-bash-startup="${EDITOR}${_Files}"

_Files=''
_Files+=' $(getBashExecutableFiles)'
_Files+=' $(getUserExecutableFiles)'
alias edit-exe-all="${EDITOR}${_Files}"

_Files=''
_Files+=' ${HOME}/.gitignore'
_Files+=' ${HOME}/.ignore'
_Files+=' ${XDG_CONFIG_HOME}/fd/ignore'
_Files+=' ${XDG_CONFIG_HOME}/rg/.ripgreprc'
_Files+=' ${XDG_CONFIG_HOME}/rg/ignore'
alias edit-ignore="${EDITOR}${_Files}"

_Files=''
_Files+=' $(getBashLibraryFiles)'
alias edit-lib-all="${EDITOR}${_Files}"

unset _Files

###################################################################################################
: <<'DisabledContent'
DisabledContent
