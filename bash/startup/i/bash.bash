#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Remember that we executed this script, but not by (problematic) logging during shell startup
touch "$(dirname "${BASH_SOURCE[0]}")"/.ran_"$(basename "${BASH_SOURCE[0]}")"

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash

# TODO: Reconsider where all of these belong
# TODO: Consider other environment variables that configure Bash
# export FIGNORE=
# export GLOBIGNORE=
# export HISTTIMEFORMAT=
# export TIMEFORMAT=
export HISTCONTROL=ignoreboth
export HISTFILESIZE=500
export HISTSIZE=500

################################################################################
# Enable programmable completion features
# You don't need to enable this
# if it's already enabled in /etc/bash.bashrc
# and /etc/profile sources /etc/bash.bashrc.
# TODO: Consider installing Bash completions via `brew`
if shopt -oq posix; then
    logWarn "Running in POSIX mode, so skipping Bash completions"
else
    source "${boDirLib}"/prepareToSourceOptional.bash

    _Script=/usr/share/bash-completion/bash_completion
    if prepareToSourceOptional ${_Script}; then
        source ${_Script}
    else
        _Script=/etc/bash_completion
        if prepareToSourceOptional ${_Script}; then
            source ${_Script}
        fi
    fi
    unset _Script
fi

alias restart='exec bash'
alias retest='boLogLevel=6 bash -i; echo "Status = $?"'
alias status='echo "Status = $?"'

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
