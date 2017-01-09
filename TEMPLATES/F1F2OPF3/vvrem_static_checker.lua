
function vvrem_static_checker(
  f1type, 
  f2type
  )
    local sz1 = g_sz[f1type]
    local sz2 = g_sz[f2type]
    local iorf1 = g_iorf[f1type]
    local iorf2 = g_iorf[f2type]
    if ( ( iorf1 == "floating_point" ) or 
         ( iorf2 == "floating_point" ) ) then
         print("remainder operator requires both operards to be integer")
         return nil
    end
    if ( sz1 < sz2 ) then 
         outtype = f1type
    else
         outtype = f2type
    end
    substitutions.fn = "vvrem_" .. f1type .. "_" .. f2type .. "_" .. outtype
    substitutions.in1type = f1type
    substitutions.in2type = f2type
    substitutions.returntype = l_outtype
    substitutions.scalar_op = " c = a % b "
    return substitutions, includes
end
