#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

git config --global commit.template "${XDG_CONFIG_HOME}/git/template.txt"

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
