#!/usr/env/bin sed

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

# Insert braces around letter groups
s/[| ]\+/}, {/g
s/^/{/
s/$/}/

# Turn letters abcdefg into boolean arrays
s/{\([bcdefg]*}\)/{ false,\1/g
s/{\([bcdefg]*\)a\([bcdefg]*}\)/{ true,\1\2/g
s/,\([cdefg]*}\)/, false,\1/g
s/,\([cdefg]*\)b\([cdefg]*}\)/, true,\1\2/g
s/,\([defg]*}\)/, false,\1/g
s/,\([defg]*\)c\([defg]*}\)/, true,\1\2/g
s/,\([efg]*}\)/, false,\1/g
s/,\([efg]*\)d\([efg]*}\)/, true,\1\2/g
s/,\([fg]*}\)/, false,\1/g
s/,\([fg]*\)e\([fg]*}\)/, true,\1\2/g
s/,\(g*}\)/, false,\1/g
s/,\(g*\)f\(g*}\)/, true,\1\2/g
s/,}/, false }/g
s/,g}/, true }/g

# Gather boolean arrays in two levels of arrays
s/ *{/\n      {/g
s/^/    {/
s/$/\n    },/
$s/,$//
