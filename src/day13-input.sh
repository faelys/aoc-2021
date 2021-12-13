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


set -Cue

if test $# -lt 1; then
	echo "Usage: $0 aoc-input.txt" >&2
	exit 1
fi

# Sanity tchecks

test -e "$1"
! sed '/^$/Q' "$1" | grep -v '^[0-9]\+,[0-9]\+$'
! sed '1,/^$/d' "$1" | grep -v '^fold along [xy]=[0-9]\+$'

# Convert inputs into HLL

cat <<-EOF
Constants:
  int nof_dots := $(sed '/^$/Q' "$1" | wc -l);
  int nof_folds := $(sed '1,/^$/d' "$1" | wc -l);

Types:
  enum { along_x, along_y } fold_direction;
  struct { dir:fold_direction, coord: int } fold_instruction;

Declarations:
  int init_dots[nof_dots][2];
  fold_instruction folds[nof_folds];

Definitions:
  init_dots := {
EOF

sed '/^$/{;x;s/^\n//;s/,$//p;Q};s/^/    { /;s/$/ },/;H;d' "$1"

cat <<-EOF
  };
  folds := {
EOF

sed '1,/^$/d;s/^fold along /    { along_/;s/=/, /;s/$/ },/;$s/,$//' "$1"

echo "  };"
