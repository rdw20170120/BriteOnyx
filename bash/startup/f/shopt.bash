#!/usr/bin/env bash -c NOTE: only execute via 'source'
# shellcheck disable=SC1091,SC2046,SC2086,SC2096,SC2128
# vim: set ft=bash:
set -EeTuo pipefail
touch $(dirname ${BASH_SOURCE})/.ran_$(basename ${BASH_SOURCE})

# My overrides
# TODO: deprecated: `array_expand_once` replaces `assoc_expand_once`
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s execfail
shopt -s extquote
shopt -s failglob
shopt -s globskipdots
shopt -s globstar
shopt -s histappend
shopt -s hostcomplete
shopt -s huponexit
shopt -s inherit_errexit
shopt -s lithist
shopt -s no_empty_cmd_completion
shopt -s nullglob
shopt -s progcomp
shopt -s promptvars
shopt -s shift_verbose
shopt -s varredir_close
shopt -u assoc_expand_once
shopt -u autocd
shopt -u cdable_vars
shopt -u cdspell
shopt -u checkjobs
shopt -u dirspell
shopt -u dotglob
shopt -u extglob
shopt -u histreedit
shopt -u histverify
shopt -u interactive_comments
shopt -u lastpipe
shopt -u lithist
shopt -u localvar_inherit
shopt -u nocaseglob
shopt -u nocasematch
shopt -u patsub_replacement
shopt -u sourcepath
shopt -u xpg_echo

###################################################################################################
: <<'DisabledContent'
# TODO: Why do these throw an error that they are invalid shell option names?
# shopt -u array_expand_once
# shopt -s globalasciiranges

# TODO: What are these exactly?
shopt -s force_fignore
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u compat42
shopt -u compat43
shopt -u compat44
shopt -u direxpand
shopt -s gnu_errfmt
shopt -u localvar_unset
shopt -u noexpand_translation

# TODO: Consider using some of these
shopt -s expand_aliases
shopt -u mailwarn
shopt -u progcomp_alias

# Only when debugging
shopt -u extdebug

DisabledContent
