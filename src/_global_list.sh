#!/usr/bin/env bash

_CONFIG_DIR="$HOME/.config/node-modules-in-memory";
_GLOBAL_LIST="$_CONFIG_DIR/global.list";

function _global_list_throw() { echo "fatal: $1" > /dev/stderr; exit 1; }

if [[ ! -e "$_CONFIG_DIR" ]]; then
	mkdir -p "$_CONFIG_DIR" || _global_list_throw "could not create config directory: \"$_CONFIG_DIR\"";
fi
[[ -d "$_CONFIG_DIR" ]] || _global_list_throw "\"$_CONFIG_DIR\" is not a directory!";

function global_list_cleanup() {
	if [[ ! -f "$_GLOBAL_LIST" ]]; then return; fi

	local list new_list mount_path;
	list=`cat "$_GLOBAL_LIST"`;
	new_list="";
	while read -r mount_path; do
		if [[ -z "$mount_path" ]]; then continue; fi
		if has_mount "$mount_path"; then
			new_list="${new_list}${mount_path}\n";
		fi
	done <<< "$list"
	echo -e "$new_list" | gawk '!/^$/' | sort | uniq > "$_GLOBAL_LIST";
}

# $1: node_modules path
function global_list_append() {
	local old_list;

	if [[ -f "$_GLOBAL_LIST" ]]; then
		old_list=`cat "$_GLOBAL_LIST"`;
	fi

	echo -e "$old_list\n$1" | gawk '!/^$/' | sort | uniq > "$_GLOBAL_LIST";
}

function global_list_get() {
	if [[ ! -f "$_GLOBAL_LIST" ]]; then return; fi
	cat "$_GLOBAL_LIST";
}
