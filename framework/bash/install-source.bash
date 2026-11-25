#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -ET
set -euo pipefail

# TODO: consider whether this script could be executed instead

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

###################################################################################################
# MUST be properly 'source'd, NOT executed
if [[ -z "${BASH_SOURCE[0]}" ]]; then
    >&2 echo "FATAL: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    >&2 echo "FATAL: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

###################################################################################################
# Configure
if [[ ! -v boHomeInstaller ]]; then
    if [[ -v XDG_CACHE_HOME ]]; then
        : "${boHomeInstaller:=${XDG_CACHE_HOME}/boInstaller}"
    else
        : "${boHomeInstaller:=${HOME}/.cache/boInstaller}"
    fi
fi
>&2 echo "DEBUG: Using boHomeInstaller = '${boHomeInstaller}'"
# TODO: declare -rx boHomeInstaller

###################################################################################################

_install() {
    # Install source
    # with version tag $2
    # from repository at URL $3
    # into local directory $1
    # $1=local installation directory
    # $2=tag for desired version of source
    # $3=project repository URL
    local -r _Dir=$1
    local -r _Tag=$2
    local -r _Url=$3

    # require command git
    # require command mkdir
    # require command mktemp
    # require command rm
    # require command tar

    # Create target directory
    [[ -d "${_Dir}" ]] || mkdir -p "${_Dir}"

    # Create a temporary directory
    # TODO: test this 'mktemp' call on various OSes
    local _DirTmp
    # shellcheck disable=SC2154
    _DirTmp=$(mktemp -d "${boHomeInstaller}"/.XXXXXX)
    local -r _DirTmp
    mkdir -p "${_DirTmp}"

    # Initialize empty working directory
    git \
        init \
        --quiet \
        "${_DirTmp}"/repo

    # Fetch remote repository into temporary directory
    git \
        -C "${_DirTmp}"/repo \
        fetch \
        --depth 1 \
        --quiet \
        "${_Url}" \
        refs/tags/"${_Tag}"

    # Extract repository as a simple copy via 'tar'
    git \
        -C "${_DirTmp}"/repo \
        archive \
        --format=tar \
        FETCH_HEAD |
        tar \
            -x \
            --file - \
            --directory "${_Dir}"

    # Remove write permissions, thereby making the copy readonly
    find "${_Dir}" -exec chmod a-w {} \;

    # Remove temporary directory
    rm -fr "${_DirTmp}"

    return 0
}

_main() {
    if [[ $# -ne 3 ]]; then
        >&2 echo 'ERROR: Requires name, tag, and URL arguments'
        return 1
    fi
    local -r _Name=$1
    local -r _Tag=$2
    local -r _Url=$3

    local -r _Home=${boHomeInstaller}/${_Name}/${_Tag}

    if [[ -d ${_Home} ]]; then
        >&2 echo "INFO: ${_Name} ${_Tag} already installed in directory '${_Home}'"
    else
        >&2 echo "INFO: Installing ${_Name} ${_Tag} into new directory '${_Home}'"
        _install "${_Home}" "${_Tag}" "${_Url}"
    fi

    echo "${_Home}"
    return 0
}

# shellcheck disable=SC2034
boInstalledInto=$(_main "$@")
