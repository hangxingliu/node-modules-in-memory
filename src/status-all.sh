#!/usr/bin/env bash

NODE_MODULES="node_modules";

__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
pushd "$__DIRNAME" > /dev/null;
# ===============
# include scripts
source ./_utils.sh
source ./_config.sh
# ===============
popd > /dev/null;


function throw() { echo -e "${STYLE_ERROR}fatal: $1${RESET}" > /dev/stderr; exit 1; }

config_cleanup_global_list;

list=`config_get_global_list`;
while read -r mount_path; do
	if [[ -z "$mount_path" ]]; then continue; fi

	if has_mount "$mount_path"; then
		MOUNT_SIZE=`get_mount_size "$mount_path" | pipe_for_human_readable_size`;
		USED_SIZE=`get_mount_used_size "$mount_path" | pipe_for_human_readable_size`;
		echo -e "${mount_path} ${GREEN}has mounted (used: ${USED_SIZE} / all: ${MOUNT_SIZE})${RESET}";
	fi

done <<< "$list"

