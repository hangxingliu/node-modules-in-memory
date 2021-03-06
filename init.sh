#!/usr/bin/env bash

# Usage:
#
#  append following command in the one of "~/.bashrc", "~/.zshrc" or "~/.bash_profile" ...:
#
#    source /path/to/node-modules-in-memory/init.sh
#

_nmim_completion() {
	local ACTIONS OPTS_COMMON OPTS_START;
	ACTIONS="go start stop save stop-all all-stop status status-all all all-status npm";
	OPTS_START="--size";
	OPTS_STOP="-s --save -a --all";

	local PREV_WORD CURRENT_WORD;
	CURRENT_WORD="${COMP_WORDS[COMP_CWORD]}";
    PREV_WORD="${COMP_WORDS[COMP_CWORD-1]}";

	# actions completion
	if [[ "$COMP_CWORD" == "1" ]]; then
        COMPREPLY=( $( compgen -W "$ACTIONS" -- $CURRENT_WORD ) );
		return;
	fi

	local CURRENT_ACTION;
	CURRENT_ACTION="${COMP_WORDS[1]}";
	case "$CURRENT_ACTION" in
		start|go)
			if [[ "$CURRENT_WORD" == -* ]]; then
				COMPREPLY=( $( compgen -W "$OPTS_START" -- $CURRENT_WORD ) );
				return;
			fi
		;;
		stop)
			if [[ "$CURRENT_WORD" == -* ]]; then
				COMPREPLY=( $( compgen -W "$OPTS_STOP" -- $CURRENT_WORD ) );
				return;
			fi
			COMPREPLY=( $( compgen -A directory -W "all" -- $CURRENT_WORD ) );
		;;

		# file completion in default
		*) COMPREPLY=( $( compgen -A file -- $CURRENT_WORD ) );;
	esac
}

function __init_nmim() {
	local __DIRNAME BIN_DIR BIN_FILE WHICH_BIN;
	__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
	BIN_DIR="$__DIRNAME/bin";
	BIN_FILE="nmim";

	WHICH_BIN=`which $BIN_FILE`;
	if [[ -z "$_TEST" ]]; then
		export PATH="$PATH:$BIN_DIR";
	elif [[ "$WHICH_BIN" != "$BIN_DIR/$BIN_FILE" ]]; then
		echo -e "error: init node-modules-in-memory failed!" > /dev/stderr;
		echo -e "         there has a existed nmim in this system: $WHICH_BIN" > /dev/stderr;
		return 1;
	fi

	# register completion function
	complete -F _nmim_completion "$BIN_FILE";
}

__init_nmim;
