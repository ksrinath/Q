#!/usr/bin/env lua

require("aux")

dofile '../globals.lua'

local srcdir = "../../PRIMITIVES/src/" 
local incdir = "../../PRIMITIVES/inc/" 
local T = dofile 'f1f2opf3_operators.lua' 
local tmpl = dofile 'f1f2opf3.tmpl'
local types = { 'int8_t', 'int16_t', 'int32_t', 'int64_t','float', 'double' }

for i, v in ipairs(T) do
  local base_name = v
  local str = 'require \'' .. base_name .. '_static_checker\''
--  require concat_static_checker.lua
  load(str)()
  for i, intype1 in ipairs(types) do 
    for j, intype2 in ipairs(types) do 
      for k, outtype1 in ipairs(types) do 
        stat_chk = base_name .. '_static_checker'
        assert(_G[stat_chk], "no checker for " .. base_name)
        local fn, outtype, scalar_op, includes = 
        _G[base_name .. '_static_checker'](intype1, intype2, outtype1)
        if ( fn ) then
          local B = nil; local W = nil
          if ( file_exists(base_name .. "_black_list.lua")) then 
            B = dofile(base_name .. "_black_list.lua")
          end
          if ( file_exists(base_name .. "_white_list.lua")) then 
            local w = dofile(base_name .. "_white_list.lua")
            W = {}
            for i, v in ipairs(w) do
              W[v] = true
            end
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
          if ( ( B == nil ) and ( W == nil ) ) then 
            skip = false
            decided = true
          end
          if ( ( B ~= nil ) and ( decided == false ) ) then
            if B[fn] then skip = true else skip = false end 
            decided = true
          end
          if ( ( W ~= nil ) and ( decided == false ) ) then
            if W[fn] then skip = false else skip = true end 
            decided = true
            if ( skip == true ) then print("Skipping ", fn) end
          end
          if not decided then error("Control cannot come here") end
          if not skip then 
          -- print(tmpl 'declaration')
          doth = tmpl 'declaration'
          -- print("doth = ", doth)
          local fname = incdir .. "_" .. fn .. ".h", "w"
          local f = assert(io.open(fname, "w"))
          f:write(doth)
          f:close()
          -- print(tmpl 'definition')
          dotc = tmpl 'definition'
          -- print("dotc = ", dotc)
          local fname = srcdir .. "_" .. fn .. ".c", "w"
          local f = assert(io.open(fname, "w"))
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

