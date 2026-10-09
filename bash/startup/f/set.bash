#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# TODO: Implement check of ALL shell settings

# My overrides
set +o allexport
set +o emacs
set +o interactive-comments
set +o keyword
set +o noclobber
set +o noglob
set +o onecmd
set -o braceexpand
set -o hashall
set -o history
set -o ignoreeof
set -o nolog
set -o nounset
set -o physical
set -o pipefail
set -o vi

# NOTE: Allow these to default (at least for now)
# NO: set +o histexpand
# NO: set +o monitor
# NO: set +o privileged

# FIX: These have been resulting in "flips"
# FIX: NO: set +o histexpand
# FIX: set -o history
# FIX: NO: set +o monitor
set -o histexpand
set -o history
set -o monitor

# Keep this on while configuring Bash, then shut it off when done
set -o errexit

###################################################################################################
: <<'DisabledContent'
# Show Bash's currently-active short options: `printf %s\\n "$-"`
# Show Bash's currently-active options: `set -o | grep -Fw on`

# Consider using some of these
set +o notify
set +o posix

# Only when debugging
set +o errtrace
set +o functrace
set +o noexec
set +o verbose
set +o xtrace

DisabledContent
