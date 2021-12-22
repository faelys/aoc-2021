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

test -e "$1"

XLIST=$(sed 's/^.*x=//;s/,.*$//;s/\.\./ /' "$1" \
      | while read MIN MAX; do \
          echo "$MIN"; echo "$((MAX+1))"; \
        done \
      | sort -un)
YLIST=$(sed 's/^.*y=//;s/,.*$//;s/\.\./ /' "$1" \
      | while read MIN MAX; do \
          echo "$MIN"; echo "$((MAX+1))"; \
        done \
      | sort -un)
ZLIST=$(sed 's/^.*z=//;s/\.\./ /' "$1" \
      | while read MIN MAX; do \
          echo "$MIN"; echo "$((MAX+1))"; \
        done \
      | sort -un)

cat <<-EOF
Constants:
  int nof_instructions := $(wc -l <"$1");
  int nof_x := $(echo "$XLIST" | wc -l);
  int nof_y := $(echo "$YLIST" | wc -l);
  int nof_z := $(echo "$ZLIST" | wc -l);

Declarations:
  instruction instr[nof_instructions];
  int x_list[nof_x];
  int y_list[nof_y];
  int z_list[nof_z];

Definitions:
  instr := {
$(sed 's/ /, /;s/[xyz]=//g;s/\.\./,/g;s/^/    { /;s/$/ },/;$s/,$//' "$1")
  };
  x_list := {
$(echo "$XLIST" | sed 's/^/    /;s/$/,/;$s/,$//')
  };
  y_list := {
$(echo "$YLIST" | sed 's/^/    /;s/$/,/;$s/,$//')
  };
  z_list := {
$(echo "$ZLIST" | sed 's/^/    /;s/$/,/;$s/,$//')
  };
