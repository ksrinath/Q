g_bitlen = {}
g_bitlen["int8_t"]  = 8;
g_bitlen["int16_t"] = 16;
g_bitlen["int32_t"] = 32;
g_bitlen["int64_t"] = 64;
g_bitlen["float"]   = 32;
g_bitlen["double"]  = 64;

function concat_static_checker(
  f1type, 
  f2type, 
  fouttype
  )
  local shift = g_bitlen[f2type]
  if not ( ( f1type == "int8_t" ) or 
     ( f1type == "int16_t" ) or 
     ( f1type == "int32_t" ) ) then
     print("concat requires fldtype of 1st argument to be I1/I2/I4")
     return nil
  end
  if not ( ( f2type == "int8_t" ) or 
     ( f2type == "int16_t" ) or 
     ( f2type == "int32_t" ) ) then
     print("concat requires fldtype of 1st argument to be I1/I2/I4")
     return nil
  end
  local l_outtype = nil
  if ( f1type == "int32_t" ) then 
     l_outtype = "int64_t"
  elseif( f1type == "int16_t" ) then 
    if ( f2type == "int32_t" ) then
      l_outtype = "int64_t"
    elseif( f2type == "int16_t" ) then
      l_outtype = "int32_t"
    elseif( f2type == "int8_t" ) then
      l_outtype = "int32_t"
    end
  elseif( f1type == "int8_t" ) then 
    if ( f2type == "int32_t" ) then
      l_outtype = "int64_t"
    elseif( f2type == "int16_t" ) then
      l_outtype = "int32_t"
    elseif( f2type == "int8_t" ) then
      l_outtype = "int16_t"
    end
  end
  if ( l_outtype == nil ) then 
    error("Control should never come here")
  end

  if ( fouttype ~= nil ) then 
    print("fouttype = ", fouttype)
    print("l_outtype = ", l_outtype)
    if ( g_bitlen[fouttype] >= g_bitlen[l_outtype] ) then
      l_outtype = fouttype
    else
      print("specified output type is not big enough")
      return nil
    end
  end
  fn = "concat_" .. f1type .. "_" .. f2type .. "_" .. l_outtype 
  scalar_op = " ( (l_outtype)A << " .. shift .. " ) | B "
  includes = {"math", "curl/curl" }
  return fn, l_outtype, scalar_op, includes
end
