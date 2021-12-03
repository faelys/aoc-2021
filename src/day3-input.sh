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

# Example usage: ./day3a-input.sh $(wc -l day3-input.txt) <day3-input.txt >day3a.cex

# This script converts Advent of Code input into an XML counter-example.
# It relies on the following mapping (from day3.map)
#   end_of_report : {s3}
#   report_bits[0] : {s4}
#   report_bits[1] : {s5}
#   report_bits[2] : {s6}
#   report_bits[3] : {s7}
#   report_bits[4] : {s8}
#   report_bits[5] : {s9}
#   report_bits[6] : {s10}
#   report_bits[7] : {s11}
#   report_bits[8] : {s12}
#   report_bits[9] : {s13}
#   report_bits[10] : {s14}
#   report_bits[11] : {s15}

set -Cue

: ${BIN2CEX:=$(dirname $0)/bin2cex.sed}
: $1

(sed 's/^/  000000000000000/;s/0*\([01]\{13\}\)$/\1/'; echo '  tffffffffffff') \
    | sed -f "${BIN2CEX}" \
    | sed "s/length=\"\"/length=\"$((${1} + 1))\" depth=\"${1}\"/"
