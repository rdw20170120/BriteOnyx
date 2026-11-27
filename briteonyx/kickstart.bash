#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2004,SC2034,SC2154
# vim: set ft=bash:

>&2 echo "TRACE: Running ${BASH_SOURCE[0]}"

# For now, hard-code shell option assignments
# TODO: consider how to uniquely assign each shell option
# to disable/enable
# for interacting/scripting
# while addressing whether each belongs
# to shopt or set (long/short)
# TODO: perhaps I could add each to variables
# that are space-delimited
# so then they could be easily iterated

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "ERROR: BASH_SOURCE[0] is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, script '$0' MUST be sourced instead of executed"
    exit 1
fi

###################################################################################################
# Verify executing shell
>&2 echo "DEBUG: '0'='${0}'"
>&2 echo "DEBUG: 'BASH'='${BASH:-}'"
>&2 echo "DEBUG: 'BASH_VERSION'='${BASH_VERSION:-}'"
>&2 echo "DEBUG: 'POSIXLY_CORRECT'='${POSIXLY_CORRECT:-}'"

if (("${BASH_VERSINFO[0]:-}" < 5)); then
    >&2 echo "FATAL: Aborting, written for Bash version 5.3.20, NOT '${BASH_VERSION}'"
    exit 1
fi
if [[ "${POSIXLY_CORRECT:-}" == 'y' ]]; then
    >&2 echo "FATAL: Aborting, POSIXLY_CORRECT='y', NOT written for POSIX"
    exit 1
fi

###################################################################################################

_log() { >&2 printf '%s\n' "$1"; }
declare -frx _log

_requireToBeExecuted() {
    # Require the calling script to be executed, NOT 'source'd
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    requireArguments "${FUNCNAME[0]}" $# 2
    local -r _Executable=$1
    local -r _Script=$2

    if [[ -z "${_Script}" ]]; then
        fail 1 "Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
    fi
    if [[ "${_Script}" != "${_Executable}" ]]; then
        fail 1 "Aborting, cannot source, MUST execute script '${_Executable}'"
    fi

    return 0
}
declare -frx _requireToBeExecuted

_requireToBeSourced() {
    # Require the calling script to be 'source'd, NOT executed
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    requireArguments "${FUNCNAME[0]}" $# 2
    local -r _Executable=$1
    local -r _Script=$2

    if [[ "${_Executable}" != bash ]]; then
        logDebug "Executable '$0' is NOT 'bash' in '${_Script}'"
    fi
    if [[ -z "${_Script}" ]]; then
        fail 1 "Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
    fi
    if [[ "${_Script}" == "${_Executable}" ]]; then
        fail 1 "Aborting, cannot execute, MUST source script '${_Executable}'"
    fi

    return 0
}
declare -frx _requireToBeSourced

abortOnFail() {
    # Abort execution on failure of previous command
    # $1 = exit status of previous command (from $?)
    # $2 = message to print on fail (optional)
    if (($# < 1)) || ((2 < $#)); then
        logError "'${FUNCNAME[0]}' requires 1-2 argument(s) instead of $#"
        # NOTE: This is one of the VERY few exceptions to calling 'exit' directly from a function
        exit 1
    fi
    local -ir _Status=$1
    local -r _Message=$2

    if ((${_Status} != 0)); then
        if [[ -z "${_Message}" ]]; then
            logFatal "Aborting with status ${_Status}: Last command failed"
        else
            logFatal "Aborting with status ${_Status}: ${_Message}"
        fi
        # NOTE: This is one of the VERY few exceptions to calling 'exit' directly from a function
        exit ${_Status}
    fi

    return 0
}
declare -frx abortOnFail

absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")
    requireArguments "${FUNCNAME[0]}" $# 1
    local -r _Pathname=$1

    if [[ -d "${_Pathname}" ]]; then
        _Result=${_Pathname}
        if cd -- "${_Result}"; then
            _Result=$(pwd -P)
        else
            fail 1 "Could not 'cd' to '${_Result}'"
        fi
    else
        _Result=${_Pathname}
        _Result=$(dirname -- "${_Result}")
        if cd -- "${_Result}"; then
            _Result=$(pwd -P)
            _Result=${_Result}/$(basename -- "${_Pathname}")
        else
            fail 1 "Could not 'cd' to '${_Result}'"
        fi
    fi

    echo "${_Result}"
}
declare -frx absolute

applySetLongOption() { set "$2" "$1"; }
declare -frx applySetLongOption
applySetShortOption() { set "$2""$1"; }
declare -frx applySetShortOption
applyShoptOption() { shopt "$2" "$1"; }
declare -frx applyShoptOption

# shellcheck disable=SC2120
assembleAll() {
    # Assemble all paths and related environment variables
    requireArguments "${FUNCNAME[0]}" $# 0

    assembleXdg
    assembleManpath
    assemblePath

    return 0
}
declare -frx assembleAll

# shellcheck disable=SC2120
assembleManpath() {
    # Assemble MANPATH environment variable
    requireArguments "${FUNCNAME[0]}" $# 0

    [[ -n "${boManpathInherited:-}" ]] || boManpathInherited=${MANPATH:-}
    # [[ -n "${boManpathInherited:-}" ]] && declare -gx boManpathInherited=${boManpathInherited}
    [[ -n "${boManpathInherited:-}" ]] && declare -gx boManpathInherited

    boManpath=
    [[ -n "${boProjectManpath:-}" ]] && boManpath+=${boProjectManpath:-}:
    [[ -n "${boAccountManpath:-}" ]] && boManpath+=${boAccountManpath:-}:
    [[ -n "${boSystemManpath:-}" ]] && boManpath+=${boSystemManpath:-}
    [[ -n "${boManpath:-}" ]] && declare -gx boManpath=${boManpath}

    [[ -n "${boManpath:-}" ]] && MANPATH=${boManpath:-}
    # [[ -n "${MANPATH:-}" ]] && declare -gx MANPATH=${MANPATH}
    [[ -n "${MANPATH:-}" ]] && declare -gx MANPATH

    return 0
}
declare -frx assembleManpath

# shellcheck disable=SC2120
assemblePath() {
    # Assemble executable PATH environment variable
    requireArguments "${FUNCNAME[0]}" $# 0

    [[ -n "${boPathInherited:-}" ]] || boPathInherited=${PATH:-}
    [[ -n "${boPathInherited:-}" ]] && {
        # declare -gx boPathInherited=${boPathInherited}
        declare -gx boPathInherited
        logDebug "boPathInherited='${boPathInherited}'"
    }

    boPath=
    [[ -n "${boProjectPath:-}" ]] && boPath+=${boProjectPath:-}:
    [[ -n "${boAccountPath:-}" ]] && boPath+=${boAccountPath:-}:
    [[ -n "${boSystemPath:-}" ]] && boPath+=${boSystemPath:-}
    [[ -n "${boPath:-}" ]] && {
        # declare -gx boPath=${boPath}
        declare -gx boPath
        logDebug "boPath='${boPath}'"
    }

    [[ -n "${boPath:-}" ]] && PATH=${boPath:-}
    [[ -n "${PATH:-}" ]] && {
        # declare -gx PATH=${PATH}
        declare -gx PATH
        logDebug "PATH='${PATH}'"
    }

    return 0
}
declare -frx assemblePath

# shellcheck disable=SC2120
assembleXdg() {
    # Assemble XDG environment variables
    requireArguments "${FUNCNAME[0]}" $# 0

    # Apply XDG standard defaults to make them explicit
    # REF: https://specifications.freedesktop.org/basedir/latest/
    # SEE: https://linuxdork.com/blog/xdg-base-directories-explained/
    # NOTE: all these environment variables should contain ONLY absolute paths,
    # relative paths are considered invalid and should be ignored

    # TODO: Leverage XDG standard to relocate history files, etc.
    # TODO: Test for absolute paths
    # TODO: Refactor a helper function to make these into one-liners

    # These are intended to be system-wide

    boXdgDirsConfig=${boXdgDirsConfig:-/etc/xdg}
    declare -gx boXdgDirsConfig
    XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-${boXdgDirsConfig}}
    declare -gx XDG_CONFIG_DIRS

    boXdgDirsData=${boXdgDirsData:-/usr/local/share:/usr/share}
    declare -gx boXdgDirsData
    XDG_DATA_DIRS=${XDG_DATA_DIRS:-${boXdgDirsData}}
    declare -gx XDG_DATA_DIRS

    # These are intended to be user-specific

    boXdgHomeBin=${boXdgHomeBin:-${HOME}/.local/bin}
    declare -gx boXdgHomeBin
    # Not named in the official standard, but named by convention elsewhere
    XDG_BIN_HOME=${XDG_BIN_HOME:-${boXdgHomeBin}}
    declare -gx XDG_BIN_HOME

    boXdgHomeCache=${boXdgHomeCache:-${HOME}/.cache}
    declare -gx boXdgHomeCache
    XDG_CACHE_HOME=${XDG_CACHE_HOME:-${boXdgHomeCache}}
    declare -gx XDG_CACHE_HOME

    boXdgHomeConfig=${boXdgHomeConfig:-${HOME}/.config}
    declare -gx boXdgHomeConfig
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${boXdgHomeConfig}}
    declare -gx XDG_CONFIG_HOME

    boXdgHomeData=${boXdgHomeData:-${HOME}/.local/share}
    declare -gx boXdgHomeData
    XDG_DATA_HOME=${XDG_DATA_HOME:-${boXdgHomeData}}
    declare -gx XDG_DATA_HOME

    boXdgHomeState=${boXdgHomeState:-${HOME}/.local/state}
    declare -gx boXdgHomeState
    XDG_STATE_HOME=${XDG_STATE_HOME:-${boXdgHomeState}}
    declare -gx XDG_STATE_HOME

    # NOTE: XDG_RUNTIME_DIR (too complicated?)

    # Apparently Apple macOS has its own "rendition" of this standard,
    # which it seems is not really used and should be avoided
    # REF: https://gist.github.com/roalcantara/107ba66dfa3b9d023ac9329e639bc58c
    #
    # It references these other variables:
    # XDG_DESKTOP_DIR
    # XDG_DOCUMENTS_DIR
    # XDG_DOWNLOAD_DIR
    # XDG_MUSIC_DIR
    # XDG_PICTURES_DIR
    # XDG_PUBLICSHARE_DIR
    # XDG_TEMPLATES_DIR
    # XDG_VIDEOS_DIR

    return 0
}
declare -frx assembleXdg

baseOf() {
    # Return base of pathname $1
    # $1 = pathname of a file system entry
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Result=$1

    _Result=$(basename -- "${_Result}")

    echo "${_Result}"
}
declare -frx baseOf

called() {
    # Acknowledge that function $1 was called with remaining arguments
    # $1 = function name from FUNCNAME[0]
    requireArguments "${FUNCNAME[0]}" $# 1 -1

    if [[ -v boIsDebugging ]]; then
        local -r _Function=$1
        shift 1
        local -r _Count=$#
        logTrace "Called '${_Function}' with (${_Count}): '$*'"
    fi
}
declare -frx called

checkSetLongOption() {
    reportSetLongOption "$1" |
        grep --fixed-strings --word-regexp "$2" \
            >/dev/null
}
declare -frx checkSetLongOption

checkSetShortOption() {
    reportSetShortOption "$1" |
        grep --fixed-strings --word-regexp "$2" \
            >/dev/null
}
declare -frx checkSetShortOption

checkShoptOption() {
    reportShoptOption "$1" |
        grep --fixed-strings --word-regexp "$2" \
            >/dev/null
}
declare -frx checkShoptOption

configureShellForInteracting() {
    # Configure Bash shell options for interacting
    requireArguments "${FUNCNAME[0]}" $# 0

    maybeDisableSetLongOption allexport
    maybeDisableSetLongOption emacs
    maybeDisableSetLongOption errexit
    maybeDisableSetLongOption errtrace
    maybeDisableSetLongOption functrace
    maybeDisableSetLongOption histexpand
    maybeDisableSetLongOption ignoreeof
    maybeDisableSetLongOption keyword
    maybeDisableSetLongOption monitor
    maybeDisableSetLongOption noclobber
    maybeDisableSetLongOption noexec
    maybeDisableSetLongOption noglob
    maybeDisableSetLongOption nolog
    maybeDisableSetLongOption nounset
    maybeDisableSetLongOption onecmd
    maybeDisableSetLongOption physical
    maybeDisableSetLongOption posix
    maybeDisableSetLongOption privileged
    maybeDisableSetLongOption verbose
    maybeDisableSetLongOption xtrace
    maybeDisableShoptOption array_expand_once
    maybeDisableShoptOption autocd
    maybeDisableShoptOption cdable_vars
    maybeDisableShoptOption cdspell
    maybeDisableShoptOption cmdhist
    maybeDisableShoptOption direxpand
    maybeDisableShoptOption dirspell
    maybeDisableShoptOption execfail
    maybeDisableShoptOption extdebug
    maybeDisableShoptOption extglob
    maybeDisableShoptOption globasciiranges
    maybeDisableShoptOption histreedit
    maybeDisableShoptOption hostcomplete
    maybeDisableShoptOption lithist
    maybeDisableShoptOption localvar_inherit
    maybeDisableShoptOption localvar_unset
    maybeDisableShoptOption mailwarn
    maybeDisableShoptOption noexpand_translation
    maybeDisableShoptOption sourcepath
    maybeEnableSetLongOption braceexpand
    maybeEnableSetLongOption hashall
    maybeEnableSetLongOption history
    maybeEnableSetLongOption interactive-comments
    maybeEnableSetLongOption notify
    maybeEnableSetLongOption pipefail
    maybeEnableSetLongOption vi
    maybeEnableShoptOption bash_source_fullpath
    maybeEnableShoptOption checkhash
    maybeEnableShoptOption checkjobs
    maybeEnableShoptOption checkwinsize
    maybeEnableShoptOption complete_fullquote
    maybeEnableShoptOption dotglob
    maybeEnableShoptOption expand_aliases
    maybeEnableShoptOption extquote
    maybeEnableShoptOption failglob
    maybeEnableShoptOption force_fignore
    maybeEnableShoptOption globskipdots
    maybeEnableShoptOption globstar
    maybeEnableShoptOption gnu_errfmt
    maybeEnableShoptOption histappend
    maybeEnableShoptOption huponexit
    maybeEnableShoptOption inherit_errexit
    maybeEnableShoptOption interactive_comments
    maybeEnableShoptOption lastpipe
    maybeEnableShoptOption no_empty_cmd_completion
    maybeEnableShoptOption nocaseglob
    maybeEnableShoptOption nocasematch
    maybeEnableShoptOption nullglob
    maybeEnableShoptOption patsub_replacement
    maybeEnableShoptOption progcomp
    maybeEnableShoptOption progcomp_alias
    maybeEnableShoptOption promptvars
    maybeEnableShoptOption shift_verbose
    maybeEnableShoptOption varredir_close
    maybeEnableShoptOption xpg_echo

    return 0
}
declare -frx configureShellForInteracting

# shellcheck disable=SC2120
configureShellForScripting() {
    # Configure Bash shell options for scripting
    requireArguments "${FUNCNAME[0]}" $# 0

    # NOTE: These are crucial to BriteOnyx design
    maybeEnableSetLongOption errexit
    maybeEnableSetLongOption nounset
    maybeEnableSetLongOption pipefail

    # These are helpful/useful, but not as crucial (I think)
    maybeDisableSetLongOption allexport
    maybeDisableSetLongOption emacs
    maybeDisableSetLongOption histexpand
    maybeDisableSetLongOption ignoreeof
    maybeDisableSetLongOption keyword
    maybeDisableSetLongOption monitor
    maybeDisableSetLongOption noclobber
    maybeDisableSetLongOption noexec
    maybeDisableSetLongOption noglob
    maybeDisableSetLongOption nolog
    maybeDisableSetLongOption onecmd
    maybeDisableSetLongOption physical
    maybeDisableSetLongOption posix
    maybeDisableSetShortOption C
    maybeDisableSetShortOption E
    maybeDisableSetShortOption H
    maybeDisableSetShortOption P
    maybeDisableSetShortOption T
    maybeDisableSetShortOption a
    maybeDisableSetShortOption f
    maybeDisableSetShortOption k
    maybeDisableSetShortOption m
    maybeDisableSetShortOption n
    maybeDisableSetShortOption t
    maybeDisableShoptOption array_expand_once
    maybeDisableShoptOption autocd
    maybeDisableShoptOption cdable_vars
    maybeDisableShoptOption cdspell
    maybeDisableShoptOption cmdhist
    maybeDisableShoptOption direxpand
    maybeDisableShoptOption dirspell
    maybeDisableShoptOption execfail
    maybeDisableShoptOption extdebug
    maybeDisableShoptOption extglob
    maybeDisableShoptOption globasciiranges
    maybeDisableShoptOption histreedit
    maybeDisableShoptOption hostcomplete
    maybeDisableShoptOption lithist
    maybeDisableShoptOption localvar_inherit
    maybeDisableShoptOption localvar_unset
    maybeDisableShoptOption mailwarn
    maybeDisableShoptOption noexpand_translation
    maybeDisableShoptOption sourcepath
    maybeEnableSetLongOption braceexpand
    maybeEnableSetLongOption hashall
    maybeEnableSetLongOption history
    maybeEnableSetLongOption interactive-comments
    maybeEnableSetLongOption notify
    maybeEnableSetLongOption vi
    maybeEnableSetShortOption B
    maybeEnableSetShortOption b
    maybeEnableSetShortOption e
    maybeEnableSetShortOption h
    maybeEnableSetShortOption u
    maybeEnableShoptOption bash_source_fullpath
    maybeEnableShoptOption checkhash
    maybeEnableShoptOption checkjobs
    maybeEnableShoptOption checkwinsize
    maybeEnableShoptOption complete_fullquote
    maybeEnableShoptOption dotglob
    maybeEnableShoptOption expand_aliases
    maybeEnableShoptOption extquote
    maybeEnableShoptOption failglob
    maybeEnableShoptOption force_fignore
    maybeEnableShoptOption globskipdots
    maybeEnableShoptOption globstar
    maybeEnableShoptOption gnu_errfmt
    maybeEnableShoptOption histappend
    maybeEnableShoptOption huponexit
    maybeEnableShoptOption inherit_errexit
    maybeEnableShoptOption interactive_comments
    maybeEnableShoptOption lastpipe
    maybeEnableShoptOption no_empty_cmd_completion
    maybeEnableShoptOption nocaseglob
    maybeEnableShoptOption nocasematch
    maybeEnableShoptOption nullglob
    maybeEnableShoptOption patsub_replacement
    maybeEnableShoptOption progcomp
    maybeEnableShoptOption progcomp_alias
    maybeEnableShoptOption promptvars
    maybeEnableShoptOption shift_verbose
    maybeEnableShoptOption varredir_close
    maybeEnableShoptOption xpg_echo

    return 0
}
declare -frx configureShellForScripting

dirOf() {
    # Return directory of pathname $1, self if it is a directory
    # $1 = pathname of a file system entry
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Result=$1

    if [[ ! -d "${_Result}" ]]; then
        _Result=$(dirname -- "${_Result}")
    fi
    _Result=$(absolute "${_Result}")

    echo "${_Result}"
}
declare -frx dirOf

execute() {
    # Execute command-with-arguments $@, wrapping it for error handling
    requireArguments "${FUNCNAME[0]}" $# 1 -1

    logDebug "Executing: $*"
    # shellcheck disable=SC2068
    if $@; then
        true
    else
        abortOnFail $? "from: $*"
    fi

    return 0
}
declare -frx execute

executed() {
    # Acknowledge that script was executed, verified from arguments
    # $1 = caller's $0
    # $2 = caller's ${BASH_SOURCE[0]}
    requireArguments "${FUNCNAME[0]}" $# 2

    _requireToBeExecuted "$1" "$2"
    logTrace "Executed '$2'"
    configureShellForScripting

    return 0
}
declare -frx executed

fail() {
    # Fail, with error/exit code $1 and message $2
    requireArguments "${FUNCNAME[0]}" $# 2
    abortOnFail "$1" "$2"
}
declare -frx fail

installBriteOnyx() {
    # Install BriteOnyx framework tagged $1
    # $1 = tag (version) to install
    requireArguments "${FUNCNAME[0]}" $# 1
    local -r _Tag=$1

    sourceRequiredScript "${XDG_CONFIG_HOME}"/briteonyx/install-source.bash \
        BriteOnyx "${_Tag}" \
        https://github.com/rdw20170120/BriteOnyx.git
    # shellcheck disable=SC2154
    declare -gx boFramework=${boInstalledInto}/framework
    logDebug "boFramework=${boFramework}"

    requireBriteOnyx
}
declare -frx installBriteOnyx

logActivity() { logInfo "$1"; }
declare -frx logActivity

logDebug() { _log "DEBUG: $1"; }
declare -frx logDebug

logDone() { logInfo "$1"; }
declare -frx logDebug

logError() { _log "ERROR: $1"; }
declare -frx logError

logFatal() { _log "FATAL: $1"; }
declare -frx logFatal

logInfo() { _log "INFO:  $1"; }
declare -frx logInfo

logTrace() { _log "TRACE: $1"; }
declare -frx logTrace

logWarn() { _log "WARN:  $1"; }
declare -frx logWarn

maybeDisableSetLongOption() {
    checkSetLongOption "$1" 'off' ||
        applySetLongOption "$1" '+o'
}
declare -frx maybeDisableSetLongOption

maybeDisableSetShortOption() {
    checkSetShortOption "$1" 'off' ||
        applySetShortOption "$1" '+'
}
declare -frx maybeDisableSetShortOption

maybeDisableShoptOption() {
    checkShoptOption "$1" 'off' ||
        applyShoptOption "$1" '-u'
}
declare -frx maybeDisableShoptOption

maybeEnableSetLongOption() {
    checkSetLongOption "$1" 'on' ||
        applySetLongOption "$1" '-o'
}
declare -frx maybeEnableSetLongOption

maybeEnableSetShortOption() {
    checkSetShortOption "$1" 'on' ||
        applySetShortOption "$1" '-'
}
declare -frx maybeEnableSetShortOption

maybeEnableShoptOption() {
    checkShoptOption "$1" 'on' ||
        applyShoptOption "$1" '-s'
}
declare -frx maybeEnableShoptOption

parentOf() {
    # Return parent directory of pathname $1
    # $1 = pathname of a file system entry
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Result=$1

    _Result=$(dirname -- "${_Result}")
    _Result=$(absolute "${_Result}")

    # TODO: Reimplement using a name reference
    echo "${_Result}"
}
declare -frx parentOf

reportSetLongOption() {
    set -o |
        grep --fixed-strings "$1"
}
declare -frx reportSetLongOption

reportSetShortOption() {
    case $- in
    *"$1"*)
        printf '%s %s' "$1" 'on'
        ;;
    *)
        printf '%s %s' "$1" 'off'
        ;;
    esac
}
declare -frx reportSetShortOption

reportShoptOption() {
    shopt |
        grep --fixed-strings "$1"
}
declare -frx reportShoptOption

requireArguments() {
    # Require that function $1 received expected number of arguments
    # $1 = function name (from FUNCNAME[0])
    # $2 = actual number of arguments received by caller (from $#)
    # $3 = expected minimum number of arguments
    # $4 = expected maximum number of arguments (optional, <0 for unlimited)
    if (($# < 3)) || ((4 < $#)); then
        fail 1 "'${FUNCNAME[0]}' requires 3-4 arguments instead of $#"
    fi
    local -r _Function=$1
    local -ir _Actual=$2
    local -ir _Minimum=$3
    if (($# == 4)); then
        local -ir _Maximum=$4
    else
        local -ir _Maximum=$3
    fi

    [[ -v boIsDebugging ]] && {
        logTrace "'${_Function}' received ${_Actual} of ${_Minimum} to ${_Maximum} argument(s)"
    }
    if ((${_Maximum} < 0)); then
        # A maximum of less than 0 arguments means unlimited
        if ((${_Actual} < ${_Minimum})); then
            fail 1 "'${_Function}' requires at least ${_Minimum} argument(s) instead of ${_Actual}"
        fi
    else
        if ((${_Actual} < ${_Minimum})) || ((${_Maximum} < ${_Actual})); then
            fail 1 "'${_Function}' requires ${_Minimum}-${_Maximum} argument(s) instead of ${_Actual}"
        fi
    fi
    return 0
}
declare -frx requireArguments

# shellcheck disable=SC2120
requireBriteOnyx() {
    # Require BriteOnyx framework
    requireArguments "${FUNCNAME[0]}" $# 0

    if [[ -v boNO ]]; then
        fail 1 "Found 'boNO' defined, BriteOnyx is explicitly disabled"
    fi
    if [[ -v boFramework ]]; then
        if [[ ! -d "${boFramework}" ]]; then
            fail 1 "'boFramework' does NOT reference a directory, need BriteOnyx"
        fi
    else
        fail 1 "Missing 'boFramework', need BriteOnyx"
    fi

    return 0
}
declare -frx requireBriteOnyx

requireDirectory() {
    # Require directory $1
    # $1 = pathname that is required to be a directory
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Pathname=$1

    _Pathname=$(absolute "${_Pathname}")
    requireExists "${_Pathname}"
    [[ -d "${_Pathname}" ]] || abortOnFail 1 "Missing directory '${_Pathname}'"
}
declare -frx requireDirectory

requireExists() {
    # Require pathname $1
    # $1 = pathname that is required to exist
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Pathname=$1

    _Pathname=$(absolute "${_Pathname}")
    [[ -e "${_Pathname}" ]] || abortOnFail 1 "Missing pathname '${_Pathname}'"
}
declare -frx requireExists

requireFile() {
    # Require file $1
    # $1 = pathname that is required to be a file
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Pathname=$1

    _Pathname=$(absolute "${_Pathname}")
    requireExists "${_Pathname}"
    [[ -f "${_Pathname}" ]] || abortOnFail 1 "Missing file '${_Pathname}'"
}
declare -frx requireFile

requireScript() {
    # Require script $1, expecting it to be invoked via Bash 'source' command
    # $1 = pathname that is required to be a readable script file
    requireArguments "${FUNCNAME[0]}" $# 1
    local _Pathname=$1

    _Pathname=$(absolute "${_Pathname}")
    requireFile "${_Pathname}"
    [[ -r "${_Pathname}" ]] || abortOnFail 1 "Unreadable file '${_Pathname}'"
}
declare -frx requireScript

sourced() {
    # Acknowledge that script was sourced, verified from arguments
    # $1 = caller's $0
    # $2 = caller's ${BASH_SOURCE[0]}
    requireArguments "${FUNCNAME[0]}" $# 2
    local -r _Executable=$1
    local _Script=$2

    _Script=$(absolute "${_Script}")
    _requireToBeSourced "${_Executable}" "${_Script}"
    logTrace "Sourced '${_Script}'"
    configureShellForScripting

    return 0
}
declare -frx sourced

sourceRequiredScript() {
    # Bash 'source' required script $1
    # $1 = script pathname
    requireArguments "${FUNCNAME[0]}" $# 1 -1
    local _Script=$1
    shift 1

    _Script=$(absolute "${_Script}")
    requireScript "${_Script}"
    logTrace "Sourcing script '${_Script}'"
    source "${_Script}" "$@"
}
declare -frx sourceRequiredScript

###################################################################################################
# Invoke some essential functions, before returning to caller, so they do not have to do so
sourced "$0" "${BASH_SOURCE[0]}"
assembleAll
