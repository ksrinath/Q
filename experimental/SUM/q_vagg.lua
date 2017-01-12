--[[ 
A function (that invokes a C function) to perform numerical aggregation of a vector.

Parameters: 
l - library containing aggFn
v - vector to be aggregated e.g. {3,2,5,-1}
elemType - type of vector elements e.g. "int32_t"
aggType - type of aggregation result e.g. "int64_t"
aggFn - name of the C function e.g. "sum"

The C function aggFn should have the signature
int <aggFn>(<elemType> *X, int n, <aggType> *ptr_sum)
--]]
vagg = function (l, v, elemType, aggType, aggFn) 

  local ffi = require("ffi")	--Loading the FFI library
  local decl = "int " .. aggFn .. "(" .. elemType .. " *X, int n, " .. aggType .. " *res);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	--Add a C declaration for the C function 
  
  local n = table.getn(v)
  local res = ffi.new(aggType .. "[1]"); -- create lua object equivalent to ptr_sum
  v = ffi.new(elemType .. "[" .. n .. "]", v) -- create lua object equivalent to X

  local status = l[aggFn](v, n, res) -- call the C function
  return tonumber(res[0]), status -- tonumber() ensures appropriate conversion to Lua number
end
