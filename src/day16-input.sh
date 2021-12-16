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

# Usage: ./day16-input.sh (wc -c <day16-input.txt) <day16-input.txt >day16.cex

set -Cue

: ${BIN2CEX:=$(dirname $0)/bin2cex.sed}
: $1

sed -e 's/[fF]/tttt/g' -e 's/[eE]/tttf/g' -e 's/[dD]/ttft/g' -e 's/[cC]/ttff/g'\
    -e 's/[bB]/tftt/g' -e 's/[aA]/tftf/g' -e 's/9/tfft/g' -e 's/8/tfff/g' \
    -e 's/7/fttt/g' -e 's/6/fttf/g' -e 's/5/ftft/g' -e 's/4/ftff/g' \
    -e 's/3/fftt/g' -e 's/2/fftf/g' -e 's/1/ffft/g' -e 's/0/ffff/g' \
    -e 's/[^ft]//g' -e 's/[ft]/  &f\n/g' -e '$s/$/  ft/' \
    | sed -f "${BIN2CEX}" \
    | sed "s/length=\"\"/length=\"$((4 * ${1} - 3))\" depth=\"$((4 * ${1} - 4))\"/"
