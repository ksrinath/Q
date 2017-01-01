#!/usr/bin/env lua


local T = dofile 'f1f2opf3_operators.lua' 
local tmpl = dofile 'q_vector_vector.tmpl'
local types = { 'int8_t', 'int16_t', 'int32_t', 'int64_t','float', 'double' }

for i, v in ipairs(T) do
  local base_name = v
  local str = 'require \'' .. base_name .. '_static_checker\''
  print("str = ",  str)
--  require concat_static_checker.lua
  load(str)()
  for i, intype1 in ipairs(types) do 
    for j, intype2 in ipairs(types) do 
      for k, outtype1 in ipairs(types) do 
        -- fn = _G['concat_static_checker']
        local fn, scalar_op = concat_static_checker(intype1, intype2, outtype1)
        if ( fn ) then
          tmpl.name = base_name
          tmpl.op1type = intype1
          tmpl.op2type = intype2
          tmpl.returntype = outtype1
          tmpl.scalar_op = scalar_op
          -- print(tmpl 'declaration')
          doth = tmpl 'declaration'
          -- print("doth = ", doth)
          local f = assert(io.open(fn .. ".h", "w"))
          f:write(doth)
          f:close()
          -- print(tmpl 'definition')
          dotc = tmpl 'definition'
          -- print("dotc = ", dotc)
          local f = assert(io.open(fn .. ".c", "w"))
          f:write(dotc)
          f:close()
      else
        -- print("Invalid combo ", intype1, " ", intype2, " ", outtype1)
        end
      end
    end
  end
end

