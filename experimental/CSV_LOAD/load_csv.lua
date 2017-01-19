local RECORD ={}  -- a table to collect all empid
RECORD[0] = {} 
RECORD[1] = {} 

--metadata 
local M = {
{ name = "empid",type = "int32_t" },
{ name = "yoj",type ="int16_t" },
}


function read()
    local count=0;
    for line in io.lines("/home/pragati/Desktop/CSV_LOAD/csv_inputfile.csv") do
      
      local eid, yr = line:match("%s*(.-),%s*(.-),%s*")
      RECORD[0][count] = eid
      RECORD[1][count] = yr
      count=count+1; 
    end
end

read() --call function to read csv file

local ffi = require("ffi") 
local mylib = ffi.load("/home/pragati/Desktop/CSV_LOAD/cfunc.so") 
require 'callc'

local fp

fp= create(mylib,M[1]["name"])
fp = write(mylib,RECORD[0],M[1]["type"], fp)
close(mylib,fp)


fp = create(mylib,M[2]["name"])
fp = write(mylib,RECORD[1],M[2]["type"], fp)
close(mylib,fp)

