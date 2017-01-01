#!/usr/bin/env lua

require("aux")


local T = dofile 'f1f2opf3_operators.lua' 
local tmpl = dofile 'q_vector_vector.tmpl'
local types = { 'int8_t', 'int16_t', 'int32_t', 'int64_t','float', 'double' }

for i, v in ipairs(T) do
  local base_name = v
  print("base_name = ", base_name);
  local str = 'require \'' .. base_name .. '_static_checker\''
--  require concat_static_checker.lua
  load(str)()
  for i, intype1 in ipairs(types) do 
    for j, intype2 in ipairs(types) do 
      for k, outtype1 in ipairs(types) do 
        local fn, outtype, scalar_op, includes = 
        _G[base_name .. '_static_checker'](intype1, intype2, outtype1)
        if ( fn ) then
          if ( file_exists(base_name .. "_black_list.lua")) then 
            local B = dofile(base_name .. "_black_list.lua")
          end
          if ( file_exists(base_name .. "_white_list.lua")) then 
            local W = dofile(base_name .. "_white_list.lua")
          end
          if ( W and B ) then 
            error("Cannot have both black and white list")
          end

          tmpl.name = fn
          tmpl.op1type = intype1
          tmpl.op2type = intype2
          tmpl.returntype = outtype1
          tmpl.scalar_op = scalar_op
          -- process black/white lists
          local skip = false; local decided = false
          if ( ( not B ) and ( not W ) ) then 
            skip = false
            decided = true
          end
          if not decided and B then
            skip = false
            if B[fn] then
              skip = true
              decided = true
            end
          end
          if not decided and W then
            skip = true
            if W[fn] then
              skip = false
              decided = true
            end
          end
          if not decided then error("Control cannot come here") end
          if not skip then 
          -- print(tmpl 'declaration')
          doth = tmpl 'declaration'
          -- print("doth = ", doth)
          local f = assert(io.open("_" .. fn .. ".h", "w"))
          f:write(doth)
          f:close()
          -- print(tmpl 'definition')
          dotc = tmpl 'definition'
          -- print("dotc = ", dotc)
          local f = assert(io.open("_" .. fn .. ".c", "w"))
          f:write(dotc)
          f:close()
        end
      else
        -- print("Invalid combo ", intype1, " ", intype2, " ", outtype1)
        end
      end
    end
  end
end

