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
source ./_utils.sh
# ===============
popd > /dev/null;


function throw() { echo -e "fatal: $1" > /dev/stderr; exit 1; }

[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";

sudo umount "$NODE_MODULES_FULL_PATH";
[[ $? != 0 ]] && throw "sudo umount failed!";

echo "success: umount \"$NODE_MODULES\" from memory!";
