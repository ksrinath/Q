local so_file_path_name = "/home/pragati/Desktop/CSV_LOAD/cfunc.so" --path for .so file
local csv_file_path_name = "/home/pragati/Desktop/CSV_LOAD/csv_inputfile.csv" --path for input csv file 

local RECORD = {}  
local DICT = {}

local namecount=1;

--metadata 
local M = {
{ name = "empid", type = "int32_t" },
{ name = "yoj", type ="int16_t" },
{ name = "empname", type ="varchar"},
}

for i=1,#M do -- to create no. of columns as M wants
  RECORD[i] = {} 
end

cntdict=1;
for i=1,#M do -- to create no. of dictionaries as M wants for varchar
  if string.sub(M[i]["type"],1,string.len("var"))=="var" then
       DICT[cntdict] = {}
       cntdict =cntdict +1
  end
end

function read(csv_file)
    local count=1;
    for line in io.lines(csv_file) do
      
      local eid, yr,ename = line:match("%s*(.-),%s*(.-),%s*(.-),%s*(.-)")
      RECORD[1][count] = eid
      RECORD[2][count] = yr
      
      table.insert(DICT,{name = ename, val =namecount })
      RECORD[3][count] = namecount
      
      namecount = namecount +1
      count = count +1
    end
end

read(csv_file_path_name) --call function to read csv file

--[[
print("\nDictionary: name mapping")
for i, v in ipairs(DICT) do
	print(string.format("name=%s, value=%d", v.name, v.val))
end--]]

local ffi = require("ffi") 
local mylib = ffi.load(so_file_path_name) 
require 'callc'


local fp
for i=1,#RECORD do
  
    if string.sub(M[i]["type"],1,string.len("int"))=="int" then  --if column is integer
        
        fp= create(mylib,M[i]["name"])
        fp = writenumdata(mylib,RECORD[i],M[i]["type"], fp)
        close(mylib,fp)
 
    elseif string.sub(M[i]["type"],1,string.len("var"))=="var" then --if column is varchar
        
        fp = create(mylib,M[i]["name"])
        fp = writestringdata(mylib,RECORD[i],"int32_t", fp)
        close(mylib,fp)
        
    end
    
end

  