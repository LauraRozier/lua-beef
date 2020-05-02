/*
** $Id: lua.bf
** Lua - A Scripting Language
** Lua.org, PUC-Rio, Brazil (http://www.lua.org)
** See Copyright Notice at the end of this file
*/
using System;

namespace lua535_beef
{
	/*
	** ===================================================================
	** Search for "@@" to find all configurable definitions.
	** ===================================================================
	*/

	/*
	** {====================================================================
	** System Configuration: macros to adapt (if needed) Lua to some
	** particular platform, for instance compiling it with 32-bit numbers or
	** restricting it to C89.
	** =====================================================================
	*/

	/*
	@@ LUA_32BITS enables Lua with 32-bit integers and 32-bit floats. You
	** can also define LUA_32BITS in the make file, but changing here you
	** ensure that all software connected to Lua will be compiled with the
	** same configuration.
	*/
	/* #define LUA_32BITS */

	/*
	@@ LUA_USE_C89 controls the use of non-ISO-C89 features.
	** Define it if you want Lua to avoid the use of a few C99 features
	** or Windows-specific features on Windows.
	*/
	/* #define LUA_USE_C89 */

	/*
	** By default, Lua on Windows use (some) specific Windows features
	*/
	#if !LUA_USE_C89 && BF_PLATFORM_WINDOWS && !BF_PLATFORM_WINDOWSCE
		/* enable goodies for regular Windows */
		#define LUA_USE_WINDOWS
	#endif

	#if !LUA_USE_C89 && BF_PLATFORM_LINUX
		/* enable goodies for Linux */
		#define LUA_USE_LINUX
	#endif

	#if !LUA_USE_C89 && BF_PLATFORM_MACOS
		/* enable goodies for regular Windows */
		#define LUA_USE_MACOSX
	#endif

	#if LUA_USE_WINDOWS
		/* enable support for DLL */
		#define LUA_DL_DLL
		/* broadly, Windows is C89 */
		#define LUA_USE_C89
	#endif

	#if LUA_USE_LINUX
		#define LUA_USE_POSIX
		/* needs an extra library: -ldl */
		#define LUA_USE_DLOPEN
		/* needs some extra libraries */
		#define LUA_USE_READLINE
	#endif

	#if LUA_USE_MACOSX
		#define LUA_USE_POSIX
		/* MacOS does not need -ldl */
		#define LUA_USE_DLOPEN
		/* needs an extra library: -lreadline */
		#define LUA_USE_READLINE
	#endif

	/*
	@@ LUA_C89_NUMBERS ensures that Lua uses the largest types available for
	** C89 ('long' and 'double'); Windows always has '__int64', so it does
	** not need to use this case.
	*/
	#if LUA_USE_C89 && !LUA_USE_WINDOWS
		#define LUA_C89_NUMBERS
	#endif

	/*
	** {==================================================================
	** Compatibility with previous versions
	** ===================================================================
	*/

	/*
	@@ LUA_COMPAT_5_2 controls other macros for compatibility with Lua 5.2.
	@@ LUA_COMPAT_5_1 controls other macros for compatibility with Lua 5.1.
	** You can define it to get all options, or change specific options
	** to fit your specific needs.
	*/
	#if LUA_COMPAT_5_2
		/*
		@@ LUA_COMPAT_MATHLIB controls the presence of several deprecated
		** functions in the mathematical library.
		*/
		#define LUA_COMPAT_MATHLIB

		/*
		@@ LUA_COMPAT_BITLIB controls the presence of library 'bit32'.
		*/
		#define LUA_COMPAT_BITLIB

		/*
		@@ LUA_COMPAT_IPAIRS controls the effectiveness of the __ipairs metamethod.
		*/
		#define LUA_COMPAT_IPAIRS

		/*
		@@ LUA_COMPAT_APIINTCASTS controls the presence of macros for
		** manipulating other integer types (lua_pushunsigned, lua_tounsigned,
		** luaL_checkint, luaL_checklong, etc.)
		*/
		#define LUA_COMPAT_APIINTCASTS
	#endif

	#if LUA_COMPAT_5_1
		/* Incompatibilities from 5.2 -> 5.3 */
		#define LUA_COMPAT_MATHLIB
		#define LUA_COMPAT_APIINTCASTS

		/*
		@@ LUA_COMPAT_UNPACK controls the presence of global 'unpack'.
		** You can replace it with 'table.unpack'.
		*/
		#define LUA_COMPAT_UNPACK

		/*
		@@ LUA_COMPAT_LOADERS controls the presence of table 'package.loaders'.
		** You can replace it with 'package.searchers'.
		*/
		#define LUA_COMPAT_LOADERS

		/*
		@@ LUA_COMPAT_LOG10 defines the function 'log10' in the math library.
		** You can rewrite 'log10(x)' as 'log(x, 10)'.
		*/
		#define LUA_COMPAT_LOG10

		/*
		@@ LUA_COMPAT_LOADSTRING defines the function 'loadstring' in the base
		** library. You can rewrite 'loadstring(s)' as 'load(s)'.
		*/
		#define LUA_COMPAT_LOADSTRING

		/*
		@@ LUA_COMPAT_MAXN defines the function 'maxn' in the table library.
		*/
		#define LUA_COMPAT_MAXN

		/*
		@@ LUA_COMPAT_MODULE controls compatibility with previous
		** module functions 'module' (Lua) and 'luaL_register' (C).
		*/
		#define LUA_COMPAT_MODULE
	#endif

	/*
	@@ LUA_COMPAT_FLOATSTRING makes Lua format integral floats without a
	@@ a float mark ('.0').
	** This macro is not on by default even in compatibility mode,
	** because this is not really an incompatibility.
	*/
	/* #define LUA_COMPAT_FLOATSTRING */

	/* }================================================================== */

	/*
	** {==================================================================
	** Language Variations
	** =====================================================================
	*/

	/*
	@@ LUA_NOCVTN2S/LUA_NOCVTS2N control how Lua performs some
	** coercions. Define LUA_NOCVTN2S to turn off automatic coercion from
	** numbers to strings. Define LUA_NOCVTS2N to turn off automatic
	** coercion from strings to numbers.
	*/
	/* #define LUA_NOCVTN2S */
	/* #define LUA_NOCVTS2N */

	/* }================================================================== */
	
	public typealias ptrdiff_t    = void*;
	public typealias intptr_t     = int32*;
	public typealias size_t       = uint32;
	public typealias va_list      = void*;

	public typealias lu_byte      = uint8;
	public typealias lua_Number   = double;
	public typealias lua_Integer  = int64;
	public typealias lua_Unsigned = uint64;
	public typealias lua_KContext = intptr_t;
	public typealias Instruction  = uint32;

	/*
	** Functions to be called by the debugger in specific events
	*/
	[CRepr]
	public typealias lua_Hook = function void(lua_State* L, int32 status, lua_KContext ctx);

	/*
	** Type for C functions registered with Lua
	*/
	[CRepr]
	public typealias lua_CFunction = function int32(lua_State* L);

	/*
	** Type for continuation functions
	*/ 
	[CRepr]
	public typealias lua_KFunction = function int32(lua_State* L);

	/*
	** Type for functions that read/write blocks when loading/dumping Lua chunks
	*/
	[CRepr]
	public typealias lua_Reader = function char8*(lua_State* L, void* ud, size_t* sz);

	[CRepr]
	public typealias lua_Writer = function int(lua_State* L, void* p, size_t sz, void* ud);

	/*
	** Type for memory-allocation functions
	*/
	[CRepr]
	public typealias lua_Alloc = function void*(void* ud, void* ptr, size_t osize, size_t nsize);

	[CRepr]
	public struct GCObject
	{
	  public GCObject* next;
	  public lu_byte tt;
	  public lu_byte marked;
	}

	[CRepr, Union]
	public struct Value
	{
	  public GCObject* gc;    /* collectable objects */
	  public void* p;         /* light userdata */
	  public int32 b;         /* booleans */
	  public lua_CFunction f; /* light C functions */
	  public lua_Integer i;   /* integer numbers */
	  public lua_Number n;    /* float numbers */
	}

	[CRepr]
	public struct lua_TValue
	{
	  	public Value value_;
		public int32 tt_;
	}

	public typealias TValue = lua_TValue;
	public typealias StkId  = TValue*; /* index to stack elements */

	[CRepr]
	public struct lua_Debug
	{
	  public int32 event;
	  public char8* name;                 /* (n) */
	  public char8* namewhat;             /* (n) 'global', 'local', 'field', 'method' */
	  public char8* what;                 /* (S) 'Lua', 'C', 'main', 'tail' */
	  public char8* source;               /* (S) */
	  public int32 currentline;           /* (l) */
	  public int32 linedefined;           /* (S) */
	  public int32 lastlinedefined;       /* (S) */
	  public uint8 nups;                  /* (u) number of upvalues */
	  public uint8 nparams;               /* (u) number of parameters */
	  public char8 isvararg;              /* (u) */
	  public char8 istailcall;            /* (t) */
	  public char8[lua.IDSIZE] short_src; /* (S) */
	  /* private part */
	  public void* i_ci;                  /* active function */
	}

	[CRepr]
	public struct lua_State
	{
		public GCObject* next;
		public lu_byte tt;
		public lu_byte marked;
		public uint16 nci;          /* number of items in 'ci' list */
		public lu_byte status;
		public StkId top;           /* first free slot in the stack */
		public void* l_G;
		public void* ci;            /* call info for current function */
		public Instruction* oldpc;  /* last pc traced */
		public StkId stack_last;    /* last free slot in the stack */
		public StkId _stack;        /* stack base */
		public void* openupval;     /* list of open upvalues in this stack */
		public GCObject* gclist;
		public lua_State* twups;    /* list of threads with open upvalues */
		public void* errorJmp;      /* current error recover point */
		public void* base_ci;       /* CallInfo for first level (C calling Lua) */
		public lua_Hook hook;
		public ptrdiff_t errfunc;   /* current error handling function (stack index) */
		public int32 stacksize;
		public int32 basehookcount;
		public int32 hookcount;
		public uint16 nny;          /* number of non-yieldable calls in stack */
		public uint16 nCcalls;      /* number of nested C calls */
		public int32 hookmask;
		public lu_byte allowhook;
	}

	/* =================================================================== */

	/*
	** Local configuration. You can use this space to add your redefinitions
	** without modifying the main part of the file.
	*/

	public static class lua
	{
		/*
		** {==================================================================
		** Configuration for Paths.
		** ===================================================================
		*/

		/*
		** LUA_PATH_SEP is the character that separates templates in a path.
		** LUA_PATH_MARK is the string that marks the substitution points in a
		** template.
		** LUA_EXEC_DIR in a Windows path is replaced by the executable's
		** directory.
		*/
		public const String PATH_SEP  = ";";
		public const String PATH_MARK = "?";
		public const String EXEC_DIR  = "!";

		/*
		@@ LUA_PATH_DEFAULT is the default path that Lua uses to look for
		** Lua libraries.
		@@ LUA_CPATH_DEFAULT is the default path that Lua uses to look for
		** C libraries.
		** CHANGE them if your machine has a non-conventional directory
		** hierarchy or if you want to install your libraries in
		** non-conventional directories.
		*/
		public const String VDIR = VERSION_MAJOR + "." + VERSION_MINOR;
		#if BF_PLATFORM_WINDOWS
			/*
			** In Windows, any exclamation mark ('!') in the path is replaced by the
			** path of the directory of the executable file of the current process.
			*/
			public const String LDIR          = "!\\lua\\";
			public const String CDIR          = "!\\";
			public const String SHRDIR        = "!\\..\\share\\lua\\" + VDIR + "\\";
			public const String PATH_DEFAULT  = LDIR + "?.lua;" + LDIR + "?\\init.lua;" + CDIR + "?.lua;" + CDIR + "?\\init.lua;" + SHRDIR + "?.lua;" + SHRDIR +
												"?\\init.lua;.\\?.lua;.\\?\\init.lua";
			public const String CPATH_DEFAULT = CDIR + "?.dll;" + CDIR + "..\\lib\\lua\\" + VDIR + "\\?.dll;" + CDIR + "loadall.dll;.\\?.dll";
		#else
			public const String ROOT          = "/usr/local/";
			public const String LDIR          = ROOT + "share/lua/" + VDIR + "/";
			public const String CDIR          = ROOT + "lib/lua/" + VDIR + "/";
			public const String PATH_DEFAULT  = LDIR + "?.lua;" + LDIR + "?/init.lua;" + CDIR + "?.lua;" + CDIR + "?/init.lua;./?.lua;./?/init.lua";
			public const String CPATH_DEFAULT = CDIR + "?.so;" + CDIR + "loadall.so;./?.so";
		#endif

		/*
		@@ LUA_DIRSEP is the directory separator (for submodules).
		** CHANGE it if your machine does not use "/" as the directory separator
		** and is not Windows. (On Windows Lua automatically uses "\".)
		*/
		#if BF_PLATFORM_WINDOWS
			public const String DIRSEP = "\\";
		#else
			public const String DIRSEP = "/";
		#endif

		/* }================================================================== */

		/*
		** {==================================================================
		** Compatibility with previous versions
		** ===================================================================
		*/

		#if LUA_COMPAT_5_1
			/*
			@@ macro 'lua_cpcall' emulates deprecated function lua_cpcall.
			** You can call your C function directly (with light C functions).
			*/
			[Inline]
			public static void cpcall(lua_State* L, lua_CFunction f, void* u) {
				pushcfunction(L, f);
				pushlightuserdata(L, u);
				pcall(L, 1, 0, 0);
			}

			/*
			@@ The following macros supply trivial compatibility for some
			** changes in the API. The macros themselves document how to
			** change your code to avoid using them.
			*/
			[Inline]
			public static size_t strlen(lua_State* L, int32 i) {
				return rawlen(L, i);
			}

			[Inline]
			public static size_t objlen(lua_State* L, int32 i) {
				return rawlen(L, i);
			}

			[Inline]
			public static int32 equal(lua_State* L, int32 idx1, int32 idx2) {
				return compare(L, idx1, idx2, LUA_OPEQ);
			}

			[Inline]
			public static int32 lessthan(lua_State* L, int32 idx1, int32 idx2) {
				return compare(L, idx1, idx2, LUA_OPLT);
			}
		#endif

		/* }================================================================== */

		/*
		** {==================================================================
		** Macros that affect the API and must be stable (that is, must be the
		** same when you compile Lua and when you compile code that links to
		** Lua). You probably do not want/need to change them.
		** =====================================================================
		*/

		/*
		@@ LUAI_MAXSTACK limits the size of the Lua stack.
		** CHANGE it if you need a different limit. This limit is arbitrary;
		** its only purpose is to stop Lua from consuming unlimited stack
		** space (and to reserve some numbers for pseudo-indices).
		*/
		public const int32 MAXSTACK = 1000000;

		/*
		@@ LUA_EXTRASPACE defines the size of a raw memory area associated with
		** a Lua state with very fast access.
		** CHANGE it if you need a different size.
		*/
		public const int32 EXTRASPACE = sizeof(void*);

		/*
		@@ LUA_IDSIZE gives the maximum size for the description of the source
		@@ of a function in debug information.
		** CHANGE it if you want a different size.
		*/
		public const int32 IDSIZE = 60;

		/*
		@@ LUAL_BUFFERSIZE is the buffer size used by the lauxlib buffer system.
		** CHANGE it if it uses too much C-stack space. (For long double,
		** 'string.format("%.99f", -1e4932)' needs 5034 bytes, so a
		** smaller buffer would force a memory allocation for each call to
		** 'string.format'.)
		*/
		public const int32 BUFFERSIZE = (int)(0x80 * sizeof(void*) * sizeof(lua_Integer));

		/* =================================================================== */

		/*#if BF_PLATFORM_WINDOWS
			public const String LUA_LIB = "lua53.dll";
		#else
			public const String LUA_LIB = "liblua53.so";
		#endif*/

		public const String VERSION_MAJOR   = "5";
		public const String VERSION_MINOR   = "3";
		public const uint32 VERSION_NUM     = 503;
		public const String VERSION_RELEASE = "5";

		public const String VERSION         = "Lua " + VERSION_MAJOR + "." + VERSION_MINOR;
		public const String RELEASE         = VERSION + "." + VERSION_RELEASE;
		public const String COPYRIGHT       = RELEASE + "  Copyright (C) 1994-2018 Lua.org, PUC-Rio";
		public const String AUTHORS         = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes";

		/* mark for precompiled code (`<esc>Lua') */
		public const String SIGNATURE = "\x1bLua";

		/* option for multiple returns in `lua_pcall' and `lua_call' */
		public const int32 MULTRET    = -1;

		/*
		** Pseudo-indices
		** (-LUAI_MAXSTACK is the minimum valid index; we keep some free empty
		** space after that to help overflow detection)
		*/
		public const int32 REGISTRYINDEX      = (-MAXSTACK) - 1000;
		[Inline]
		public static int32 upvalueindex(int32 i)
		{
			return REGISTRYINDEX - i;
		}

		/* thread status */
		public const int32 OK        = 0;
		public const int32 YIELD     = 1;
		public const int32 ERRRUN    = 2;
		public const int32 ERRSYNTAX = 3;
		public const int32 ERRMEM    = 4;
		public const int32 ERRGCMM   = 5;
		public const int32 ERRERR    = 6;

		/*
		** basic types
		*/
		public const int32 TNONE          = -1;

		public const int32 TNIL           = 0;
		public const int32 TBOOLEAN       = 1;
		public const int32 TLIGHTUSERDATA = 2;
		public const int32 TNUMBER        = 3;
		public const int32 TSTRING        = 4;
		public const int32 TTABLE         = 5;
		public const int32 TFUNCTION      = 6;
		public const int32 TUSERDATA      = 7;
		public const int32 TTHREAD        = 8;

		public const int32 NUMTAGS        = 9;

		/* minimum Lua stack available to a C function */
		public const int32 MINSTACK = 20;

		/* predefined values in the registry */
		public const int32 RIDX_MAINTHREAD = 1;
		public const int32 RIDX_GLOBALS    = 2;
		public const int32 RIDX_LAST       = RIDX_GLOBALS;

		[LinkName("lua_ident"), CLink]
		public extern static char8[] ident;

		/*
		** state manipulation
		*/
		[LinkName("lua_newstate"), CLink]
		public extern static lua_State* newstate(lua_Alloc f, void* ud);
		[LinkName("lua_close"), CLink]
		public extern static void close(lua_State* L);
		[LinkName("lua_newthread"), CLink]
		public extern static lua_State* newthread(lua_State* L);

		[LinkName("lua_atpanic"), CLink]
		public extern static lua_CFunction atpanic(lua_State* L, lua_CFunction panicf);

		[LinkName("lua_version"), CLink]
		public extern static lua_Number* version(lua_State* L);

		/*
		** basic stack manipulation
		*/
		[LinkName("lua_absindex"), CLink]
		public extern static int32 absindex(lua_State* L, int32 idx);
		[LinkName("lua_gettop"), CLink]
		public extern static int32 gettop(lua_State* L);
		[LinkName("lua_settop"), CLink]
		public extern static void settop(lua_State* L, int32 idx);
		[LinkName("lua_pushvalue"), CLink]
		public extern static void pushvalue(lua_State* L, int32 idx);
		[LinkName("lua_rotate"), CLink]
		public extern static void rotate(lua_State* L, int32 idx, int32 n);
		[LinkName("lua_copy"), CLink]
		public extern static void copy(lua_State* L, int32 fromidx, int32 toidx);
		[LinkName("lua_checkstack"), CLink]
		public extern static int32 checkstack(lua_State* L, int32 n);

		[LinkName("lua_xmove"), CLink]
		public extern static void xmove(lua_State* from, lua_State* to, int32 n);

		/*
		** access functions (stack -> C)
		*/
		[LinkName("lua_isnumber"), CLink]
		public extern static int32 isnumber(lua_State* L, int32 idx);
		[LinkName("lua_isstring"), CLink]
		public extern static int32 isstring(lua_State* L, int32 idx);
		[LinkName("lua_iscfunction"), CLink]
		public extern static int32 iscfunction(lua_State* L, int32 idx);
		[LinkName("lua_isinteger"), CLink]
		public extern static int32 isinteger(lua_State* L, int32 idx);
		[LinkName("lua_isuserdata"), CLink]
		public extern static int32 isuserdata(lua_State* L, int32 idx);
		[LinkName("lua_type"), CLink]
		public extern static int32 type(lua_State* L, int32 idx);
		[LinkName("lua_typename"), CLink]
		public extern static char8* typename(lua_State* L, int32 tp);

		[LinkName("lua_tonumberx"), CLink]
		public extern static lua_Number tonumberx(lua_State* L, int32 idx, bool* isnum);
		[LinkName("lua_tointegerx"), CLink]
		public extern static lua_Integer tointegerx(lua_State* L, int32 idx, bool* isnum);
		[LinkName("lua_tolstring"), CLink]
		public extern static int32 toboolean(lua_State* L, int32 idx);
		[LinkName("lua_tolstring"), CLink]
		public extern static char8* tolstring(lua_State* L, int32 idx, size_t* len);
		[LinkName("lua_rawlen"), CLink]
		public extern static size_t rawlen(lua_State* L, int32 idx);
		[LinkName("lua_tocfunction"), CLink]
		public extern static lua_CFunction tocfunction(lua_State* L, int32 idx);
		[LinkName("lua_touserdata"), CLink]
		public extern static void* touserdata(lua_State* L, int32 idx);
		[LinkName("lua_tothread"), CLink]
		public extern static lua_State* tothread(lua_State* L, int32 idx);
		[LinkName("lua_topointer"), CLink]
		public extern static void* topointer(lua_State* L, int32 idx);

		/*
		** Comparison and arithmetic functions
		*/
		public const int32 OPADD  = 0; /* ORDER TM, ORDER OP */
		public const int32 OPSUB  = 1;
		public const int32 OPMUL  = 2;
		public const int32 OPMOD  = 3;
		public const int32 OPPOW  = 4;
		public const int32 OPDIV  = 5;
		public const int32 OPIDIV = 6;
		public const int32 OPBAND = 7;
		public const int32 OPBOR  = 8;
		public const int32 OPBXOR = 9;
		public const int32 OPSHL  = 10;
		public const int32 OPSHR  = 11;
		public const int32 OPUNM  = 12;
		public const int32 OPBNOT = 13;

		[LinkName("lua_arith"), CLink]
		public extern static void arith(lua_State* L, int32 op);

		public const int32 OPEQ = 0;
		public const int32 OPLT = 1;
		public const int32 OPLE = 2;

		[LinkName("lua_rawequal"), CLink]
		public extern static int32 rawequal(lua_State* L, int32 idx1, int32 idx2);
		[LinkName("lua_compare"), CLink]
		public extern static int32 compare(lua_State* L, int32 idx1, int32 idx2, int32 op);

		/*
		** push functions (C -> stack)
		*/
		[LinkName("lua_pushnil"), CLink]
		public extern static void pushnil(lua_State* L);
		[LinkName("lua_pushnumber"), CLink]
		public extern static void pushnumber(lua_State* L, lua_Number n);
		[LinkName("lua_pushinteger"), CLink]
		public extern static void pushinteger(lua_State* L, lua_Integer n);
		[LinkName("lua_pushlstring"), CLink]
		public extern static char8* pushlstring(lua_State* L, char8* s, size_t len);
		[LinkName("lua_pushstring"), CLink]
		public extern static char8* pushstring(lua_State* L, char8* s);
		[LinkName("lua_pushvfstring"), CLink]
		public extern static char8* pushvfstring(lua_State* L, char8* fmt, va_list argp);
		[LinkName("lua_pushfstring"), CLink, CVarArgs]
		public extern static char8* pushfstring(lua_State* L, char8* fmt, params Object[] args);
		[LinkName("lua_pushcclosure"), CLink]
		public extern static void pushcclosure(lua_State* L, lua_CFunction fn, int32 n);
		[LinkName("lua_pushboolean"), CLink]
		public extern static void pushboolean(lua_State* L, bool b);
		[LinkName("lua_pushlightuserdata"), CLink]
		public extern static void pushlightuserdata(lua_State* L, void* p);
		[LinkName("lua_pushthread"), CLink]
		public extern static int32 pushthread(lua_State* L);

		/*
		** get functions (Lua -> stack)
		*/
		[LinkName("lua_getglobal"), CLink]
		public extern static int32 getglobal(lua_State* L, char8* name);
		[LinkName("lua_gettable"), CLink]
		public extern static int32 gettable(lua_State* L, int32 idx);
		[LinkName("lua_getfield"), CLink]
		public extern static int32 getfield(lua_State* L, int32 idx, char8* k);
		[LinkName("lua_geti"), CLink]
		public extern static int32 geti(lua_State* L, int32 idx, lua_Integer n);
		[LinkName("lua_rawget"), CLink]
		public extern static int32 rawget(lua_State* L, int32 idx);
		[LinkName("lua_rawgeti"), CLink]
		public extern static int32 rawgeti(lua_State* L, int32 idx, lua_Integer n);
		[LinkName("lua_rawgetp"), CLink]
		public extern static int32 rawgetp(lua_State* L, int32 idx, void* p);

		[LinkName("lua_createtable"), CLink]
		public extern static void createtable(lua_State* L, int32 narr, int32 nrec);
		[LinkName("lua_newuserdata"), CLink]
		public extern static void* newuserdata(lua_State* L, size_t sz);
		[LinkName("lua_getmetatable"), CLink]
		public extern static int32 getmetatable(lua_State* L, int32 objindex);
		[LinkName("lua_getuservalue"), CLink]
		public extern static int32 getuservalue(lua_State* L, int32 idx);

		/*
		** set functions (stack -> Lua)
		*/
		[LinkName("lua_setglobal"), CLink]
		public extern static void setglobal(lua_State* L, char8* name);
		[LinkName("lua_settable"), CLink]
		public extern static void settable(lua_State* L, int32 idx);
		[LinkName("lua_setfield"), CLink]
		public extern static void setfield(lua_State* L, int32 idx, char8* k);
		[LinkName("lua_seti"), CLink]
		public extern static void seti(lua_State* L, int32 idx, lua_Integer n);
		[LinkName("lua_rawset"), CLink]
		public extern static void rawset(lua_State* L, int32 idx);
		[LinkName("lua_rawseti"), CLink]
		public extern static void rawseti(lua_State* L, int32 idx, lua_Integer n);
		[LinkName("lua_rawsetp"), CLink]
		public extern static void rawsetp(lua_State* L, int32 idx, void* p);
		[LinkName("lua_setmetatable"), CLink]
		public extern static int32 setmetatable(lua_State* L, int32 objindex);
		[LinkName("lua_setuservalue"), CLink]
		public extern static void setuservalue(lua_State* L, int32 idx);

		/*
		** 'load' and 'call' functions (load and run Lua code)
		*/
		[LinkName("lua_callk"), CLink]
		public extern static void callk(lua_State* L, int32 nargs, int32 nresults, lua_KContext ctx, lua_KFunction k);
		[Inline]
		public static void call(lua_State* L, int32 n, int32 r)
		{
			callk(L, n, r, null, null);
		}

		[LinkName("lua_pcallk"), CLink]
		public extern static int32 pcallk(lua_State* L, int32 nargs, int32 nresults, int32 errfunc, lua_KContext ctx, lua_KFunction k);
		[Inline]
		public static int32 pcall(lua_State* L, int32 n, int32 r, int32 f)
		{
			return pcallk(L, n, r, f, null, null);
		}

		[LinkName("lua_load"), CLink]
		public extern static int32 load(lua_State* L, lua_Reader reader, void* dt, char8* chunkname, char8* mode);

		[LinkName("lua_dump"), CLink]
		public extern static int32 dump(lua_State* L, lua_Writer writer, void* data, int32 strip);

		/*
		** coroutine functions
		*/
		[LinkName("lua_yieldk"), CLink]
		public extern static int32 yieldk(lua_State* L, int32 nresults, lua_KContext ctx, lua_KFunction k);
		[LinkName("lua_resume"), CLink]
		public extern static int32 resume(lua_State* L, lua_State* from, int32 narg);
		[LinkName("lua_status"), CLink]
		public extern static int32 status(lua_State* L);
		[LinkName("lua_isyieldable"), CLink]
		public extern static int32 isyieldable(lua_State* L);

		[Inline]
		public static int32 yield_(lua_State* L, int32 n) /* Suffixed with _ to prevent naming collision */
		{
			return yieldk(L, n, null, null);
		}

		/*
		** garbage-collection function and options
		*/
		public const int32 GCSTOP       = 0;
		public const int32 GCRESTART    = 1;
		public const int32 GCCOLLECT    = 2;
		public const int32 GCCOUNT      = 3;
		public const int32 GCCOUNTB     = 4;
		public const int32 GCSTEP       = 5;
		public const int32 GCSETPAUSE   = 6;
		public const int32 GCSETSTEPMUL = 7;
		public const int32 GCISRUNNING  = 9;

		[LinkName("lua_gc"), CLink]
		public extern static int32 gc(lua_State* L, int32 what, int32 data);

		/*
		** miscellaneous functions
		*/
		[LinkName("lua_error"), CLink]
		public extern static int32 error(lua_State* L);

		[LinkName("lua_next"), CLink]
		public extern static int32 next(lua_State* L, int32 idx);

		[LinkName("lua_concat"), CLink]
		public extern static void concat(lua_State* L, int32 n);
		[LinkName("lua_len"), CLink]
		public extern static void len(lua_State* L, int32 idx);

		[LinkName("lua_stringtonumber"), CLink]
		public extern static size_t stringtonumber(lua_State* L, char8* s);

		[LinkName("lua_getallocf"), CLink]
		public extern static lua_Alloc getallocf(lua_State* L, void** ud);
		[LinkName("lua_setallocf"), CLink]
		public extern static void setallocf(lua_State* L, lua_Alloc f, void* ud);

		/*
		** {==============================================================
		** some useful macros
		** ===============================================================
		*/
		[Inline]
		public static void* getextraspace(lua_State* L)
		{
			return (void*)((char8*)(L) - EXTRASPACE);
		}

		[Inline]
		public static lua_Number tonumber(lua_State* L, int32 i)
		{
			return tonumberx(L, i, null);
		}
		[Inline]
		public static lua_Integer tointeger(lua_State* L, int32 i)
		{
			return tointegerx(L, i, null);
		}

		[Inline]
		public static void pop(lua_State* L, int32 n)
		{
			settop(L, -(n - 1));
		}

		[Inline]
		public static void newtable(lua_State* L)
		{
			createtable(L, 0, 0);
		}

		[Inline]
		public static void register(lua_State* L, String n, lua_CFunction f)
		{
			pushcfunction(L, f);
			setglobal(L, n.CStr());
		}

		[Inline]
		public static void pushcfunction(lua_State* L, lua_CFunction f)
		{
			pushcclosure(L, f, 0);
		}

		[Inline]
		public static bool isfunction(lua_State* L, int32 n)
		{
			return type(L, n) == TFUNCTION;
		}
		[Inline]
		public static bool istable(lua_State* L, int32 n)
		{
			return type(L, n) == TTABLE;
		}
		[Inline]
		public static bool islightuserdata(lua_State* L, int32 n)
		{
			return type(L, n) == TLIGHTUSERDATA;
		}
		[Inline]
		public static bool isnil(lua_State* L, int32 n)
		{
			return type(L, n) == TNIL;
		}
		[Inline]
		public static bool isboolean(lua_State* L, int32 n)
		{
			return type(L, n) == TBOOLEAN;
		}
		[Inline]
		public static bool isthread(lua_State* L, int32 n)
		{
			return type(L, n) == TTHREAD;
		}
		[Inline]
		public static bool isnone(lua_State* L, int32 n)
		{
			return type(L, n) == TNONE;
		}
		[Inline]
		public static bool isnoneornil(lua_State* L, int32 n)
		{
			return type(L, n) <= 0;
		}

		[Inline]
		public static void pushliteral(lua_State* L, String s)
		{
			pushstring(L, s.CStr());
		}

		[Inline]
		public static void pushglobaltable(lua_State* L)
		{
			rawgeti(L, REGISTRYINDEX, RIDX_GLOBALS);
		}

		[Inline]
		public static String tostring(lua_State* L, int32 i)
		{
			var result = "";
			tolstring(L, i, null).ToString(result);
			return result;
		}

		[Inline]
		public static void insert(lua_State* L, int32 idx)
		{
			rotate(L, idx, 1);
		}

		[Inline]
		public static void remove(lua_State* L, int32 idx)
		{
			rotate(L, idx, -1);
			pop(L, 1);
		}

		[Inline]
		public static void replace(lua_State* L, int32 idx)
		{
			copy(L, -1, idx);
			pop(L, 1);
		}

		/* }============================================================== */

		/*
		** {==============================================================
		** compatibility macros for unsigned conversions
		** ===============================================================
		*/
		#if LUA_COMPAT_APIINTCASTS
			[Inline]
			public static void pushunsigned(lua_State* L, lua_Integer n)
			{
				pushinteger(L, (lua_Integer)n);
			}
			[Inline]
			public static lua_Unsigned tounsignedx(lua_State* L, int32 i, bool* isnum)
			{
				return (lua_Unsigned)tointegerx(L, i, isnum);
			}
			[Inline]
			public static lua_Unsigned tounsigned(lua_State* L, int32 i)
			{
				return tounsignedx(L, i, null);
			}
		#endif
		/* }============================================================== */

		/*
		** {======================================================================
		** Debug API
		** =======================================================================
		*/

		/*
		** Event codes
		*/
		public const int32 HOOKCALL     = 0;
		public const int32 HOOKRET      = 1;
		public const int32 HOOKLINE     = 2;
		public const int32 HOOKCOUNT    = 3;
		public const int32 HOOKTAILCALL = 4;

		/*
		** Event masks
		*/
		public const int32 MASKCALL  = 1 << HOOKCALL;
		public const int32 MASKRET   = 1 << HOOKRET;
		public const int32 MASKLINE  = 1 << HOOKLINE;
		public const int32 MASKCOUNT = 1 << HOOKCOUNT;

		[LinkName("lua_getstack"), CLink]
		public extern static int32 getstack(lua_State* L, int32 level, lua_Debug* ar);
		[LinkName("lua_getinfo"), CLink]
		public extern static int32 getinfo(lua_State* L, char8* what, lua_Debug* ar);
		[LinkName("lua_getlocal"), CLink]
		public extern static char8* getlocal(lua_State* L, lua_Debug* ar, int32 n);
		[LinkName("lua_setlocal"), CLink]
		public extern static char8* setlocal(lua_State* L, lua_Debug* ar, int32 n);
		[LinkName("lua_getupvalue"), CLink]
		public extern static char8* getupvalue(lua_State* L, int32 funcindex, int32 n);
		[LinkName("lua_setupvalue"), CLink]
		public extern static char8* setupvalue(lua_State* L, int32 funcindex, int32 n);

		[LinkName("lua_upvalueid"), CLink]
		public extern static void* upvalueid(lua_State* L, int32 fidx, int32 n);
		[LinkName("lua_upvaluejoin"), CLink]
		public extern static void upvaluejoin(lua_State* L, int32 fidx1, int32 n1, int32 fidx2, int32 n2);

		[LinkName("lua_sethook"), CLink]
		public extern static void sethook(lua_State* L, lua_Hook func, int32 mask, int32 count);
		[LinkName("lua_gethook"), CLink]
		public extern static lua_Hook gethook(lua_State* L);
		[LinkName("lua_gethookmask"), CLink]
		public extern static int32 gethookmask(lua_State* L);
		[LinkName("lua_gethookcount"), CLink]
		public extern static int32 gethookcount(lua_State* L);

		/* }====================================================================== */
	}
}

/* }====================================================================== */

/******************************************************************************
* Copyright (C) 1994-2018 Lua.org, PUC-Rio.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/
