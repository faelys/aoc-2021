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
! sed '1s/^[A-Z]*$//;3,$s/^[A-Z][A-Z] -> [A-Z]$//;' "$1" | grep .

# Convert inputs into HLL

cat <<-EOF
Constants:
  int init_size := $(head -n 1 "$1" | wc -c) - 1;

Types:
  enum { $(grep -o '[A-Z]' "$1" | sort -u | sed '1h;2,$H;${x;s/\n/, /gp;};d') } element;

Declarations:
  element init_string[init_size];
  element table(element, element);

Definitions:
  init_string := { $(head -n 1 "$1" | sed 's/./&, /g;s/, $//') };
  table(x, y) := ( x, y
EOF

sed -e '1,2d' \
    -e 's/^\([A-Z]\)\([A-Z]\) -> \([A-Z]\)$/                 | \1, \2 => \3/' \
    -e '$s/$/);/' \
    "$1"
