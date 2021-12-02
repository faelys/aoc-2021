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

# Example usage: ./day2-input.sh $(wc -l day2-input.txt) <day2-input.txt >day2b-dyn.cex

# This script converts Advent of Code input into an XML counter-example.
# It relies on the following mapping (from day2b-dyn.map)
#   dir : {s3,s4,-}
#   amount : {s5,s6,s7,s8,-}
# And the following order of values for the direction:
#   enum { finished, forward, up, down }
#   /*        0         1     2    3       */


set -Cue

: ${BIN2CEX:=$(dirname $0)/bin2cex.sed}
: $1

(while read DIR AMOUNT; do
	BIN_AMOUNT_BE=ffff$(printf "%o" ${AMOUNT} \
	    | sed -e 's/0/fff/g;s/1/fft/g;s/2/ftf/g;s/3/ftt/g' \
	          -e 's/4/tff/g;s/5/tft/g;s/6/ttf/g;s/7/ttt/g')
	BIN_AMOUNT_LE=$(echo ${BIN_AMOUNT_BE} \
	    | sed 's/^.*\(.\)\(.\)\(.\)\(.\)/\4\3\2\1/')
	case ${DIR} in
	    (forward)
		echo "  tf${BIN_AMOUNT_LE}"
		;;
	    (up)
		echo "  ft${BIN_AMOUNT_LE}"
		;;
	    (down)
		echo "  tt${BIN_AMOUNT_LE}"
		;;
	    (*)
		echo "Unknown direction \"${DIR}\"" >&2
		exit 1
	esac
done; echo "  ffffff") \
    | sed -f "${BIN2CEX}" \
    | sed "s/length=\"\"/length=\"$((${1} + 1))\" depth=\"${1}\"/"
