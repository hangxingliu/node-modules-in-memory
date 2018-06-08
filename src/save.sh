#!/usr/bin/env bash

# Options
#  --file node_modules.tar

NODE_MODULES="node_modules";
TARGET_FILE="node_modules.tar";

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

[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";

if ! has_mount "$NODE_MODULES_FULL_PATH"; then
	NODE_MODULES_INSIDE=`ls -A "$NODE_MODULES"`;
	if [[ -z "$NODE_MODULES_INSIDE" ]]; then
		throw "\"$NODE_MODULES\" is empty and not mounted!";
	fi
fi

pushd "$NODE_MODULES" >/dev/null   || throw "could not \`pushd\` into \"$NODE_MODULES\"";
tar -cf "../$TARGET_FILE" "."      || throw "save \"$NODE_MODULES\" to \"$TARGET_FILE\" failed!";
popd >/dev/null                    || throw "could not \`popd\` from \"$NODE_MODULES\"";

echo "success: saved \"$NODE_MODULES\" to \"$TARGET_FILE\"!";
