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

# This scriptes automates the brute-force resolution of the sceond puzzle
# of day 18, by selecting a pair of lines for the input, generating
# the corresponding HLL file, expanding it, and running it through
# cex_simulator to generate results.
# If a result file already exists, the pair is skipped, so that the script
# can be run with an increasingly larger counter-example file after having
# deleted inconclusive results (`rm $(grep -l ' 0$' day18-2-*.res`).
#
# Note that while this gave the correct answer, it took more than two days
# to run the 9900 pairs of my user-specific input. I might have been a bit
# heavy-handed on the depth though.

set -Cue

: ${INPUT_DATA:=$1}
: ${EMPTY_CEX:=$2}
: ${OUTPUT_PREFIX:=$3}
: ${GENERATE_INPUT:=$(dirname "$0")/day18-update-input.sh}
: ${EXPAND1:=expand1}
: ${CEX_SIM:=cex_simulator}

LINE_COUNT=$(wc -l <"${INPUT_DATA}")

TMP_TXT=$(mktemp)
TMP_HLL=$(mktemp)
TMP_MAP=$(mktemp)

trap 'rm -f "${TMP_TXT}" "${TMP_HLL}" "${TMP_MAP}"' EXIT

for i in $(seq 1 $((LINE_COUNT - 1))); do
	for j in $(seq $((i + 1)) ${LINE_COUNT}); do
		if ! test -e "${OUTPUT_PREFIX}"-$i-$j.res then
			echo "Processing $i-$j (out of ${LINE_COUNT})"
			sed -n "$i p; $j p" "${INPUT_DATA}" >|"${TMP_TXT}"

			"${GENERATE_INPUT}" "${TMP_TXT}" >|"${TMP_HLL}"
			"${EXPAND1}" -hll "${TMP_HLL}" -lll /dev/null \
			    -dumpMap "${TMP_MAP}"
			"${CEX_SIM}" -hll "${TMP_HLL}" -map "${TMP_MAP}" \
			    -cex "${EMPTY_CEX}" \
			    -res "${OUTPUT_PREFIX}"-$i-$j.res -O
		fi

		if ! test -e "${OUTPUT_PREFIX}"-$j-$i.res then
			echo "Processing $j-$i (out of ${LINE_COUNT})"
			sed -n "$j p" "${INPUT_DATA}" >|"${TMP_TXT}"
			sed -n "$i p" "${INPUT_DATA}" >>"${TMP_TXT}"

			"${GENERATE_INPUT}" "${TMP_TXT}" >|"${TMP_HLL}"
			"${EXPAND1}" -hll "${TMP_HLL}" -lll /dev/null \
			    -dumpMap "${TMP_MAP}"
			"${CEX_SIM}" -hll "${TMP_HLL}" -map "${TMP_MAP}" \
			    -cex "${EMPTY_CEX}" \
			    -res "${OUTPUT_PREFIX}"-$j-$i.res -O
		fi
	done
done
