#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC2016,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# TODO: detect Neovim first, or not

# NOTE: I am running LazyVim
set +o emacs
set -o vi

export EDITOR=nvim
export VISUAL="${EDITOR}"
alias edit='${EDITOR}'

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
    # shellcheck disable=SC2154
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
${boFramework}/bash/startup/*.bash \
${boFramework}/bash/startup/f/*.bash \
${boFramework}/bash/startup/i/*.bash \
${boFramework}/bash/startup/l/*.bash \
"
}
export -f getBashStartupFiles

_Files='${EDITOR}'
_Files+=' $(getBashConfigFiles)'
_Files+=' $(getBashExecutableFiles)'
_Files+=' $(getBashLibraryFiles)'
_Files+=' $(getBashStartupFiles)'
_Files+=' $(getEnvConfigFiles)'
# shellcheck disable=SC2139
alias edit-config-bash-all="${_Files}"

_Files='${EDITOR}'
_Files+=' $(getBashExecutableFiles)'
# shellcheck disable=SC2139
alias edit-config-bash-exe="${_Files}"

_Files='${EDITOR}'
_Files+=' $(getBashLibraryFiles)'
# shellcheck disable=SC2139
alias edit-config-bash-lib="${_Files}"

_Files='${EDITOR}'
_Files+=' $(getBashConfigFiles)'
_Files+=' $(getBashLibraryFiles)'
_Files+=' $(getBashStartupFiles)'
_Files+=' $(getEnvConfigFiles)'
# shellcheck disable=SC2139
alias edit-config-bash-startup="${_Files}"

_Files='${EDITOR}'
_Files+=' $(getBashExecutableFiles)'
_Files+=' $(getUserExecutableFiles)'
# shellcheck disable=SC2139
alias edit-exe-all="${_Files}"

_Files='${EDITOR}'
_Files+=' ${HOME}/.gitignore'
_Files+=' ${HOME}/.ignore'
_Files+=' ${XDG_CONFIG_HOME}/fd/ignore'
_Files+=' ${XDG_CONFIG_HOME}/rg/.ripgreprc'
_Files+=' ${XDG_CONFIG_HOME}/rg/ignore'
# shellcheck disable=SC2139
alias edit-ignore="${_Files}"

_Files='${EDITOR}'
_Files+=' $(getBashLibraryFiles)'
# shellcheck disable=SC2139
alias edit-lib-all="${_Files}"

unset _Files

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
