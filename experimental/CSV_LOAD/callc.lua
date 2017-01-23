local ffi = require("ffi")
local binfilepath = "/home/pragati/Desktop/CSV_LOAD/"


ffi.cdef[[
  typedef struct FILE FILE;  FILE* createFile(char *fname);
  typedef struct FILE FILE;  FILE * convertAndWriteInteger(const char **arr, char *type,int n, FILE *fname);
  typedef struct FILE FILE;  FILE * convertAndWriteString(int32_t *arr, char *type,int n, FILE *fname);
  void close(FILE *fname);
  ]]
  
create = function (f, colname) 
  
  filepath = binfilepath..colname
  
  local fn = ffi.new("char [?]", #filepath, filepath)
  --print(filepath)
  
  local fp = f["createFile"](fn)
  return fp;
end

writenumdata = function (f, COLUMN, typ, fp) 
 
  local ty = ffi.new("char [?]", #typ, typ)
  
  n = table.getn(COLUMN)
  local c_table = ffi.new("const char *[".. n .. "]",COLUMN);

  local fp = f["convertAndWriteInteger"](c_table , ty, #COLUMN, fp)
  return fp
end


writestringdata = function (f, COLUMN, typ, fp) 

  local ty = ffi.new("char [?]", #typ, typ)
  
  n = table.getn(COLUMN)
  COLUMN = ffi.new("int32_t [".. n .. "]", COLUMN)

  local fp = f["convertAndWriteString"](COLUMN , ty, n, fp)
  return fp
end


close = function (f, fp) 
    f["close"](fp)
end
