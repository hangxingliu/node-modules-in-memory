#!/usr/bin/env bash


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
	mount | gawk -v test_dir="$1" '{
		if(index($0, test_dir))
			print $1;
	}';
}
