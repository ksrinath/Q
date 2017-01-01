g_sz = {}
g_sz["int8_t"]  = 8;
g_sz["int16_t"] = 16;
g_sz["int32_t"] = 32;
g_sz["int64_t"] = 64;
g_sz["float"]   = 32;
g_sz["double"]  = 64;
g_isz_to_fld = {}
g_isz_to_fld[8]  = "int8_t"
g_isz_to_fld[16] = "int16_t"
g_isz_to_fld[32] = "int32_t"
g_isz_to_fld[64] = "int64_t"
g_fsz_to_fld = {}
g_fsz_to_fld[32] = "float"
g_fsz_to_fld[64] = "double"
g_iorf = {}
g_iorf["int8_t"]  = "fixed";
g_iorf["int16_t"] = "fixed";
g_iorf["int32_t"] = "fixed";
g_iorf["int64_t"] = "fixed";
g_iorf["float"]   = "floating_point";
g_iorf["double"]  = "floating_point";

function vvadd_static_checker(
  f1type, 
  f2type, 
  fouttype
  )
    local sz1 = g_sz[f1type]
    local sz2 = g_sz[f1type]
    local iorf1 = g_iorf[f1type]
    local iorf2 = g_iorf[f1type]
    if ( ( iorf1 == "fixed" ) and ( iorf2 == "fixed" ) ) then
      iorf_outtype = "fixed" 
    else
      iorf_outtype = "floating_point" 
    end
    sz_out = sz1; if ( sz2 > sz_out )  then sz_out = sz_2 end
    if ( iorf_outtype == "floating_point" ) then 
      l_outtype = g_fsz_to_fld[sz_out]
    else
      l_outtype = g_isz_to_fld[sz_out]
    end
    if ( fouttype ~= nil ) then 
      l_outtype = fouttype
      assert(g_sz[fouttype]) -- make sure that this is valid outtype
    end
    fn = "vvadd_" .. f1type .. "_" .. f2type .. "_" .. l_outtype 
    scalar_op = " a + b "
    return fn, l_outtype, scalar_op, includes
end
