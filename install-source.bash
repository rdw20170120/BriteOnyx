#!/usr/bin/env bash
# vim: set ft=bash:
# NO: set -EeTu
set -o pipefail
# TODO: remove after development/testing
set -eu

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
    log "ERROR: Aborting, 'BASH_SOURCE' is empty in script '$0'"
    return 1
fi
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    log "ERROR: Aborting, script '$0' MUST be sourced instead of executed"
    return 1
fi

###################################################################################################
[[ -v boHomeInstaller ]] ||
    boHomeInstaller=${XDG_CACHE_HOME}/boInstaller
declare -x boHomeInstaller

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

    # Remove file write permissions, thereby making the copy readonly
    # but leave the directories writable so that BriteOnyx can 'touch'
    find "${_Dir}" -type f -exec chmod a-w {} \;

    # Remove temporary directory
    rm -fr "${_DirTmp}"

    return 0
}

_main() {
    if [[ -v boNO ]]; then
        log "WARN: Found 'boNO' defined, disabling BriteOnyx"
        return 0
    fi

    if [[ $# -ne 3 ]]; then
        log 'ERROR: requires name, tag, and URL'
        return 1
    fi

    local -r _Name=$1
    local -r _Tag=$2
    local -r _Url=$3

    local -r _Home=${boHomeInstaller}/${_Name}/${_Tag}

    if [[ -d ${_Home} ]]; then
        log "INFO: ${_Name} ${_Tag} already installed in directory '${_Home}'"
    else
        log "INFO: Installing ${_Name} ${_Tag} into new directory '${_Home}'"
        _install "${_Home}" "${_Tag}" "${_Url}"
    fi

    echo "${_Home}"
    return 0
}

# shellcheck disable=SC2034
boInstalledInto=$(_main "$@")

# Make this shell "habitable" again
# TODO: save and restore shell options instead
set -o pipefail
set +o errexit
set +o nounset

###################################################################################################
: <<'DisabledContent'
DisabledContent
