#!/usr/bin/env bash

# Options
#  --save -s  save before stop

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

# $1: path
# $2: --save
function unmount_node_modules() {
	pushd "$1" >/dev/null || throw "\"$1\" is not a directory!";
	[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

	NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";

	if [[ "$2" == "--save" ]]; then
		bash "$__DIRNAME/save.sh" || exit 1;
	fi

	if ! has_mount "$NODE_MODULES_FULL_PATH"; then
		echo -e "${STYLE_WARN}warn: \"$NODE_MODULES\" has not mounted!${RESET}";
		exit 0;
	fi

	sudo umount "$NODE_MODULES_FULL_PATH";
	[[ $? != 0 ]] && throw "sudo umount failed!";

	global_list_cleanup;
	popd >/dev/null;
	echo "success: umount \"$NODE_MODULES_FULL_PATH\" from memory!";
}

NEED_SAVE=""
SPECIAL_PATH="false"
for argument in "$@"; do
	case "$argument" in
		-s|--save) NEED_SAVE="--save" ;;
		-a|--all|all)
			bash "$__DIRNAME/stop-all.sh";
			exit $?;
		;;

		-*)  throw "unknown option: \"$argument\" " ;;
		*) SPECIAL_PATH="true" ;;
	esac
done

if [[ "$SPECIAL_PATH" == "false" ]]; then
	unmount_node_modules "." "$NEED_SAVE";
	exit $?;
fi

for argument in "$@"; do
	case "$argument" in
		-*|all) ;;
		*) unmount_node_modules "$argument" "$NEED_SAVE";;
	esac
done
