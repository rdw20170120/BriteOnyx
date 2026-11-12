#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# Dependencies:
# shellcheck disable=SC2154
source "$(require "${boDirLib}"/execute.bash)"
source "$(require "${boDirLib}"/logging.bash)"
source "$(require "${boDirLib}"/requireDirectoryIn.bash)"

logExecuting "${BASH_SOURCE[0]}"

requireDirectoryIn HOME
requireDirectoryIn XDG_CONFIG_HOME

getFilesBashConfig() {
    echo "\
${HOME}/.bash_login \
${HOME}/.bash_logout \
${HOME}/.bash_profile_NO \
${HOME}/.bashrc \
${HOME}/.profile \
"
}
declare -frx getFilesBashConfig

getFilesBashExecutable() {
    execute fd -atf "${XDG_CONFIG_HOME}"/bash/bin
}
declare -frx getFilesBashExecutable

getFilesOtherConfig() {
    echo "\
${HOME}/.ssh/config \
"
}
declare -frx getFilesOtherConfig

getFilesZshConfig() {
    echo "\
${HOME}/.zshenv \
${XDG_CONFIG_HOME}/zsh/.zlogin \
${XDG_CONFIG_HOME}/zsh/.zlogout \
${XDG_CONFIG_HOME}/zsh/.zprofile \
${XDG_CONFIG_HOME}/zsh/.zshrc \
"
}
declare -frx getFilesZshConfig

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
