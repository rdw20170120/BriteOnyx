#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

# Dependencies:
# shellcheck disable=SC2154
source "$(require "${boDirLib}"/requireDirectoryIn.bash)"
source "$(require "${boDirLib}"/requireFileIn.bash)"

if [[ ! -v boFileTemplateGit ]]; then
    requireDirectoryIn XDG_CONFIG_HOME
    boFileTemplateGit=${XDG_CONFIG_HOME}/git/template.txt
    declare -x boFileTemplateGit
fi
requireFileIn boFileTemplateGit

###################################################################################################
: <<'DisabledContent'
# TODO: Consider how I might address this commands
alias git_branch_delete='git branch --delete'
alias git_branch_list='git branch --list'
alias git_branch_list_remote='git branch --remotes'
alias git_diff_check='git diff --check'
alias git_log_nice='git log --all --decorate --graph --oneline'
alias git_nostash='git stash clear'
alias git_rebase_abort='git rebase --abort'
alias git_rebase_continue='git rebase --continue'
alias git_rebase_finish='git push origin HEAD --force'
alias git_rebase_prepare='git fetch origin'
alias git_rebase_start='git rebase origin'
alias git_stage='git stage'
alias git_stash='git stash push'
alias git_unstage='git restore --staged'
alias git_unstash='git stash apply'
DisabledContent
