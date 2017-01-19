create = function (f, colname) 

  local ffi = require("ffi")
  local decl = "typedef struct FILE FILE;  FILE* createFile(char *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
  --print(empid)
  
  local fn = ffi.new("char [?]", #colname)
  ffi.copy(fn, colname)

  local fp = f["createFile"](fn)
  return fp;
end

write = function (f, RECORD, typ, fp) 

  local ffi = require("ffi")
  local decl = "typedef struct FILE FILE;  FILE* writeFile( char *arr, char *type, FILE *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
  --print(empid)
  local ty = ffi.new("char [?]", #typ)
  ffi.copy(ty, typ)

  local n = table.getn(RECORD)
  
  for i = 0,n,1 do
      local c_str = ffi.new(" char [?]", #RECORD[i])
      ffi.copy(c_str, RECORD[i])
      local fp = f["writeFile"](c_str,ty, fp)
  end
    
    return fp
end



close = function (f, fp) 

  local ffi = require("ffi")
  local decl = "void close(FILE *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
 
  f["close"](fp)
 
end
