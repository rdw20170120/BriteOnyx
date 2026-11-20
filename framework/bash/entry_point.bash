#!/usr/bin/env bash -c 'MUST be invoked via source'
# shellcheck disable=SC1090,SC2096
# vim: set ft=bash:
set -bBehu
set +aCEfHkmnPtT
set -o history
set -o pipefail
set -o vi
set +o emacs
set +o ignoreeof
set +o posix
shopt -s bash_source_fullpath checkhash checkjobs checkwinsize complete_fullquote dotglob expand_aliases extquote failglob force_fignore globskipdots globstar gnu_errfmt histappend huponexit inherit_errexit interactive_comments lastpipe no_empty_cmd_completion nocaseglob nocasematch nullglob patsub_replacement progcomp progcomp_alias promptvars shift_verbose varredir_close xpg_echo
shopt -u array_expand_once autocd cdable_vars cdspell cmdhist direxpand dirspell execfail extdebug extglob globasciiranges histreedit hostcomplete lithist localvar_inherit localvar_unset mailwarn noexpand_translation sourcepath

requireBriteOnyx

###################################################################################################
# Crucial to set 'umask' early, before modifying the filesystem
>/dev/null umask -S u=rwx,g=,o=

# Establish reference to library of Bash functions
# shellcheck disable=SC2154
boFrmLib=${boFramework}/bash/lib
declare -rx boFrmLib

# TODO: importModule core

###################################################################################################
# Export and freeze reference to BriteOnyx framework
declare -rx boFramework

###################################################################################################
# logDone "BriteOnyx framework successfully activated in ${boFramework}"
