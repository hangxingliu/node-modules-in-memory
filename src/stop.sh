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

[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";

sudo umount "$NODE_MODULES_FULL_PATH";
[[ $? != 0 ]] && throw "sudo umount failed!";

config_cleanup_global_list;
echo "success: umount \"$NODE_MODULES\" from memory!";
