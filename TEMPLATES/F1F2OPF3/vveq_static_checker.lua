
function vveq_static_checker(
  f1type, 
  f2type
  )
  outtype = "int8_t"
  fn = "vveq_" .. f1type .. "_" .. f2type 
  scalar_op = "a == b"
  return fn, outtype, scalar_op, includes
end
