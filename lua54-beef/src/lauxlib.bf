/*
** $Id: lauxlib.bf
** Auxiliary functions for building Lua libraries
** See Copyright Notice in lua.bf
*/
using System;

namespace lua54_beef
{ 
	[CRepr]
	public struct luaL_Reg {
	  	public char8* name;
	  	public lua_CFunction func;

		public this(char8* name, lua_CFunction func)
        {
            this.name = name;
            this.func = func;
        }
	}

	/* }====================================================== */ 

	/*
	** {======================================================
	** Generic Buffer manipulation
	** =======================================================
	*/

	[CRepr]
	public struct luaL_Buffer {
		public char8* b;                     /* buffer address */
		public size_t size;                  /* buffer size */
		public size_t n;                     /* number of characters in buffer */
		public lua_State* L;
		public char8[lua.BUFFERSIZE] initb;  /* initial buffer */

		public this(char8* b, size_t size, size_t n, lua_State* L, char8[lua.BUFFERSIZE] initb)
        {
            this.b = b;
            this.size = size;
            this.n = n;
            this.L = L;
            this.initb = initb;
        }
	}

	/* }====================================================== */ 

	/*
	** {======================================================
	** File handles for IO library
	** =======================================================
	*/

	/*
	** A file handle is a userdata with metatable 'LUA_FILEHANDLE' and
	** initial structure 'luaL_Stream' (it may contain other fields
	** after that initial structure).
	*/
	
	[CRepr]
	public struct luaL_Stream {
		public void* f;  			 /* stream (NULL for incompletely created streams) */
		public lua_CFunction closef; /* to close stream (NULL for closed streams) */

		public this(void* f, lua_CFunction closef)
        {
            this.f = f;
            this.closef = closef;
        }
	}

	/* }====================================================== */

	public abstract class lauxlib
	{
		/* extra error code for 'luaL_loadfilex' */
		public const int ERRFILE          = lua.ERRERR + 1;

		/* key, in the registry, for table of loaded modules */
		public const String LOADED_TABLE  = "_LOADED";

		/* key, in the registry, for table of preloaded loaders */
		public const String PRELOAD_TABLE = "_PRELOAD";

		public const int NUMSIZES         = sizeof(lua_Integer) * 16 + sizeof(lua_Number);

		[Import(lua.LIB_DLL), LinkName("luaL_checkversion_")]
		public static extern void checkversion_(lua_State* L, lua_Number ver, size_t sz);
		[Inline]
		public static void checkversion(lua_State* L)
		{
			checkversion_(L, lua.VERSION_NUM, NUMSIZES);
		}

		[Import(lua.LIB_DLL), LinkName("luaL_getmetafield")]
		public static extern int getmetafield(lua_State* L, int obj, char8* e);
		[Import(lua.LIB_DLL), LinkName("luaL_callmeta")]
		public static extern int callmeta(lua_State* L, int obj, char8* e);
		[Import(lua.LIB_DLL), LinkName("luaL_tolstring")]
		public static extern char8* tolstring(lua_State* L, int idx, size_t *len);
		[Import(lua.LIB_DLL), LinkName("luaL_argerror")]
		public static extern int argerror(lua_State* L, int arg, char8* extramsg);
		[Import(lua.LIB_DLL), LinkName("luaL_checklstring")]
		public static extern char8* checklstring(lua_State* L, int arg, size_t *l);
		[Import(lua.LIB_DLL), LinkName("luaL_optlstring")]
		public static extern char8* optlstring(lua_State* L, int arg, char8* def, size_t *l);
		[Import(lua.LIB_DLL), LinkName("luaL_checknumber")]
		public static extern lua_Number checknumber(lua_State* L, int arg);
		[Import(lua.LIB_DLL), LinkName("luaL_optnumber")]
		public static extern lua_Number optnumber(lua_State* L, int arg, lua_Number def);

		[Import(lua.LIB_DLL), LinkName("luaL_checkinteger")]
		public static extern lua_Integer checkinteger(lua_State* L, int arg);
		[Import(lua.LIB_DLL), LinkName("luaL_optinteger")]
		public static extern lua_Integer optinteger(lua_State* L, int arg, lua_Integer def);

		[Import(lua.LIB_DLL), LinkName("luaL_checkstack")]
		public static extern void checkstack(lua_State* L, int sz, char8* msg);
		[Import(lua.LIB_DLL), LinkName("luaL_checktype")]
		public static extern void checktype(lua_State* L, int arg, int t);
		[Import(lua.LIB_DLL), LinkName("luaL_checkany")]
		public static extern void checkany(lua_State* L, int arg);

		[Import(lua.LIB_DLL), LinkName("luaL_newmetatable")]
		public static extern int newmetatable(lua_State* L, char8* tname);
		[Import(lua.LIB_DLL), LinkName("luaL_setmetatable")]
		public static extern void setmetatable(lua_State* L, char8* tname);
		[Import(lua.LIB_DLL), LinkName("luaL_testudata")]
		public static extern void* testudata(lua_State* L, int ud, char8* tname);
		[Import(lua.LIB_DLL), LinkName("luaL_checkudata")]
		public static extern void* checkudata(lua_State* L, int ud, char8* tname);

		[Import(lua.LIB_DLL), LinkName("luaL_where")]
		public static extern void where_(lua_State* L, int lvl); /* Suffixed with _ to prevent naming collision */
		[Import(lua.LIB_DLL), LinkName("luaL_error"), CVarArgs]
		public static extern int error(lua_State* L, char8* fmt, params Object[] args);

		[Import(lua.LIB_DLL), LinkName("luaL_checkoption")]
		public static extern int checkoption(lua_State* L, int arg, char8* def, char8[]* lst);

		[Import(lua.LIB_DLL), LinkName("luaL_fileresult")]
		public static extern int fileresult(lua_State* L, int stat, char8* fname); 
		[Import(lua.LIB_DLL), LinkName("luaL_execresult")]
		public static extern int execresult(lua_State* L, int stat);

		/* predefined references */
		public const int NOREF  = -2;
		public const int REFNIL = -1;

		[Import(lua.LIB_DLL), LinkName("luaL_ref")]
		public static extern int ref_(lua_State* L, int t); /* Suffixed with _ to prevent naming collision */
		[Import(lua.LIB_DLL), LinkName("luaL_unref")]
		public static extern void unref(lua_State* L, int t, int ref_);

		[Import(lua.LIB_DLL), LinkName("luaL_loadfilex")]
		public static extern int loadfilex(lua_State* L, char8* filename, char8* mode);

		[Inline]
		public static int loadfile(lua_State* L, String filename)
		{
			return loadfilex(L, filename.CStr(), null);
		}

		[Import(lua.LIB_DLL), LinkName("luaL_loadbufferx")]
		public static extern int loadbufferx(lua_State* L, char8* buff, size_t sz, char8* name, char8* mode);
		[Import(lua.LIB_DLL), LinkName("luaL_loadstring")]
		public static extern int loadstring(lua_State* L, char8* s);

		[Import(lua.LIB_DLL), LinkName("luaL_newstate")]
		public static extern lua_State* newstate();

		[Import(lua.LIB_DLL), LinkName("luaL_len")]
		public static extern lua_Integer len(lua_State* L, int idx);

		[Import(lua.LIB_DLL), LinkName("luaL_gsub")]
		public static extern char8* gsub(lua_State* L, char8* s, char8* p, char8* r);

		[Import(lua.LIB_DLL), LinkName("luaL_setfuncs")]
		public static extern void setfuncs(lua_State* L, luaL_Reg* l, int nup);

		[Import(lua.LIB_DLL), LinkName("luaL_getsubtable")]
		public static extern int getsubtable(lua_State* L, int idx, char8* fname);

		[Import(lua.LIB_DLL), LinkName("luaL_traceback")]
		public static extern void traceback(lua_State* L, lua_State* L1, char8* msg, int level);

		[Import(lua.LIB_DLL), LinkName("luaL_requiref")]
		public static extern void requiref(lua_State* L, char8* modname, lua_CFunction openf, bool glb);

		/*
		** ===============================================================
		** some useful macros
		** ===============================================================
		*/

		[Inline]
		public static void newlibtable(lua_State* L, luaL_Reg[] l)
		{
			lua.createtable(L, 0, (int)(l.Count / sizeof(luaL_Reg) - 1));
		}

		[Inline]
		public static void newlib(lua_State* L, luaL_Reg[] l)
		{
			checkversion(L);
			newlibtable(L, l);
			setfuncs(L, l.CArray(), 0);
		}

		[Inline]
		public static void argcheck(lua_State* L, bool cond, int idx, String extramsg)
		{
			if (!cond)
				argerror(L, idx, extramsg.CStr());
		}

		[Inline]
		public static void checkstring(lua_State* L, int idx, String buffer)
		{
			buffer.Append(checklstring(L, idx, null));
		}

		[Inline]
		public static void optstring(lua_State* L, int idx, String def, String buffer)
		{
			buffer.Append(optlstring(L, idx, def.CStr(), null));
		}

		[Inline]
		public static void typename(lua_State* L, int idx, String buffer)
		{
			buffer.Append(lua.typename(L, lua.type(L, idx)));
		}

		[Inline]
		public static int dofile(lua_State* L, String filename)
		{ 
			let res = loadfile(L, filename);

			if (res == lua.OK)
				return lua.pcall(L, 0, lua.MULTRET, 0);

			return res;
		}
 
		[Inline]
		public static int dostring(lua_State* L, String str)
		{
			let res = loadstring(L, str.CStr());

			if (res == lua.OK)
				return lua.pcall(L, 0, lua.MULTRET, 0);

			return res;
		}

		[Inline]
		public static int getmetatable(lua_State* L, String name)
 		{
			 return lua.getfield(L, lua.REGISTRYINDEX, name.CStr());
		}

		[Inline]
		public static int loadbuffer(lua_State* L, String buff, size_t sz, String name)
 		{
			 return loadbufferx(L, buff.CStr(), sz, name.CStr(), null);
		}

		/*
		** {======================================================
		** Generic Buffer manipulation
		** =======================================================
		*/

		// #define luaL_addchar(B,c) ((void)((B)->n < (B)->size || luaL_prepbuffsize((B), 1)), ((B)->b[(B)->n++] = (c)))
		[Inline]
		public static void addchar(luaL_Buffer* B, char8 val)
		{
			if (B.n < B.size)
				prepbuffsize(B, 1); 

			B.b[B.n++] = val;
		}

		[Inline]
		public static void addsize(luaL_Buffer* B, size_t sz)
		{
			B.n += sz;
		}

		[Import(lua.LIB_DLL), LinkName("luaL_buffinit")]
		public static extern void buffinit(lua_State* L, luaL_Buffer* B);
		[Import(lua.LIB_DLL), LinkName("luaL_prepbuffsize")]
		public static extern char8* prepbuffsize(luaL_Buffer* B, size_t sz);
		[Import(lua.LIB_DLL), LinkName("luaL_addlstring")]
		public static extern void addlstring(luaL_Buffer* B, char8* s, size_t l);
		[Import(lua.LIB_DLL), LinkName("luaL_addstring")]
		public static extern void addstring(luaL_Buffer* B, char8* s);
		[Import(lua.LIB_DLL), LinkName("luaL_addvalue")]
		public static extern void addvalue(luaL_Buffer* B);
		[Import(lua.LIB_DLL), LinkName("luaL_pushresult")]
		public static extern void pushresult(luaL_Buffer* B);
		[Import(lua.LIB_DLL), LinkName("luaL_pushresultsize")]
		public static extern void pushresultsize(luaL_Buffer* B, size_t sz);
		[Import(lua.LIB_DLL), LinkName("luaL_buffinitsize")]
		public static extern char8* buffinitsize(lua_State* L, luaL_Buffer* B, size_t sz);

		[Inline]
		public static char8* prepbuffer(luaL_Buffer* B)
		{
			return prepbuffsize(B, lua.BUFFERSIZE);
		}

		/* }====================================================== */

		/*
		** {======================================================
		** File handles for IO library
		** =======================================================
		*/

		/*
		** A file handle is a userdata with metatable 'LUA_FILEHANDLE' and
		** initial structure 'luaL_Stream' (it may contain other fields
		** after that initial structure).
		*/

		public const String FILEHANDLE = "FILE*";

		/* }====================================================== */

		/* compatibility with old module system */
		#if LUA_COMPAT_MODULE
			[Import(lua.LIB_DLL), LinkName("luaL_pushmodule")]
			public static extern void pushmodule(lua_State* L, char8* modname, int sizehint);
			[Import(lua.LIB_DLL), LinkName("luaL_openlib")]
			public static extern void openlib(lua_State* L, char8* libname, luaL_Reg* l, int nup);

			[Inline]
			public static void register(lua_State* L, char8* n, luaL_Reg* l)
			{
				openlib(L, n, l, 0);
			}
		#endif
		
		/* }================================================================== */
		
		/*
		** {==================================================================
		** "Abstraction Layer" for basic report of messages and errors
		** ===================================================================
		*/

		/* print a string */
		[Inline]
		public static void writestring(String val)
		{
			 Console.Out.Write(val).IgnoreError();
		}

		/* print a newline and flush the output */
		[Inline]
		public static void writeline()
		{
			 Console.Out.Write("\n").IgnoreError();
		}

		/* print an error message */
		[Inline]
		public static void writestringerror(String fmt, params Object[] args)
		{
			 Console.Error.WriteLine(fmt, params args).IgnoreError();
		}

		/* }================================================================== */

		/*
		** {============================================================
		** Compatibility with deprecated conversions
		** =============================================================
		*/

		#if LUA_COMPAT_APIINTCASTS
			[Inline]
			public static lua_Unsigned checkunsigned(lua_State* L, int idx)
			{
				return (lua_Unsigned)checkinteger(L, idx);
			}
			[Inline]
			public static lua_Unsigned optunsigned(lua_State* L, int idx, lua_Unsigned def)
			{
				return (lua_Unsigned)optinteger(L, idx, (lua_Integer)def);
			}

			[Inline]
			public static int checkint(lua_State* L, int idx)
			{
				return (int)checkinteger(L, idx);
			}
			[Inline]
			public static int optint(lua_State* L, int idx, int def)
			{
				return (int)optinteger(L, idx, def);
			}

			[Inline]
			public static int64 checklong(lua_State* L, int idx)
			{
				return (int64)checkinteger(L, idx);
			}
			[Inline]
			public static int64 optlong(lua_State* L, int idx, int64 def)
			{
				return (int64)optinteger(L, idx, def);
			}
		#endif

		/* }============================================================ */
	}
}
