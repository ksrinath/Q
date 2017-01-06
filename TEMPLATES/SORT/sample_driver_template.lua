#!/usr/bin/env lua

local tmpl = dofile 'qsort.tmpl'

tmpl.SRTORDR = 'asc'
tmpl.ELEMTYPE = 'uint64_t'
tmpl.COMPARATOR = '>'
-- print(tmpl 'declaration')
doth = tmpl 'declaration'
print("doth = ", doth)
-- print(tmpl 'definition')
dotc = tmpl 'definition'
print("dotc = ", dotc)
