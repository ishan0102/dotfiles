#!/bin/bash

# Tool for profiling python programs
function pyprof() {
	TMPNAME=.pyprof.profile.dot 
	python3 -m cProfile -o profile $@ && gprof2dot -f pstats profile -o $TMPNAME && dot $TMPNAME -O -Tpdf && open $TMPNAME.pdf
}