#!/usr/bin/env bash

# man test:
# -t FD  file descriptor FD is opened on a terminal
if [[ -t 1 ]]; then # test is terminal (0: stdin, stdout: 1, stderr: 2)
	COLOR_MODE=`tput colors`; # 8, 256
	if [[ -n "$COLOR_MODE" ]] && [[ "$COLOR_MODE" -ge 8 ]]; then
		# using \x1b but not \e is used for gawk
		BOLD="\x1b[1m";
		DIM="\x1b[2m";
		ITALIC="\x1b[3m";
		UNDERLINE="\x1b[4m";
		RESET="\x1b[0m";

		RED="\x1b[31m";
		GREEN="\x1b[32m";
		YELLOW="\x1b[33m";
		BLUE="\x1b[34m";
		PURPLE="\x1b[35m";
		CYAN="\x1b[36m";
		GREY="\x1b[37m";

		BG_WHITE="\x1b[107m\x1b[48;5;231m"; # it actual is dark grey # rgb8 and rgb256

		# combine font styles:
		STYLE_ERROR="${BOLD}${RED}";
		STYLE_WARN="${BOLD}${YELLOW}";
		STYLE_SUCCESS="${BOLD}${GREEN}";
	fi
fi

# $1: size
# size format is same with `dd`
# > N and BYTES may be followed by the following multiplicative suffixes:  c  =1,  w
# >       =2,  b  =512,  kB  =1000,  K  =1024,  MB  =1000*1000,  M  =1024*1024,  xM =M, GB
# >       =1000*1000*1000, G =1024*1024*1024, and so on for T, P, E, Z, Y.
# E, Z, Y are not supported not.
function parse_size_to_bytes() {
	# Reference:
	#  https://github.com/patrickkettner/filesize-parser/blob/master/index.js
	gawk -v raw_size="$1" 'BEGIN {
		size_str   = tolower(raw_size);
		str_len    = length(size_str);

		suffix_1   = substr(size_str, str_len, 1);
		suffix_2   = substr(size_str, str_len - 1, 2);

		unit       = 1;
		suffix_len = 0;

		if(suffix_2 == "kb") { suffix_len = 2; unit = 1000; }
		else if(suffix_2 == "mb") { suffix_len = 2; unit = 1000 * 1000; }
		else if(suffix_2 == "xm") { suffix_len = 2; unit = 1000 * 1000; }
		else if(suffix_2 == "gb") { suffix_len = 2; unit = 1000 * 1000 * 1000; }
		else if(suffix_2 == "tb") { suffix_len = 2; unit = 1000 * 1000 * 1000 * 1000; }
		else if(suffix_2 == "pb") { suffix_len = 2; unit = 1000 * 1000 * 1000 * 1000 * 1000; }

		else if(suffix_1 == "c") { suffix_len = 1; unit = 1; }
		else if(suffix_1 == "w") { suffix_len = 1; unit = 2; }
		else if(suffix_1 == "b") { suffix_len = 1; unit = 512; }
		else if(suffix_1 == "k") { suffix_len = 1; unit = 1024; }
		else if(suffix_1 == "m") { suffix_len = 1; unit = 1024 * 1024; }
		else if(suffix_1 == "g") { suffix_len = 1; unit = 1024 * 1024 * 1024; }
		else if(suffix_1 == "t") { suffix_len = 1; unit = 1024 * 1024 * 1024 * 1024; }
		else if(suffix_1 == "p") { suffix_len = 1; unit = 1024 * 1024 * 1024 * 1024 * 1024; }

		else if(!match(suffix_2, /^[0-9]+$/)) {
			print("error: invalid size string: \"" raw_size "\"") > "/dev/stderr";
			exit 1;
		}

		num = substr(size_str, 1, str_len - suffix_len);
		print num * unit;
		exit;
	}';
}


# $1: path
function has_mount() {
	mountpoint -q -- "$1";
	return $?;
}

# $1: mount_point
function get_mount_size() {
	# -k: uses 1024-byte (1K) units instead of the default 512-byte units when reporting space information.
	df -k --output=size "$1" | awk 'NR == 2 { print $1 * 1024; }'
}

# $1: mount_point
function get_mount_used_size() {
	# -k: uses 1024-byte (1K) units instead of the default 512-byte units when reporting space information.
	df -k --output=used "$1" | awk 'NR == 2 { print $1 * 1024; }'
}

# $1: path
function file_size() {
	stat --printf="%s" "$1";
}

# $1: path
function file_size_human_readable() {
	# https://unix.stackexchange.com/questions/44040/a-standard-tool-to-convert-a-byte-count-into-human-kib-mib-etc-like-du-ls1
	stat --printf="%s" "$1" | pipe_for_human_readable_size;
}

function pipe_for_human_readable_size() {
	awk 'function human(x) {
		if (x < 1000)
			return x;
		x /= 1024;
		s = "kMGTEPZY";
		while (x >= 1000 && length(s) > 1) {
			x /= 1024;
			s = substr(s,2);
		}
		return int(x+0.5) substr(s,1,1);
	}
	{
		sub(/^[0-9]+/, human($1));
		print;
	}';
}

# $1: a
# $2: b
# return a*b
function multiply() {
	awk -v a="$1" -v b="$2" 'BEGIN { print a * b; exit; }';
}
