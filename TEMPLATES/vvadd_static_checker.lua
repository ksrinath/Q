
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
    scalar_op = "(" .. l_outtype ..") .. a + (" .. l_outtype .. ")b "
    return fn, l_outtype, scalar_op, includes
end
