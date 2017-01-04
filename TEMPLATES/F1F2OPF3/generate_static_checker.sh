cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvsub_/'g > vvsub_static_checker.lua
cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvmul_/'g > vvmul_static_checker.lua
cat vvadd_static_checker.lua | \
  sed s'/vvadd_/vvdiv_/'g > vvdiv_static_checker.lua
