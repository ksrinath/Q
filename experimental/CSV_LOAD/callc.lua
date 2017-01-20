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

writenumdata = function (f, RECORD, typ, fp) 

  local ffi = require("ffi")
  local decl = "typedef struct FILE FILE;  FILE * convertAndWrite(const char **arr, char *type,int n, FILE *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
  --print(empid)
  local ty = ffi.new("char [?]", #typ)
  ffi.copy(ty, typ)
  
  n = table.getn(RECORD)
  local c_table = ffi.new("const char *[".. n .. "]",RECORD);

  local fp = f["convertAndWrite"](c_table , ty, #RECORD, fp)
  return fp
end


writestringdata = function (f, RECORD, typ, fp) 

  local ffi = require("ffi")
  local decl = "typedef struct FILE FILE;  FILE * convertAndWriteString(int32_t *arr, char *type,int n, FILE *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
  --print(empid)
  local ty = ffi.new("char [?]", #typ)
  ffi.copy(ty, typ)
  
  n = table.getn(RECORD)
  RECORD = ffi.new("int32_t [".. n .. "]", RECORD)

  local fp = f["convertAndWriteString"](RECORD , ty, n, fp)
  return fp
end


close = function (f, fp) 

  local ffi = require("ffi")
  local decl = "void close(FILE *fname);"
  print("\nCalling "..decl) 
  ffi.cdef(decl)	 
 
  f["close"](fp)
 
end
