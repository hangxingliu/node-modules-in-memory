#!/usr/bin/env bash

# Options
#  --save -s  save before stop

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

NEED_SAVE="false"

for argument in "$@"; do
	case "$argument" in
		-s|--save) NEED_SAVE="true" ;;

		*)  throw "unknown option: \"$argument\" " ;;
	esac
done

[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";

if [[ "$NEED_SAVE" == "true" ]]; then
	bash "$__DIRNAME/save.sh" || exit 1;
fi

if ! has_mount "$NODE_MODULES_FULL_PATH"; then
	echo -e "${STYLE_WARN}warn: \"$NODE_MODULES\" has not mounted!${RESET}";
	exit 0;
fi

sudo umount "$NODE_MODULES_FULL_PATH";
[[ $? != 0 ]] && throw "sudo umount failed!";

config_cleanup_global_list;
echo "success: umount \"$NODE_MODULES\" from memory!";
