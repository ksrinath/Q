DC_TOP		= ../../../dyncall
CC		= gcc
LUA_INCDIR	= /usr/local/include
LUA_LIBDIR	= /usr/local/lib
CFLAGS	= -I$(LUA_INCDIR) -I$(DC_TOP)/include
LIBS = -L$(LUA_LIBDIR) $(LUA_LIBDIR)/liblua.5.2.4.dylib -L$(DC_TOP)/lib -ldynload_s -ldyncall_s

all: luadc.dll

luadc.dll: luadc.o
	gcc --shared $^ $(LIBS) $(OUTPUT_OPTION)

