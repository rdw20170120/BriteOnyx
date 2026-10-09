#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# Configure for jumping to working directories for source-control repositories
alias jump_dotfile='cd ~'
alias jump_email='cd ~/repo/GitHub/wip/argent_xiphias'
alias jump_eternium='cd ~/repo/GitHub/wip/eternium'
alias jump_hypermedia='cd ~/repo/SourceHut/wip/castory_onager'
alias jump_ledger='cd ~/repo/GitHub/wip/lime_quarrion'
alias jump_personal='cd ~/repo/GitHub/wip/personal'
alias jump_solarized='cd ~/repo/Codeberg/wip/wheaten_desman'
alias jump_workstation='cd ~/repo/GitHub/wip/workstation'

###################################################################################################
: <<'DisabledContent'
# For working with two local copies of the same repository
[[ -v boDirRef ]] || export boDirRef=~/repo/GitHub/ref/dotfile
[[ -v boDirWip ]] || export boDirWip=~/repo/GitHub/wip/dotfile

alias jump_ref='cd "${boDirRef}"'
alias jump_wip='cd "${boDirWip}"'
alias sync_wip='dir-merge "${boDirRef}" "${boDirWip}"'
DisabledContent
