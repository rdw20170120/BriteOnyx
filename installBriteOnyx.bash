#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

>/dev/null umask -S u=rwx,g=,o=

boPrefixRan=.ran_
declare -rx boPrefixRan

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

remember "${BASH_SOURCE[0]}"

# TODO: remove this function after use, so that it does not pollute the shell session?

_boInstall() {
    echo "INFO: Installing BriteOnyx framework to ${boFramework}"

    # Create a temporary directory for our work
    _DirTmp=$(mktemp -d "${boHome}"/.install-XXXXXX)
    declare -r _DirTmp
    mkdir -p "${_DirTmp}"

    # Fetch repository into temporary directory
    git \
        init \
        --quiet \
        "${_DirTmp}"/repo
    git \
        -C "${_DirTmp}"/repo \
        fetch \
        --depth 1 \
        --quiet \
        "${boUrl}" \
        refs/tags/"${boVersion}"

    # Extract repository into a simple copy
    mkdir "${_DirTmp}"/simple
    git \
        -C "${_DirTmp}"/repo \
        archive \
        --format=tar \
        FETCH_HEAD |
        tar \
            -x \
            --file - \
            --directory "${_DirTmp}"/simple

    # Move simple copy into its final place
    mv "${_DirTmp}"/simple "${boFramework}"

    # Remove write permissions, thereby making the copy readonly
    # NOTE: but leave the directories writable so that BriteOnyx can "touch"
    # NO: chmod -R a-w "${boFramework}"
    # TODO: implement using "fd"

    # Remove temporary directory
    rm -fr "${_DirTmp}"

    return 0
}

if [[ ! -v boHome ]]; then
    boHome=${XDG_CACHE_HOME}/BriteOnyx
    declare -rx boHome
fi

if [[ ! -v boUrl ]]; then
    boUrl=https://github.com/rdw20170120/BriteOnyx.git
    declare -rx boUrl
fi

if [[ -v boFramework ]]; then
    # No positional arguments needed, so ignore them
    echo "WARN: NOT installing, using overridden BriteOnyx framework at ${boFramework}"
else
    # Install BriteOnyx framework
    # $1 = version tag of desired framework

    # TODO: also check for too many arguments
    if [[ $# -eq 0 ]]; then
        echo "ERROR: Missing argument for version of BriteOnyx to install and reference"
        return 1
    fi

    boVersion=$1
    declare -rx boVersion

    [[ -d "${boHome}" ]] || mkdir -p "${boHome}"

    boFramework=${boHome}/${boVersion}

    if [[ -d "${boFramework}" ]]; then
        echo "INFO: BriteOnyx framework is already installed in ${boFramework}"
    else
        _boInstall
    fi
fi

if [[ -v boFramework ]]; then
    boFramework=$(absolute "${boFramework}")
    declare -rx boFramework
    # Use BriteOnyx framework to finish Bash startup
    source "$(require "${boFramework}"/bash/startup/from_profile.bash)"
fi

###################################################################################################
: <<'DisabledContent'
DisabledContent
