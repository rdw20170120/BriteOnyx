#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

remember "${BASH_SOURCE[0]}"

>/dev/null declare -F checkUsability && return 0

_checkUsabilityAllowBoth() {
    # Show status of 'set' option $1, allowing both enabled or disabled
    requireArguments $# 1

    [[ -o $1 ]] || logDebug "'set' option '$1' is disabled"
    [[ -o $1 ]] && logDebug "'set' option '$1' is enabled"

    return 0
}
declare -frx _checkUsabilityAllowBoth

_checkUsabilityPreferDisabled() {
    # Show status of 'set' option $1, preferring that it be disabled
    requireArguments $# 1

    [[ -o $1 ]] || logDebug "'set' option '$1' is disabled"
    [[ -o $1 ]] && logWarn "'set' option '$1' is enabled, but we prefer disabled"

    return 0
}
declare -frx _checkUsabilityPreferDisabled

_checkUsabilityPreferEnabled() {
    # Show status of 'set' option $1, preferring that it be enabled
    requireArguments $# 1

    [[ -o $1 ]] || logWarn "'set' option '$1' is disabled, but we prefer enabled"
    [[ -o $1 ]] && logDebug "'set' option '$1' is enabled"

    return 0
}
declare -frx _checkUsabilityPreferEnabled

checkUsability() {
    # Check shell usability, for an interactive user
    requireArguments $# 0

    logActivity "Checking shell usability, for the sake of the human"

    _checkUsabilityPreferDisabled allexport
    _checkUsabilityPreferEnabled braceexpand
    _checkUsabilityAllowBoth emacs
    _checkUsabilityPreferDisabled errexit
    _checkUsabilityPreferDisabled errtrace
    _checkUsabilityPreferDisabled functrace
    _checkUsabilityPreferDisabled hashall
    _checkUsabilityAllowBoth histexpand
    _checkUsabilityAllowBoth history
    _checkUsabilityAllowBoth ignoreeof
    _checkUsabilityPreferDisabled interactive-comments
    _checkUsabilityPreferDisabled keyword
    _checkUsabilityAllowBoth monitor
    _checkUsabilityPreferDisabled noclobber
    _checkUsabilityPreferDisabled noexec
    _checkUsabilityPreferDisabled noglob
    _checkUsabilityAllowBoth nolog
    _checkUsabilityAllowBoth notify
    _checkUsabilityPreferEnabled nounset
    _checkUsabilityPreferDisabled onecmd
    _checkUsabilityPreferDisabled physical
    _checkUsabilityPreferEnabled pipefail
    _checkUsabilityPreferDisabled posix
    _checkUsabilityPreferDisabled privileged
    _checkUsabilityPreferDisabled verbose
    _checkUsabilityAllowBoth vi
    _checkUsabilityPreferDisabled xtrace

    logDone "Check complete"
    return 0
}
declare -frx checkUsability

# shellcheck disable=SC2154
source "${boDirLib}"/logging.bash
source "${boDirLib}"/requireArguments.bash

###################################################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
