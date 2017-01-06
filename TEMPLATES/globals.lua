g_sz = {}
g_sz["int8_t"]  = 8;
g_sz["int16_t"] = 16;
g_sz["int32_t"] = 32;
g_sz["int64_t"] = 64;
g_sz["float"]   = 32;
g_sz["double"]  = 64;
g_isz_to_fld = {}
g_isz_to_fld[8]  = "int8_t"
g_isz_to_fld[16] = "int16_t"
g_isz_to_fld[32] = "int32_t"
g_isz_to_fld[64] = "int64_t"
g_fsz_to_fld = {}
g_fsz_to_fld[32] = "float"
g_fsz_to_fld[64] = "double"
g_iorf = {}
g_iorf["int8_t"]  = "fixed";
g_iorf["int16_t"] = "fixed";
g_iorf["int32_t"] = "fixed";
g_iorf["int64_t"] = "fixed";
g_iorf["float"]   = "floating_point";
g_iorf["double"]  = "floating_point";