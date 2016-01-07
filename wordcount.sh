#!/bin/sh
#
# wordcount.sh
#
# Count the number of words in all files given on the command line. This
# strips line numbers and all metadata in the input files before counting.
#
# Arguments: <filename1> [<filename2> ...]

# "$@" produces "$1" "$2" "$3" etc. We need this because our filenames
# contain spaces and so must be quoted.
cat "$@" | \
	# Strip initial line numbers and tabs. Sed can’t handle \t apparently
	# so we use a raw tab character.
	sed -E 's/^[0-9]*	(.*)/\1/' | \
	# Delete metadata lines, those enclosed in {...}.
	sed -E '/^\{.*\}$/d' | \
	# Count orthographic words separated by spaces.
	wc -w
