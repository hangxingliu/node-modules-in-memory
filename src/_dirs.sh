#!/usr/bin/env bash

_GLOBAL_DIR="$HOME/.config/node-modules-in-memory";

function _dirs_throw() { echo "fatal: $1" > /dev/stderr; exit 1; }

if [[ ! -e "$_GLOBAL_DIR" ]]; then
	mkdir -p "$_GLOBAL_DIR" || _dirs_throw "could not create global directory: \"$_GLOBAL_DIR\"";
fi
[[ -d "$_GLOBAL_DIR" ]] || _dirs_throw "\"$_GLOBAL_DIR\" is not a directory!";
