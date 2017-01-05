cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvsub_/'g | \
  sed s'/scalar_op = .*$/scalar_op = "( a - b )" /'g \
  > vvsub_static_checker.lua

cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvmul_/'g | \
  sed s'/scalar_op = .*$/scalar_op = "( a * b )" /'g \
  > vvmul_static_checker.lua

cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvdiv_/'g | \
  sed s'/scalar_op = .*$/scalar_op = "( a \/ b )" /'g \
  > vvdiv_static_checker.lua

cat vvand_static_checker.lua | \
  sed s'/vvand_/vvor_/'g | \
  sed s'/scalar_op = .*$/scalar_op = "( a || b )" /'g \
  > vvor_static_checker.lua

cat vvand_static_checker.lua | \
  sed s'/vvand_/vvxor_/'g | \
  sed s'/scalar_op = .*$/scalar_op = "( a ^ b )" /'g \
  > vvxor_static_checker.lua

# why does following not work TODO
# cat vvand_static_checker.lua | \
#   sed s'/vvand_/vvandnot/'g | \
#   sed s'/scalar_op = .*$/scalar_op = "( a && (\~b) )" /'g \
#   > vvandnot_static_checker.lua
