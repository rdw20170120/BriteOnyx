#!/usr/bin/env bash
# vim: set ft=bash:
# NO: builtin set -ET
builtin set -euo pipefail

# Install tagged source from a source-controlled project repository
# by copying it into a local cache directory.
#
# This script is part of the BriteOnyx framework,
# but is designed for stand-alone use
# including, particularly, to install
# a copy of the BriteOnyx framework.
#
# However, it should be capable
# of installing tagged source
# from any Git repository.

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    >&2 builtin echo "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    exit 1
fi

[[ -v boHomeInstaller ]] ||
    boHomeInstaller=${XDG_CACHE_HOME}/boInstaller
builtin declare -x boHomeInstaller

_install() {
    # Install source
    # with version tag $2
    # from repository at URL $3
    # into local directory $1
    # $1=local installation directory
    # $2=tag for desired version of source
    # $3=project repository URL
    builtin local -r _Dir=$1
    builtin local -r _Tag=$2
    builtin local -r _Url=$3

    # require command git
    # require command mkdir
    # require command mktemp
    # require command rm
    # require command tar

    # Create target directory
    [[ -d "${_Dir}" ]] || command mkdir -p "${_Dir}"

    # Create a temporary directory
    # TODO: test this 'mktemp' call on various OSes
    builtin local _DirTmp
    _DirTmp=$(command mktemp -d "${boHomeInstaller}"/.XXXXXX)
    builtin local -r _DirTmp
    command mkdir -p "${_DirTmp}"

    # Initialize empty working directory
    command git \
        init \
        --quiet \
        "${_DirTmp}"/repo

    # Fetch remote repository into temporary directory
    command git \
        -C "${_DirTmp}"/repo \
        fetch \
        --depth 1 \
        --quiet \
        "${_Url}" \
        refs/tags/"${_Tag}"

    # Extract repository as a simple copy via 'tar'
    command git \
        -C "${_DirTmp}"/repo \
        archive \
        --format=tar \
        FETCH_HEAD |
        command tar \
            -x \
            --file - \
            --directory "${_Dir}"

    # Remove file write permissions, thereby making the copy readonly
    # but leave the directories writable so that BriteOnyx can 'touch'
    find "${_Dir}" -type f -exec chmod a-w {} \;

    # Remove temporary directory
    command rm -fr "${_DirTmp}"

    return 0
}

_main() {
    if [[ -v boNO ]]; then
        >&2 builtin echo "WARN: Found 'boNO' defined, disabling BriteOnyx"
        return 0
    fi

    if [[ $# -ne 3 ]]; then
        >&2 builtin echo 'ERROR: requires name, tag, and URL'
        return 1
    fi

    builtin local -r _Name=$1
    builtin local -r _Tag=$2
    builtin local -r _Url=$3

    builtin local -r _Home=${boHomeInstaller}/${_Name}/${_Tag}

    if [[ -d ${_Home} ]]; then
        >&2 builtin echo "INFO: ${_Name} ${_Tag} already installed in directory '${_Home}'"
    else
        >&2 builtin echo "INFO: Installing ${_Name} ${_Tag} into new directory '${_Home}'"
        _install "${_Home}" "${_Tag}" "${_Url}"
    fi

    echo "${_Home}"
    return 0
}

# shellcheck disable=SC2034
boInstalledInto=$(_main "$@")

# Make this shell "habitable" again
# TODO: save and restore shell options instead
builtin set -o pipefail
builtin set +o errexit
builtin set +o nounset

###################################################################################################
: <<'DisabledContent'
absolute() {
    # Return absolute pathname of file system entry $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'absolute' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Pathname
    _Pathname=$1

    if [[ -d "${_Pathname}" ]]; then
        builtin cd -- "${_Pathname}"
        _Result=$(builtin pwd -P)
    else
        builtin cd -- "$(command dirname -- "${_Pathname}")"
        _Result=$(builtin pwd -P)/$(command basename -- "${_Pathname}")
    fi

    echo "${_Result}"
}
declare -frx absolute

baseOf() {
    # Return base of pathname $1
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'baseOf' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Result
    _Result=$1
    _Result=$(command basename -- "${_Result}")

    echo "${_Result}"
}
declare -frx baseOf

dirOf() {
    # Return directory of pathname $1, self if it is a directory
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'dirOf' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Result
    _Result=$1

    if [[ ! -d "${_Result}" ]]; then
        _Result=$(command dirname -- "${_Result}")
    fi

    _Result=$(absolute "${_Result}")
    echo "${_Result}"
}
declare -frx dirOf

executing() {
    # Acknowledge that function $2 defined in script $1 is executing now
    # Calling this function should be the first executable line
    # in every significant function--with few low-level exceptions.
    # $1 = pathname of defining script (e.g., from "${BASH_SOURCE[0]}")
    # $2 = name of executing function (e.g., from "${FUNCNAME[0]}")

    if [[ $# -ne 2 ]]; then
        echo "FATAL: Function 'executing' requires 2 arguments instead of $#"
        exit 127
    fi

    declare _Function
    _Function=$2
    declare _Pathname
    _Pathname=$1
    _Pathname=$(absolute "${_Pathname}")

    if >/dev/null declare -F logCall; then
        logCall "${_Function}"
    fi

    # TODO: verify that executing function is part of the current BriteOnyx framework

    return 0
}
declare -frx executing

parentOf() {
    # Return parent directory of pathname $1
    # $1 = pathname of a file system entry

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'parentOf' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Result
    _Result=$1
    _Result=$(command dirname -- "${_Result}")
    _Result=$(absolute "${_Result}")

    echo "${_Result}"
}
declare -frx dirOf

remember() {
    # Remember that we ran script $1
    # $1 = full pathname of executing script (e.g., from "${BASH_SOURCE[0]}")

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'remember' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Pathname
    _Pathname=$1
    _Pathname=$(absolute "${_Pathname}")

    # Remember that we executed the script,
    # but not by (problematic) logging during shell startup
    # shellcheck disable=SC2154
    touch "$(dirname -- "${_Pathname}")"/"${boPrefixRan}""$(basename -- "${_Pathname}")"

    return 0
}
declare -frx remember

require() {
    # Require script $1, expecting it to be invoked via Bash "source" command
    # Return absolute pathname of script
    # $1 = pathname of script about to be invoked via "source"

    if [[ $# -ne 1 ]]; then
        echo "FATAL: Function 'require' requires 1 argument instead of $#"
        exit 127
    fi

    declare _Result
    _Result=$1
    _Result=$(absolute "${_Result}")

    if [[ ! -r "$1" ]]; then
        echo "ERROR: Could not find readable script $1"
        exit 1
    fi

    echo "${_Result}"
}
declare -frx require

DisabledContent
