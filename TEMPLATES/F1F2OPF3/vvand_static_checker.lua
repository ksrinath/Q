
function vvand_static_checker(
  f1type, 
  f2type
  )
  if ( ( f1type ~= "int8_t" ) or ( f2type ~= "int8_t" ) ) then
    print("and requires both operands to be int8_t")
    return nil
  end
  outtype = "int8_t"
  fn = "vvand_" .. f1type .. "_" .. f2type 
  scalar_op = "c = a && b"
  return fn, outtype, scalar_op, includes
end
