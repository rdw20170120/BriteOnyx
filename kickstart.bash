#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2034,SC2154
# vim: set ft=bash:

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
    >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
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

absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi

    local _Pathname=$1

    if [[ -d "${_Pathname}" ]]; then
        _Result=${_Pathname}
        if cd -- "${_Result}"; then
            _Result=$(pwd -P)
        else
            >&2 echo "ERROR: Could not 'cd' to '${_Result}'"
            exit 1
        fi
    else
        _Result=${_Pathname}
        _Result=$(dirname -- "${_Result}")
        if cd -- "${_Result}"; then
            _Result=$(pwd -P)
            _Result=${_Result}/$(basename -- "${_Pathname}")
        else
            >&2 echo "ERROR: Could not 'cd' to '${_Result}'"
            exit 1
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
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

    assembleXdg
    assembleManpath
    assemblePath

    return 0
}
declare -frx assembleAll

# shellcheck disable=SC2120
assembleManpath() {
    # Assemble MANPATH environment variable
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

    [[ -n "${boManpathInherited:-}" ]] || boManpathInherited=${MANPATH:-}
    [[ -n "${boManpathInherited:-}" ]] && declare -gx boManpathInherited=${boManpathInherited}

    boManpath=
    [[ -n "${boProjectManpath:-}" ]] && boManpath+=${boProjectManpath:-}:
    [[ -n "${boAccountManpath:-}" ]] && boManpath+=${boAccountManpath:-}:
    [[ -n "${boSystemManpath:-}" ]] && boManpath+=${boSystemManpath:-}
    [[ -n "${boManpath:-}" ]] && declare -gx boManpath=${boManpath}

    [[ -n "${boManpath:-}" ]] && MANPATH=${boManpath:-}
    [[ -n "${MANPATH:-}" ]] && declare -gx MANPATH=${MANPATH}

    return 0
}
declare -frx assembleManpath

# shellcheck disable=SC2120
assemblePath() {
    # Assemble executable PATH environment variable
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

    [[ -n "${boPathInherited:-}" ]] || boPathInherited=${PATH:-}
    [[ -n "${boPathInherited:-}" ]] && {
        declare -gx boPathInherited=${boPathInherited}
        >&2 echo "DEBUG: boPathInherited='${boPathInherited}'"
    }

    boPath=
    [[ -n "${boProjectPath:-}" ]] && boPath+=${boProjectPath:-}:
    [[ -n "${boAccountPath:-}" ]] && boPath+=${boAccountPath:-}:
    [[ -n "${boSystemPath:-}" ]] && boPath+=${boSystemPath:-}
    [[ -n "${boPath:-}" ]] && {
        declare -gx boPath=${boPath}
        >&2 echo "DEBUG: boPath='${boPath}'"
    }

    [[ -n "${boPath:-}" ]] && PATH=${boPath:-}
    [[ -n "${PATH:-}" ]] && {
        declare -gx PATH=${PATH}
        >&2 echo "DEBUG: PATH='${PATH}'"
    }

    return 0
}
declare -frx assemblePath

# shellcheck disable=SC2120
assembleXdg() {
    # Assemble XDG environment variables
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

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
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(basename -- "${_Result}")

    echo "${_Result}"
}
declare -frx baseOf

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
    # No arguments
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

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
    # No arguments
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

    # NOTE: these are crucial to BriteOnyx design
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
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1

    if [[ ! -d "${_Result}" ]]; then
        _Result=$(dirname -- "${_Result}")
    fi

    _Result=$(absolute "${_Result}")
    echo "${_Result}"
}
declare -frx dirOf

installBriteOnyx() {
    # Install BriteOnyx framework tagged $1
    # $1 = tag (version) to install
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi
    local -r _Tag=$1

    sourceRequiredScript "${HOME}"/.config/bash/install-source.bash \
        BriteOnyx "${_Tag}" \
        https://github.com/rdw20170120/BriteOnyx.git
    # shellcheck disable=SC2154
    declare -gx boFramework=${boInstalledInto}/framework
    >&2 echo "INFO: boFramework=${boFramework}"

    return 0
}
declare -frx installBriteOnyx

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
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(dirname -- "${_Result}")
    _Result=$(absolute "${_Result}")

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

requireScript() {
    # Require script $1, expecting it to be invoked via Bash 'source' command
    # Return absolute pathname of script
    # $1 = pathname of script about to be invoked via "source"
    if (($# != 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 1 argument instead of $#"
        exit 1
    fi

    local _Result=$1
    _Result=$(absolute "${_Result}")

    if [[ -r "${_Result}" ]]; then
        >&2 echo "DEBUG: Required script '${_Result}'"
    else
        >&2 echo "ERROR: Missing readable script '${_Result}'"
        exit 1
    fi
    printf '%s' "${_Result}"
}
declare -frx requireScript

requireBriteOnyx() {
    # Require BriteOnyx framework
    # No arguments
    if (($# != 0)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 0 arguments instead of $#"
        exit 1
    fi

    if [[ -v boNO ]]; then
        >&2 echo "ERROR: Found 'boNO' defined, BriteOnyx is explicitly disabled"
        return 1
    fi
    if [[ -v boFramework ]]; then
        if [[ ! -d "${boFramework}" ]]; then
            >&2 echo "ERROR: 'boFramework' does NOT reference a directory, need BriteOnyx"
            return 1
        fi
    else
        >&2 echo "ERROR: Missing 'boFramework', need BriteOnyx"
        return 1
    fi

    return 0
}
declare -frx requireBriteOnyx

requireToBeExecuted() {
    # Require the calling script to be executed, NOT 'source'd
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    if (($# != 2)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Executable=$1
    local _Script=$2

    if [[ -z "${_Script}" ]]; then
        >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
        return 1
    fi
    if [[ "${_Script}" != "${_Executable}" ]]; then
        >&2 echo "ERROR: Aborting, cannot source, MUST execute script '${_Executable}'"
        exit 1
    fi

    return 0
}
declare -frx requireToBeExecuted

requireToBeSourced() {
    # Require the calling script to be 'source'd, NOT executed
    # $1 = name of executable (e.g., from "$0")
    # $2 = pathname of calling script (e.g., from "${BASH_SOURCE[0]}")
    if (($# != 2)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires 2 arguments instead of $#"
        exit 1
    fi

    local _Executable=$1
    local _Script=$2

    if [[ "${_Executable}" != bash ]]; then
        >&2 echo "DEBUG: executable '$0' is NOT 'bash' in '${_Script}'"
    fi
    if [[ -z "${_Script}" ]]; then
        >&2 echo "ERROR: Aborting, 'BASH_SOURCE' is empty in script '${_Executable}'"
        return 1
    fi
    if [[ "${_Script}" == "${_Executable}" ]]; then
        >&2 echo "ERROR: Aborting, cannot execute, MUST source script '${_Executable}'"
        return 1
    fi

    return 0
}
declare -frx requireToBeSourced

sourceRequiredScript() {
    # Bash 'source' required script $1
    # $1 = script pathname
    if (($# < 1)); then
        >&2 echo "ERROR: '${FUNCNAME[0]}' requires at least 1 argument instead of $#"
        exit 1
    fi
    local _Script=$1
    shift 1
    _Script=$(requireScript "${_Script}")
    >&2 echo "TRACE: Sourcing script '${_Script}'"
    source "${_Script}" "$@"
}
declare -frx sourceRequiredScript

# Invoke some essential functions, before returning to caller, so they do not have to do so
configureShellForScripting
assembleAll
