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

RAW_SIZE="$DEFAULT_SIZE";

ARG_NAME="";
for argument in "$@"; do
	if [[ -n "$ARG_NAME" ]]; then
		case "$ARG_NAME" in
			--size) RAW_SIZE="$argument" ;;

			*)  throw "unknown option: \"$ARG_NAME\" " ;;
		esac
		ARG_NAME="";
	else
		ARG_NAME="$argument";
	fi
done

SIZE=`parse_size_to_bytes "$RAW_SIZE"`;
[[ -z "$SIZE" ]] && throw "invalid --size \"$RAW_SIZE\" !";


NODE_MODULES_FULL_PATH="$(pwd)/$NODE_MODULES";
HAS_MOUNT=`has_mount "$NODE_MODULES_FULL_PATH"`;
[[ -n "$HAS_MOUNT" ]] && throw "\"$NODE_MODULES\" has mounted! ($HAS_MOUNT)";

# adjust tmpfs size
if [[ -f "$RESTORE_FILE" ]]; then
	RESTORE_FILE_SIZE=`file_size "$RESTORE_FILE"`;
	RESTORE_FILE_SIZE_R=`file_size_human_readable "$RESTORE_FILE"`;
	if [[ "$RESTORE_FILE_SIZE" -gt "$SIZE" ]]; then
		INC_TO_SIZE=`multiply "$RESTORE_FILE_SIZE" "1.25"`;
		INC_TO_SIZE_R=`echo "$INC_TO_SIZE" | pipe_for_human_readable_size`;
		echo "[WARN]: because size of \"$RESTORE_FILE\" is $RESTORE_FILE_SIZE_R, so mount size increase to $INC_TO_SIZE($INC_TO_SIZE_R)";
		SIZE="$INC_TO_SIZE";
	fi
fi

if [[ -e "$NODE_MODULES" ]]; then
	[[ ! -d "$NODE_MODULES" ]] && throw "\"$NODE_MODULES\" is not a directory!";
	NODE_MODULES_INSIDE=`ls -A "$NODE_MODULES"`;
	[[ -n "$NODE_MODULES_INSIDE" ]] && throw "\"$NODE_MODULES\" is not empty, please 'stop' or delete firstly!";
else
	mkdir "$NODE_MODULES" || throw "could not create directory \"$NODE_MODULES\"!";
fi


sudo mount -t tmpfs -o size=${SIZE} tmpfs "$NODE_MODULES_FULL_PATH";
[[ $? != 0 ]] && throw "sudo mount failed!";

if [[ -f "$RESTORE_FILE" ]]; then

	pushd "$NODE_MODULES" >/dev/null || throw "could not \`pushd\` into \"$NODE_MODULES\"";
	tar -xf "../$RESTORE_FILE" \
		--no-overwrite-dir           || throw "restore \"$NODE_MODULES\" from \"$RESTORE_FILE\" failed!";
		# --no-overwrite-dir: prevent error about no permission of '.'
	popd >/dev/null                  || throw "could not \`popd\` from \"$NODE_MODULES\"";


	echo "success: restore \"$NODE_MODULES\" from \"$RESTORE_FILE\" into memory now!";
else
	echo "success: \"$NODE_MODULES\" into memory now!";
fi
