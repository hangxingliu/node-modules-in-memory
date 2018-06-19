#!/usr/bin/env bash

NODE_MODULES="node_modules";
TARGET_FILE="node_modules.tar";

__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
pushd "$__DIRNAME" > /dev/null;
# ===============
# include scripts
source ./_dirs.sh
source ./_utils.sh
source ./_global_list.sh
# ===============
popd > /dev/null;

function throw() { echo -e "${STYLE_ERROR}fatal: $1${RESET}" > /dev/stderr; exit 1; }

global_list_cleanup;


if [[ ! -e "$NODE_MODULES" ]]; then
	echo -e "${STYLE_WARN}warn: \"$NODE_MODULES\" is not existed!${RESET}";
	exit 0;
fi

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";
if has_mount "$NODE_MODULES_FULL_PATH"; then
	MOUNT_SIZE=`get_mount_size "$NODE_MODULES_FULL_PATH" | pipe_for_human_readable_size`;
	USED_SIZE=`get_mount_used_size "$NODE_MODULES_FULL_PATH" | pipe_for_human_readable_size`;
	echo -e "node_modules:     ${GREEN}mounted (used: ${USED_SIZE} / all: ${MOUNT_SIZE})${RESET}";
fi

if [[ -f "$TARGET_FILE" ]]; then
	FILE_SIZE_R=`file_size_human_readable "$TARGET_FILE"`;
	echo -e "node_modules.tar: ${GREEN}${FILE_SIZE_R}${RESET}";
fi
