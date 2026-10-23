#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Uncomment for debugging/development
boLogLevel=7
export boLogLevel

# NOTE: override BriteOnyx framework for local development
# since this is the BriteOnyx project repository
boFramework=$(dirname "${BASH_SOURCE[0]}")
export boFramework

# This script uses the BriteOnyx framework
# shellcheck disable=SC2154
source "${boFramework}"/bash/startup/from_script.bash

# Dependencies:
# shellcheck disable=SC2154
source "${boDirLib}"/changeDirectoryIn.bash
source "${boDirLib}"/forbidVariable.bash
source "${boDirLib}"/getAbsolutePath.bash
source "${boDirLib}"/logging.bash
source "${boDirLib}"/maybeCreateDirectoryTree.bash
source "${boDirLib}"/requireDirectory.bash
source "${boDirLib}"/requireDirectoryIn.bash

logExecuting "${BASH_SOURCE[0]}"

logActivity "Activating this project for this Bash session"

forbidVariable prjDirRoot
prjDirRoot=$(dirname "${BASH_SOURCE[0]}")
prjDirRoot=$(getAbsolutePath "${prjDirRoot}")
export prjDirRoot
logVariable prjDirRoot
requireDirectoryIn prjDirRoot

forbidVariable prjDirTmp
prjDirTmp=${prjDirRoot}/.tmp
export prjDirTmp
logVariable prjDirTmp
maybeCreateDirectoryTree "${prjDirTmp}"

# Use relative path for project scripts
# so it works in project directory and all subdirectories
forbidVariable prjPathBin
export prjPathBin=./bin
logVariable prjPathBin
requireDirectory "${prjDirRoot}"/${prjPathBin}

forbidVariable prjDirLib
export prjDirLib=${prjDirRoot}/lib
logVariable prjDirLib
requireDirectoryIn prjDirLib

source "${prjDirLib}"/project_override.bash

logDone "Project successfully activated in ${prjDirRoot}"

changeDirectoryIn prjDirRoot

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
alias edit-project-lib='${EDITOR} ${prjDirLib}/*'

###############################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
