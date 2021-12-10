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

# This scripts converts a sequence of bits into an XML counter-example.
# The input format is one stream per column and one line per time step,
# With 1 and 0 being converted into boolean f and t respectively.
# The input text should be limited to [-10tf ], and a column consisting only
# of spaces removes the stream from the output. A space in a column with
# other characters desynchronizes the variables, which might not be
# what you want.

# Usage: ./day10b-input.sh $(wc -c <day10.txt) <day10.txt >day10b.cex
# Generate an XML counter-example file matching read_char in day10b.hll
# Beware that this time it's `wc -c`, i.e. as many time steps as bytes
# in the input files.

set -Cue

: ${BIN2CEX:=$(dirname $0)/bin2cex.sed}
: $1

sed -e 's/{/  0000\n/g' \
    -e 's/}/  0010\n/g' \
    -e 's/\[/  1000\n/g' \
    -e 's/\]/  1010\n/g' \
    -e 's/(/  0100\n/g' \
    -e 's/)/  0110\n/g' \
    -e 's/</  1100\n/g' \
    -e 's/>/  1110\n/g' \
    -e 's/$/  0001/g' \
    | sed -f "${BIN2CEX}" \
    | sed "s/length=\"\"/length=\"$((${1} + 1))\" depth=\"${1}\"/"
