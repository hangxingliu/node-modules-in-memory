#!/usr/bin/env bash


__DIRNAME=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`;
pushd "$__DIRNAME" > /dev/null;

if [[ -t 1 ]]; then
	COLOR_MODE=`tput colors`;
	if [[ -n "$COLOR_MODE" ]] && [[ "$COLOR_MODE" -ge 8 ]]; then
		BOLD="\x1b[1m"; RESET="\x1b[0m"; RED="\x1b[31m"; GREEN="\x1b[32m";
	fi
fi
function _pass() { echo -e "${GREEN}[~] ${BOLD}$1${RESET}${GREEN} is existed!${RESET}"; }
function _miss() { echo -e "${RED}[-] ${BOLD}$1${RESET}${RED} is missing!${RESET}"; MISSING="${MISSING} $1"; }
function check_deps() { [[ -n `which $1` ]] && _pass "$1" || _miss "$1"; }
# =================================

MISSING="";

echo -e "[.] checking dependencies ...";
check_deps "gawk";
check_deps "df";
check_deps "mountpoint";
check_deps "mount";
check_deps "umount";
check_deps "sudo";
check_deps "tar";

if [[ -n "$MISSING" ]]; then
	echo
	echo -e "${RED}[-] fatal: following dependencies are missing:";
	echo -e "${BOLD}    ${MISSING}${RESET}";
	echo -e "${RED}Please install them firstly! (exit with code 1)${RESET}";
	exit 1;
fi

UNAME_S=`uname -s`;
if [[ "${UNAME_S}" == Darwin* ]]; then
	echo
	echo -e "${RED}[-] fatal: node-modules-in-memory is not support MacOS now";
	echo -e "    (exit with code 1)${RESET}";
	exit 1;
fi

echo -e "${GREEN}${BOLD}[+] success: all dependencies are installed!\n    (exit with code 0)${RESET}";
exit 0;
