require 'parser'
require 'callc'

local so_file_path_name = "/home/pragati/Desktop/CSV_LOAD/cfunc.so" --path for .so file

local ffi = require("ffi") 
local mylib = ffi.load(so_file_path_name) 

function load( csv_file, M )
  
  COLUMN = {}  
  D = {}
  namecount=1;

  for i=1,#M do      -- to create no. of columns as M wants
      COLUMN[i] = {} 
  end

  cntdict=1;
  for i=1,#M do       -- to create no. of dictionaries as M wants for varchar
      if M[i]["type"]=="varchar" then
          D[cntdict] = {}
          cntdict =cntdict +1
      end
  end
  
  local count=1;
  for line in io.lines(csv_file) do
      local res= ParseCSVLine(line,',')       -- call to parse and read the csv file
          
      for i in pairs(res)do
            
          if M[i]["type"]=="int32_t" or M[i]["type"]=="int16_t" then
               
              COLUMN[i][count] = res[i] --if its an int col insert into table directly
                
          elseif M[i]["type"]=="varchar" then 
               
              tabno=  string.sub(M[i]["dict"], 2, -1)  --if it is a varchar/string col so insert into dictionary
              tabno= tonumber(tabno)
              
              table.insert(D[tabno],{key = res[i], val =namecount })
              COLUMN[i][count] = namecount
              namecount = namecount +1
                
          end
      end
      count=count+1;
  end
    
    
  local fp
  for i=1,#COLUMN do
  
    if M[i]["type"]=="varchar" then  --if column is string data
        
        fp = create(mylib,M[i]["name"])
        fp = writestringdata(mylib,COLUMN[i],"int32_t", fp)
        close(mylib,fp)
    else                            --if cloumn is integer data
        fp= create(mylib,M[i]["name"])
        fp = writenumdata(mylib,COLUMN[i],M[i]["type"], fp)
        close(mylib,fp)
 
    end
  end
  
end


--[[
print("\nDictionary: name mapping")
for i, v in ipairs(D[1]) do
	print(v.key, v.val)
end
--]]


