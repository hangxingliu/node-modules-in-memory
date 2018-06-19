#!/usr/bin/env bash

_NMIMRC_GLOBAL="$HOME/.config/node-modules-in-memory/config";
_NMIMRC_LOCAL=".nmimrc";

# $1: project path
function nmimrc_setup() {
	if [[ -f "$_NMIMRC_GLOBAL" ]]; then
		source "$_NMIMRC_GLOBAL" ||
			_config_throw "config file exception! ($_NMIMRC_GLOBAL)";
	fi

	pushd "$1" > /dev/null;
	if [[ -f "$_NMIMRC_LOCAL" ]]; then
		source "$_NMIMRC_LOCAL" ||
			_config_throw "config file exception! ($_NMIMRC_LOCAL)";
	fi
	popd > /dev/null;
}
