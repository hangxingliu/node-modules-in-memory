#!/usr/bin/env bash

_GLOBAL_LIST="$HOME/.config/node-modules-in-memory/global.list";

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
