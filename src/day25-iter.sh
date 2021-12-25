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

# This script automates the optimization of day-25 first puzzle,
# by repeatedly updating the state using the counter-example extracted from the
# previous step, until the end condition is met.

: ${CEX_SIM:=cex_simulator}

set -Cuex

time ${CEX_SIM} -hll day25.hll -map empty.map -cex empty-depth-0.cex -res day25-iter.res -O

while grep -q '^-1' day25-iter.res; do
	sed '/int T0/s@^@// @;/init_grid :=/q' day25.hll >|day25-iter.hll
	sed -n '/last_state/,/\/output/s/^[012]$/&,/p' day25-iter.res \
	    | sed '$s/,$//' >>day25-iter.hll
	echo '  };' >>day25-iter.hll
	echo 'Constants:' >>day25-iter.hll
	grep -A1 T0 day25-iter.res \
	    | sed -n 's/^[0-9]*$/  int T0 := &;/p' \
	    >>day25-iter.hll

	time ${CEX_SIM} -hll day25-iter.hll -map empty.map -cex empty-depth-0.cex -res day25-iter.res -O
done

grep -A1 answer_1 day25-iter.res
