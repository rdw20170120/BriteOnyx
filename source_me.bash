#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128,SC2154
# vim: set ft=bash:
set -EeTuo pipefail

# NOTE: Temporary logging setting while implementing development workflow
boLogLevel=7
export boLogLevel

source ${HOME}/.config/XDG.env
source ${XDG_CONFIG_HOME}/BO.env

# NOTE: This project uses the BriteOnyx framework
source ${boFramework}/bash/startup/from_script.bash
source ${boDirLib}/forbidVariable.bash
source ${boDirLib}/getAbsolutePath.bash
source ${boDirLib}/logging.bash
source ${boDirLib}/maybeCreateDirectoryTree.bash
source ${boDirLib}/requireDirectoryIn.bash

logExecuting ${BASH_SOURCE}

logActivity "Activating this project for this Bash session"

forbidVariable prjDirRoot
prjDirRoot=$(getAbsolutePath $(dirname ${BASH_SOURCE}))
export prjDirRoot
logVariable prjDirRoot
requireDirectoryIn prjDirRoot

forbidVariable prjDirTmp
prjDirTmp=${prjDirRoot}/tmp
export prjDirTmp
logVariable prjDirTmp
maybeCreateDirectoryTree ${prjDirTmp}

# NOTE: Use relative path for project scripts
# so it works in project directory and all subdirectories
forbidVariable prjPathBin
export prjPathBin=./bin
logVariable prjPathBin
requireDirectoryIn prjPathBin

forbidVariable prjPathLib
export prjPathLib=${prjDirRoot}/lib
logVariable prjPathLib
requireDirectoryIn prjPathLib

source ${prjPathLib}/project_override.bash

logDone "Project successfully activated in ${prjDirRoot}"

# Disable `errexit` in user's session
# TODO: in an `EXIT` `trap`
set +o errexit
# Disable `trap` in user's session
trap --

# Edit project source files
# TODO: enhance these to be more accurate and complete
alias edit-project-bash='${EDITOR} $(fd .bash ${prjDirRoot})'
alias edit-project-doc='${EDITOR} $(fd .md ${prjDirRoot})'
alias edit-project-exe='${EDITOR} ${prjPathBin}/*'
alias edit-project-lib='${EDITOR} ${prjPathLib}/*'

###############################################################################
: <<'DisabledContent'
DisabledContent
