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

set -Cue

if test $# -lt 1; then
	echo "Usage: $0 aoc-input.txt" >&2
	exit 1
fi

# Sanity checks

test -e "$1"
! grep '[^a-zA-Z-]' "$1"
! grep -e '-.*-' "$1"
! grep '[a-z][A-Z]' "$1"
! grep '[A-Z][a-z]' "$1"

# Node enumeration

COUNT="$(sed 's/-/\n/' "$1" | sort -u | wc -l)"
I=0

cat <<-EOF
Constants:
  int nof_caves := ${COUNT};
EOF

sed 's/-/\n/' "$1" \
   | sort -u \
   | grep -vFx -e end -e start \
   | while read NAME; do
	echo "  int ${NAME} := ${I};"
	I=$((I + 1))
done

cat <<-EOF
  int start := $((COUNT - 2));
  int end := $((COUNT - 1));

Types:
  int[0, nof_caves-1] cave;

Declarations:
  bool is_big(cave);
  bool has_edge(cave, cave);

Definitions:
EOF
echo "  is_big := {" \
     $(sed 's/-/\n/' "$1" \
       | sort -u \
       | grep -vFx -e end -e start \
       | sed 's/$/,/;$s/$/ false, false/;s/[A-Z]\+/TRUE/;s/[a-z]\+/false/') \
     "};"
echo "  has_edge(e1, e2) := False"
sed -e 's/^\(.*\)-\(.*\)$/    # (e1 = \1 \& e2 = \2) # (e1 = \2 \& e2 = \1)/' \
    -e '$s/$/;/' "$1"
