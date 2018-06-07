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


function throw() { echo -e "fatal: $1" > /dev/stderr; exit 1; }

config_cleanup_global_list;

list=`config_get_global_list`;
while read -r mount_path; do
	if [[ -z "$mount_path" ]]; then continue; fi

	echo "[.] ${mount_path}";

	sudo umount "$mount_path";
	[[ $? != 0 ]] && throw "sudo umount failed!";

	config_cleanup_global_list;
	echo "success: umounted!";

done <<< "$list"
