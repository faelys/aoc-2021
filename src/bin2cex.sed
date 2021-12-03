#!/usr/bin/env sed

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

1{
	h
	s/^.*$/s1=\ns2=\ns3=\ns4=\ns5=\ns6=\ns7=\ns8=\ns9=\ns10=\ns11=\ns12=\ns13=\ns14=\ns15=\ns16=\ns17=\ns18=\ns19=\ns20=\ns21=\ns22=\ns23=\ns24=\ns25=\ns26=\ns27=/
	x
}

s/0/f/g
s/1/t/g

H
x
s/\n$//
s/\(s1=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s2=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s3=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s4=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s5=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s6=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s7=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s8=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s9=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s10=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s11=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s12=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s13=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s14=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s15=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s16=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s17=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s18=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s19=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s20=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s21=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s22=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s23=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s24=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s25=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s26=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\(s27=[^\n]*\)\(.*\n\)\(.\)\([^\n]*\)$/\1 \3\2\4/
s/\n*$//

${
	s/$/\n/
	s/^/<models>\n<model name="CEX for PO 1" type="cex" length="">\n/
	s@$@</model>\n</models>@
	s/s[0-9]*= *\n//g
	s/\(s[0-9]*\)= \([^\n]*\)/<variable name="\1" type="bool" kind="input">\n\2\n<\/variable>/g
	p
}
x
d
