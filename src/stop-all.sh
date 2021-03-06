#!/usr/bin/env bash

NODE_MODULES="node_modules";

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

list=`global_list_get`;
count="0";
while read -r mount_path; do
	if [[ -z "$mount_path" ]]; then continue; fi

	echo "[.] ${mount_path}";

	sudo umount "$mount_path";
	[[ $? != 0 ]] && throw "sudo umount failed!";

	global_list_cleanup;
	echo "success: umounted!";

	count=$((count+1));

done <<< "$list"

echo -e "[total] unmount ${BOLD}${count}${RESET} node_modules from memroy";
