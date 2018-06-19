#!/usr/bin/env bash

# Options
#  --size 100M

NODE_MODULES="node_modules";
RESTORE_FILE="node_modules.tar";
DEFAULT_SIZE="50M";

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

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";
NEED_START=true;
if has_mount "$NODE_MODULES_FULL_PATH"; then
	NEED_START=false;

elif [[ -e "$NODE_MODULES_FULL_PATH" ]]; then
	[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

	NODE_MODULES_INSIDE=`ls -A "$NODE_MODULES"`;
	if [[ -n "$NODE_MODULES_INSIDE" ]]; then
		echo -e "${STYLE_WARN}warn: \"$NODE_MODULES\" is still located on disk but not memory!${RESET}";
		NEED_START=false;
	fi
fi

if [[ "$NEED_START" == "true" ]]; then
	bash "$__DIRNAME/start.sh" || exit 1;
fi

npm "$@";
exit $?;
