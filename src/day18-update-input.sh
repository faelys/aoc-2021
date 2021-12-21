#!/bin/sh

# Copyright (c) 2021, Natacha Porté
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# This script filters a HLL template to insert a new set of inpu.t
# This is part of the brute-force solution to the second puzzle of the day,
# see day18-2.sh.
#
# Usage: ./day18-update-input.sh day18-input.txt >day18-generated.hll

set -Cue

: $1
: ${TEMPLATE:=$(dirname "$0")/day18.hll}
: ${INPUT_FILTER:=$(dirname "$0")/day18-input.sed}

sed 's@^ *int input_size.*$@// &@;/generated by filtering AoC input/q' \
    "${TEMPLATE}"

sed -f "${INPUT_FILTER}" "$1"

cat <<-EOF
	  };
	Constants:
EOF

echo "int input_size :=" \
    $(sed -f "${INPUT_FILTER}" "$1" | grep -o , | wc -l) \
    " + 1;"