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
# ===============
popd > /dev/null;

function throw() { echo -e "fatal: $1" > /dev/stderr; exit 1; }

[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";

pushd "$NODE_MODULES" >/dev/null   || throw "could not \`pushd\` into \"$NODE_MODULES\"";
tar -cf "../$TARGET_FILE" "."      || throw "save \"$NODE_MODULES\" to \"$TARGET_FILE\" failed!";
popd >/dev/null                    || throw "could not \`popd\` from \"$NODE_MODULES\"";

echo "success: saved \"$NODE_MODULES\" to \"$TARGET_FILE\"!";
