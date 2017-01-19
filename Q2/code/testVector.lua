local ffi = require "ffi"
ffi.cdef("int print_vector(int* ptr, int length);")
local c = ffi.load('./print.so')
local dbg = require("debugger")
local Generator = require "Generator"
local Vector = require 'Vector'
g_valid_types = {}
g_valid_types['i'] = 'int'
g_valid_types['f'] = 'float'
g_valid_types['d'] = 'double'
g_valid_types['c'] = 'char'
g_chunk_size = 10
--local size = 1000
--create bin file of only ones of type int
local v1 = Vector{field_type='i', 
            filename='test1.txt', }

local v2 = Vector{field_type='i', 
            filename='test1.txt', }

local x = v1:chunk(0)
c.print_vector(x, g_chunk_size)
local y = v2:chunk(1)
c.print_vector(y, g_chunk_size)
local v1_gen = Generator{vec=v1}
print(v1_gen)
local i = 0
 while(v1_gen:status() ~= 'dead')
     do
        local status, chunk, size = v1_gen:get_next_chunk()
         print(i, status, size)
         i = i +1
         c.print_vector(chunk, g_chunk_size)
     end

