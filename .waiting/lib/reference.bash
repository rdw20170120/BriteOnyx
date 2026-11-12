#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC1091,SC2096
# vim: set ft=bash:
set -EeTuo pipefail

# Dependencies:
# shellcheck disable=SC2154
source "$(require "${boDirLib}"/execute.bash)"
source "$(require "${boDirLib}"/logging.bash)"
source "$(require "${boDirLib}"/requireDirectoryIn.bash)"

logExecuting "${BASH_SOURCE[0]}"

requireDirectoryIn prjDirRoot

prjFilesExecutable() {
    # shellcheck disable=SC2154
    execute fd -atf "${prjDirRoot}"/bin
}
declare -frx prjFilesExecutable

prjFilesFramework() {
    # shellcheck disable=SC2154
    execute fd -atf "${prjDirRoot}"/bash
}
declare -frx prjFilesFramework

prjFilesGenerating() {
    # shellcheck disable=SC2154
    execute fd -atf "${prjDirRoot}"/gen
}
declare -frx prjFilesGenerating

prjFilesLib() {
    # shellcheck disable=SC2154
    execute fd -atf "${prjDirRoot}"/lib
}
declare -frx prjFilesLib

###############################################################################
: <<'DisabledContent'
Troubleshooting Bash:
  set -o verbose; set -o xtrace
  # Code to troubleshoot
  set +o verbose; set +o xtrace
DisabledContent
