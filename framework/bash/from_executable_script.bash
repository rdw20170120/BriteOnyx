#!/usr/bin/env bash
# shellcheck disable=SC1090
# vim: set ft=bash:

sourced "$0" "${BASH_SOURCE[0]}"
requireBriteOnyx
# shellcheck disable=SC2154
sourceRequiredScript "${boFramework}"/bash/entry_point.bash
logDone "BriteOnyx framework successfully activated in ${boFramework}"
