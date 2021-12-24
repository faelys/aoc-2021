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

# This script automates the optimization of day-24 first puzzle,
# buy repeatedly updating the candidate value using the counter-example
# extracted from the previous step, until the candidate is proved to be
# optimal

: ${EXPAND1:=expand1}
: ${CEX_SIM:=cex_simulator}
: ${S3:=s3}

set -Cuex

time ${EXPAND1} -hll day24.hll -lll day24-iter.lll -dumpMap day24-iter.map
time ${S3} -lll day24-iter.lll -cex day24-iter.cex \
    -analyse 1 2 join in 1 group -bmc stop 0
time ${CEX_SIM} -hll day24.hll -map day24-iter.map -cex day24-iter.cex \
    -res day24-iter.res -O
! grep -q 'CEX for PO 0' day24-iter.cex

while grep '^[0-9]' day24-iter.res; do
	sed '/int [ml]s_part_max/s@^@// @' day24.hll >|day24-iter.hll
	echo 'Constants:' >>day24-iter.hll
	grep '^[0-9]' day24-iter.res \
	    | sed -e 's/^.* //;s/$/;/' \
	          -e '1s/^/  int ms_part_max := /' \
	          -e '2s/^/  int ls_part_max := /' \
	    >>day24-iter.hll

	time ${EXPAND1} -hll day24-iter.hll -lll day24-iter.lll \
	    -dumpMap day24-iter.map
	time ${S3} -lll day24-iter.lll -cex day24-iter.cex \
	    -analyse 1 2 join in 1 group -bmc stop 0
	time ${CEX_SIM} -hll day24-iter.hll -map day24-iter.map \
	    -cex day24-iter.cex -res day24-iter.res -O
	! grep -q 'CEX for PO 0' day24-iter.cex
done

tail -n 2 day24-iter.hll
