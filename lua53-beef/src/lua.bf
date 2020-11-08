/*
** $Id: lua.bf
** Lua - A Scripting Language
** Lua.org, PUC-Rio, Brazil (http://www.lua.org)
**
** Ported by Thibmo (https://github.com/thibmo/lua535-beef)
**
** See Copyright Notice at the end of this file
*/
using System;

namespace lua53_beef
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
	public typealias intptr_t     = int*;
#if BF_64_BIT
	public typealias size_t       = uint64;
#else
	public typealias size_t       = uint32;
#endif
	public typealias va_list      = void*;

	public typealias lu_byte      = uint8;
	public typealias lua_Number   = double;
	public typealias lua_Integer  = int64;
	public typealias lua_Unsigned = uint64;
	public typealias lua_KContext = intptr_t;
	public typealias Instruction  = uint;

	/*
	** Functions to be called by the debugger in specific events
	*/
	function void lua_Hook(lua_State* L, int status, lua_KContext ctx);

	/*
	** Type for C functions registered with Lua
	*/
	function int lua_CFunction(lua_State* L);

	/*
	** Type for continuation functions
	*/ 
	function int lua_KFunction(lua_State* L);

	/*
	** Type for functions that read/write blocks when loading/dumping Lua chunks
	*/
	function char8* lua_Reader(lua_State* L, void* ud, size_t* sz);
	function int lua_Writer(lua_State* L, void* p, size_t sz, void* ud);

	/*
	** Type for memory-allocation functions
	*/
	function void* lua_Alloc(void* ud, void* ptr, size_t osize, size_t nsize);

	[CRepr]
	public struct GCObject
	{
		public GCObject* next;
		public lu_byte tt;
		public lu_byte marked;
		
		public this(GCObject* next, lu_byte tt, lu_byte marked)
		{
		    this.next = next;
			this.tt = tt;
		    this.marked = marked;
		}
	}

	[CRepr, Union]
	public struct Value
	{
		public GCObject* gc;    /* collectable objects */
		public void* p;         /* light userdata */
		public int b;           /* booleans */
		public lua_CFunction f; /* light C functions */
		public lua_Integer i;   /* integer numbers */
		public lua_Number n;    /* float numbers */
		
		public this(GCObject* gc, void* p, int b, lua_CFunction f, lua_Integer i, lua_Number n)
		{
		    this.gc = gc;
		    this.p = p;
		    this.b = b;
		    this.f = f;
		    this.i = i;
		    this.n = n;
		}
	}

	[CRepr]
	public struct lua_TValue
	{
		public Value value_;
		public int tt_;
		
		public this(Value value_, int tt_)
		{
			this.value_ = value_;
			this.tt_ = tt_;
		}
	}

	public typealias TValue = lua_TValue;
	public typealias StkId  = TValue*; /* index to stack elements */

	[CRepr]
	public struct lua_Debug
	{
		public int event;
		public char8* name;                 /* (n) */
		public char8* namewhat;             /* (n) 'global', 'local', 'field', 'method' */
		public char8* what;                 /* (S) 'Lua', 'C', 'main', 'tail' */
		public char8* source;               /* (S) */
		public int currentline;             /* (l) */
		public int linedefined;             /* (S) */
		public int lastlinedefined;         /* (S) */
		public uint8 nups;                  /* (u) number of upvalues */
		public uint8 nparams;               /* (u) number of parameters */
		public char8 isvararg;              /* (u) */
		public char8 istailcall;            /* (t) */
		public char8[lua.IDSIZE] short_src; /* (S) */
		/* private part */
		public void* i_ci;                  /* active function */
		
		public this(int event, char8* name, char8* namewhat, char8* what, char8* source, int currentline, int linedefined, int lastlinedefined, uint8 nups,
					uint8 nparams, char8 isvararg, char8 istailcall, char8[lua.IDSIZE] short_src, void* i_ci)
		{
		    this.event = event;
		    this.name = name;
		    this.namewhat = namewhat;
		    this.what = what;
		    this.source = source;
		    this.currentline = currentline;
		    this.linedefined = linedefined;
		    this.lastlinedefined = lastlinedefined;
		    this.nups = nups;
		    this.nparams = nparams;
		    this.isvararg = isvararg; 
		    this.istailcall = istailcall;
		    this.short_src = short_src;
		    this.i_ci = i_ci;
		}
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
		public int stacksize;
		public int basehookcount;
		public int hookcount;
		public uint16 nny;          /* number of non-yieldable calls in stack */
		public uint16 nCcalls;      /* number of nested C calls */
		public int hookmask;
		public lu_byte allowhook;
		
		public this(GCObject* next, lu_byte tt, lu_byte marked, uint16 nci, lu_byte status, StkId top, void* l_G, void* ci, Instruction* oldpc,
					StkId stack_last, StkId _stack, void* openupval, GCObject* gclist, lua_State* twups, void* errorJmp, void* base_ci, lua_Hook hook,
					ptrdiff_t errfunc, int stacksize, int basehookcount, int hookcount, uint16 nny, uint16 nCcalls, int hookmask, lu_byte allowhook)
		{
			this.next = next;
			this.tt = tt;
			this.marked = marked;
			this.nci = nci;
			this.status = status;
			this.top = top;
			this.l_G = l_G;
			this.ci = ci;
			this.oldpc = oldpc;
			this.stack_last = stack_last;
			this._stack = _stack;
			this.openupval = openupval;
			this.gclist = gclist;
			this.twups = twups;
			this.errorJmp = errorJmp;
			this.base_ci = base_ci;
			this.hook = hook;
			this.errfunc = errfunc;
			this.stacksize = stacksize;
			this.basehookcount = basehookcount;
			this.hookcount = hookcount;
			this.nny = nny;
			this.nCcalls = nCcalls;
			this.hookmask = hookmask;
			this.allowhook = allowhook;
		}
	}

	/* =================================================================== */

	/*
	** Local configuration. You can use this space to add your redefinitions
	** without modifying the main part of the file.
	*/

	public abstract class lua
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
		public static size_t strlen(lua_State* L, int i) {
			return rawlen(L, i);
		}

		[Inline]
		public static size_t objlen(lua_State* L, int i) {
			return rawlen(L, i);
		}

		[Inline]
		public static int equal(lua_State* L, int idx1, int idx2) {
			return compare(L, idx1, idx2, LUA_OPEQ);
		}

		[Inline]
		public static int lessthan(lua_State* L, int idx1, int idx2) {
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
		public const int MAXSTACK = 1000000;

		/*
		@@ LUA_EXTRASPACE defines the size of a raw memory area associated with
		** a Lua state with very fast access.
		** CHANGE it if you need a different size.
		*/
		public const int EXTRASPACE = sizeof(void*);

		/*
		@@ LUA_IDSIZE gives the maximum size for the description of the source
		@@ of a function in debug information.
		** CHANGE it if you want a different size.
		*/
		public const int IDSIZE = 60;

		/*
		@@ LUAL_BUFFERSIZE is the buffer size used by the lauxlib buffer system.
		** CHANGE it if it uses too much C-stack space. (For long double,
		** 'string.format("%.99f", -1e4932)' needs 5034 bytes, so a
		** smaller buffer would force a memory allocation for each call to
		** 'string.format'.)
		*/
		public const int BUFFERSIZE = (int)(0x80 * sizeof(void*) * sizeof(lua_Integer));

		/* =================================================================== */

		public const String VERSION_MAJOR   = "5";
		public const String VERSION_MINOR   = "3";
		public const uint VERSION_NUM     = 503;
		public const String VERSION_RELEASE = "6";

		public const String VERSION         = "Lua " + VERSION_MAJOR + "." + VERSION_MINOR;
		public const String RELEASE         = VERSION + "." + VERSION_RELEASE;
		public const String COPYRIGHT       = RELEASE + "  Copyright (C) 1994-2018 Lua.org, PUC-Rio";
		public const String AUTHORS         = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes";

		/* mark for precompiled code (`<esc>Lua') */
		public const String SIGNATURE = "\x1bLua";

		/* option for multiple returns in `lua_pcall' and `lua_call' */
		public const int MULTRET    = -1;

		/*
		** Pseudo-indices
		** (-LUAI_MAXSTACK is the minimum valid index; we keep some free empty
		** space after that to help overflow detection)
		*/
		public const int REGISTRYINDEX = (-MAXSTACK) - 1000;
		[Inline]
		public static int upvalueindex(int idx)
		{
			return REGISTRYINDEX - idx;
		}

		/* thread status */
		public const int OK        = 0;
		public const int YIELD     = 1;
		public const int ERRRUN    = 2;
		public const int ERRSYNTAX = 3;
		public const int ERRMEM    = 4;
		public const int ERRGCMM   = 5;
		public const int ERRERR    = 6;

		/*
		** basic types
		*/
		public const int TNONE          = -1;

		public const int TNIL           = 0;
		public const int TBOOLEAN       = 1;
		public const int TLIGHTUSERDATA = 2;
		public const int TNUMBER        = 3;
		public const int TSTRING        = 4;
		public const int TTABLE         = 5;
		public const int TFUNCTION      = 6;
		public const int TUSERDATA      = 7;
		public const int TTHREAD        = 8;

		public const int NUMTAGS        = 9;

		/* minimum Lua stack available to a C function */
		public const int MINSTACK = 20;

		/* predefined values in the registry */
		public const int RIDX_MAINTHREAD = 1;
		public const int RIDX_GLOBALS    = 2;
		public const int RIDX_LAST       = RIDX_GLOBALS;

#if BF_PLATFORM_WINDOWS
		public const String LIB_DLL = "lua53.dll";
#elif BF_PLATFORM_LINUX
		public const String LIB_DLL = "liblua53.so";
#else
		#error This platform is incompatible
#endif

		/* Results in "unresolved" error
		[Import(LIB_DLL), LinkName("lua_ident")]
		public extern static char8* ident;
		*/

		/*
		** state manipulation
		*/
		[Import(LIB_DLL), LinkName("lua_newstate")]
		public extern static lua_State* newstate(lua_Alloc f, void* ud);
		[Import(LIB_DLL), LinkName("lua_close")]
		public extern static void close(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_newthread")]
		public extern static lua_State* newthread(lua_State* L);

		[Import(LIB_DLL), LinkName("lua_atpanic")]
		public extern static lua_CFunction atpanic(lua_State* L, lua_CFunction panicf);

		[Import(LIB_DLL), LinkName("lua_version")]
		public extern static lua_Number* version(lua_State* L);

		/*
		** basic stack manipulation
		*/
		[Import(LIB_DLL), LinkName("lua_absindex")]
		public extern static int absindex(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_gettop")]
		public extern static int gettop(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_settop")]
		public extern static void settop(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_pushvalue")]
		public extern static void pushvalue(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_rotate")]
		public extern static void rotate(lua_State* L, int idx, int n);
		[Import(LIB_DLL), LinkName("lua_copy")]
		public extern static void copy(lua_State* L, int fromidx, int toidx);
		[Import(LIB_DLL), LinkName("lua_checkstack")]
		public extern static int checkstack(lua_State* L, int n);

		[Import(LIB_DLL), LinkName("lua_xmove")]
		public extern static void xmove(lua_State* from, lua_State* to, int n);

		/*
		** access functions (stack -> C)
		*/
		[Import(LIB_DLL), LinkName("lua_isnumber")]
		public extern static bool isnumber(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_isstring")]
		public extern static bool isstring(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_iscfunction")]
		public extern static bool iscfunction(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_isinteger")]
		public extern static bool isinteger(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_isuserdata")]
		public extern static bool isuserdata(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_type")]
		public extern static int type(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_typename")]
		public extern static char8* typename(lua_State* L, int tp);

		[Import(LIB_DLL), LinkName("lua_tonumberx")]
		public extern static lua_Number tonumberx(lua_State* L, int idx, bool* isnum);
		[Import(LIB_DLL), LinkName("lua_tointegerx")]
		public extern static lua_Integer tointegerx(lua_State* L, int idx, bool* isnum);
		[Import(LIB_DLL), LinkName("lua_toboolean")]
		public extern static bool toboolean(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_tolstring")]
		public extern static char8* tolstring(lua_State* L, int idx, size_t* len);
		[Import(LIB_DLL), LinkName("lua_rawlen")]
		public extern static size_t rawlen(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_tocfunction")]
		public extern static lua_CFunction tocfunction(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_touserdata")]
		public extern static void* touserdata(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_tothread")]
		public extern static lua_State* tothread(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_topointer")]
		public extern static void* topointer(lua_State* L, int idx);

		/*
		** Comparison and arithmetic functions
		*/
		public const int OPADD  = 0; /* ORDER TM, ORDER OP */
		public const int OPSUB  = 1;
		public const int OPMUL  = 2;
		public const int OPMOD  = 3;
		public const int OPPOW  = 4;
		public const int OPDIV  = 5;
		public const int OPIDIV = 6;
		public const int OPBAND = 7;
		public const int OPBOR  = 8;
		public const int OPBXOR = 9;
		public const int OPSHL  = 10;
		public const int OPSHR  = 11;
		public const int OPUNM  = 12;
		public const int OPBNOT = 13;

		[Import(LIB_DLL), LinkName("lua_arith")]
		public extern static void arith(lua_State* L, int op);

		public const int OPEQ = 0;
		public const int OPLT = 1;
		public const int OPLE = 2;

		[Import(LIB_DLL), LinkName("lua_rawequal")]
		public extern static int rawequal(lua_State* L, int idx1, int idx2);
		[Import(LIB_DLL), LinkName("lua_compare")]
		public extern static int compare(lua_State* L, int idx1, int idx2, int op);

		/*
		** push functions (C -> stack)
		*/
		[Import(LIB_DLL), LinkName("lua_pushnil")]
		public extern static void pushnil(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_pushnumber")]
		public extern static void pushnumber(lua_State* L, lua_Number val);
		[Import(LIB_DLL), LinkName("lua_pushinteger")]
		public extern static void pushinteger(lua_State* L, lua_Integer val);
		[Import(LIB_DLL), LinkName("lua_pushlstring")]
		public extern static char8* pushlstring(lua_State* L, char8* val, size_t len);
		[Import(LIB_DLL), LinkName("lua_pushstring")]
		public extern static char8* pushstring(lua_State* L, char8* val);
		[Import(LIB_DLL), LinkName("lua_pushvfstring")]
		public extern static char8* pushvfstring(lua_State* L, char8* fmt, va_list argp);
		[Import(LIB_DLL), LinkName("lua_pushfstring"), CVarArgs]
		public extern static char8* pushfstring(lua_State* L, char8* fmt, params Object[] args);
		[Import(LIB_DLL), LinkName("lua_pushcclosure")]
		public extern static void pushcclosure(lua_State* L, lua_CFunction val, int n);
		[Import(LIB_DLL), LinkName("lua_pushboolean")]
		public extern static void pushboolean(lua_State* L, bool val);
		[Import(LIB_DLL), LinkName("lua_pushlightuserdata")]
		public extern static void pushlightuserdata(lua_State* L, void* p);
		[Import(LIB_DLL), LinkName("lua_pushthread")]
		public extern static int pushthread(lua_State* L);

		/*
		** get functions (Lua -> stack)
		*/
		[Import(LIB_DLL), LinkName("lua_getglobal")]
		public extern static int getglobal(lua_State* L, char8* name);
		[Import(LIB_DLL), LinkName("lua_gettable")]
		public extern static int gettable(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_getfield")]
		public extern static int getfield(lua_State* L, int idx, char8* k);
		[Import(LIB_DLL), LinkName("lua_geti")]
		public extern static int geti(lua_State* L, int idx, lua_Integer n);
		[Import(LIB_DLL), LinkName("lua_rawget")]
		public extern static int rawget(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_rawgeti")]
		public extern static int rawgeti(lua_State* L, int idx, lua_Integer n);
		[Import(LIB_DLL), LinkName("lua_rawgetp")]
		public extern static int rawgetp(lua_State* L, int idx, void* p);

		[Import(LIB_DLL), LinkName("lua_createtable")]
		public extern static void createtable(lua_State* L, int narr, int nrec);
		[Import(LIB_DLL), LinkName("lua_newuserdata")]
		public extern static void* newuserdata(lua_State* L, size_t sz);
		[Import(LIB_DLL), LinkName("lua_getmetatable")]
		public extern static int getmetatable(lua_State* L, int objindex);
		[Import(LIB_DLL), LinkName("lua_getuservalue")]
		public extern static int getuservalue(lua_State* L, int idx);

		/*
		** set functions (stack -> Lua)
		*/
		[Import(LIB_DLL), LinkName("lua_setglobal")]
		public extern static void setglobal(lua_State* L, char8* name);
		[Import(LIB_DLL), LinkName("lua_settable")]
		public extern static void settable(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_setfield")]
		public extern static void setfield(lua_State* L, int idx, char8* k);
		[Import(LIB_DLL), LinkName("lua_seti")]
		public extern static void seti(lua_State* L, int idx, lua_Integer n);
		[Import(LIB_DLL), LinkName("lua_rawset")]
		public extern static void rawset(lua_State* L, int idx);
		[Import(LIB_DLL), LinkName("lua_rawseti")]
		public extern static void rawseti(lua_State* L, int idx, lua_Integer n);
		[Import(LIB_DLL), LinkName("lua_rawsetp")]
		public extern static void rawsetp(lua_State* L, int idx, void* p);
		[Import(LIB_DLL), LinkName("lua_setmetatable")]
		public extern static int setmetatable(lua_State* L, int objindex);
		[Import(LIB_DLL), LinkName("lua_setuservalue")]
		public extern static void setuservalue(lua_State* L, int idx);

		/*
		** 'load' and 'call' functions (load and run Lua code)
		*/
		[Import(LIB_DLL), LinkName("lua_callk")]
		public extern static void callk(lua_State* L, int nargs, int nresults, lua_KContext ctx, lua_KFunction k);
		[Inline]
		public static void call(lua_State* L, int nargs, int nresults)
		{
			callk(L, nargs, nresults, null, null);
		}

		[Import(LIB_DLL), LinkName("lua_pcallk")]
		public extern static int pcallk(lua_State* L, int nargs, int nresults, int errfunc, lua_KContext ctx, lua_KFunction k);
		[Inline]
		public static int pcall(lua_State* L, int nargs, int nresults, int errfunc)
		{
			return pcallk(L, nargs, nresults, errfunc, null, null);
		}

		[Import(LIB_DLL), LinkName("lua_load")]
		public extern static int load(lua_State* L, lua_Reader reader, void* dt, char8* chunkname, char8* mode);

		[Import(LIB_DLL), LinkName("lua_dump")]
		public extern static int dump(lua_State* L, lua_Writer writer, void* data, int strip);

		/*
		** coroutine functions
		*/
		[Import(LIB_DLL), LinkName("lua_yieldk")]
		public extern static int yieldk(lua_State* L, int nresults, lua_KContext ctx, lua_KFunction k);
		[Import(LIB_DLL), LinkName("lua_resume")]
		public extern static int resume(lua_State* L, lua_State* from, int narg);
		[Import(LIB_DLL), LinkName("lua_status")]
		public extern static int status(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_isyieldable")]
		public extern static int isyieldable(lua_State* L);

		[Inline]
		public static int yield_(lua_State* L, int nresults) /* Suffixed with _ to prevent naming collision */
		{
			return yieldk(L, nresults, null, null);
		}

		/*
		** garbage-collection function and options
		*/
		public const int GCSTOP       = 0;
		public const int GCRESTART    = 1;
		public const int GCCOLLECT    = 2;
		public const int GCCOUNT      = 3;
		public const int GCCOUNTB     = 4;
		public const int GCSTEP       = 5;
		public const int GCSETPAUSE   = 6;
		public const int GCSETSTEPMUL = 7;
		public const int GCISRUNNING  = 9;

		[Import(LIB_DLL), LinkName("lua_gc")]
		public extern static int gc(lua_State* L, int what, int data);

		/*
		** miscellaneous functions
		*/
		[Import(LIB_DLL), LinkName("lua_error")]
		public extern static int error(lua_State* L);

		[Import(LIB_DLL), LinkName("lua_next")]
		public extern static int next(lua_State* L, int idx);

		[Import(LIB_DLL), LinkName("lua_concat")]
		public extern static void concat(lua_State* L, int n);
		[Import(LIB_DLL), LinkName("lua_len")]
		public extern static void len(lua_State* L, int idx);

		[Import(LIB_DLL), LinkName("lua_stringtonumber")]
		public extern static size_t stringtonumber(lua_State* L, char8* s);

		[Import(LIB_DLL), LinkName("lua_getallocf")]
		public extern static lua_Alloc getallocf(lua_State* L, void** ud);
		[Import(LIB_DLL), LinkName("lua_setallocf")]
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
		public static lua_Number tonumber(lua_State* L, int idx)
		{
			return tonumberx(L, idx, null);
		}
		[Inline]
		public static lua_Integer tointeger(lua_State* L, int idx)
		{
			return tointegerx(L, idx, null);
		}

		[Inline]
		public static void pop(lua_State* L, int idx)
		{
			settop(L, -(idx - 1));
		}

		[Inline]
		public static void newtable(lua_State* L)
		{
			createtable(L, 0, 0);
		}

		[Inline]
		public static void register(lua_State* L, String name, lua_CFunction fn)
		{
			pushcfunction(L, fn);
			setglobal(L, name.CStr());
		}

		[Inline]
		public static void pushcfunction(lua_State* L, lua_CFunction fn)
		{
			pushcclosure(L, fn, 0);
		}

		[Inline]
		public static bool isfunction(lua_State* L, int idx)
		{
			return type(L, idx) == TFUNCTION;
		}
		[Inline]
		public static bool istable(lua_State* L, int idx)
		{
			return type(L, idx) == TTABLE;
		}
		[Inline]
		public static bool islightuserdata(lua_State* L, int idx)
		{
			return type(L, idx) == TLIGHTUSERDATA;
		}
		[Inline]
		public static bool isnil(lua_State* L, int idx)
		{
			return type(L, idx) == TNIL;
		}
		[Inline]
		public static bool isboolean(lua_State* L, int idx)
		{
			return type(L, idx) == TBOOLEAN;
		}
		[Inline]
		public static bool isthread(lua_State* L, int idx)
		{
			return type(L, idx) == TTHREAD;
		}
		[Inline]
		public static bool isnone(lua_State* L, int idx)
		{
			return type(L, idx) == TNONE;
		}
		[Inline]
		public static bool isnoneornil(lua_State* L, int idx)
		{
			return type(L, idx) <= 0;
		}

		[Inline]
		public static void pushliteral(lua_State* L, String str)
		{
			pushstring(L, str.CStr());
		}

		[Inline]
		public static void pushglobaltable(lua_State* L)
		{
			rawgeti(L, REGISTRYINDEX, RIDX_GLOBALS);
		}

		[Inline]
		public static void tostring(lua_State* L, int idx, String buffer)
		{
			buffer.Append(tolstring(L, idx, null));
		}

		[Inline]
		public static void insert(lua_State* L, int idx)
		{
			rotate(L, idx, 1);
		}

		[Inline]
		public static void remove(lua_State* L, int idx)
		{
			rotate(L, idx, -1);
			pop(L, 1);
		}

		[Inline]
		public static void replace(lua_State* L, int idx)
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
		public static void pushunsigned(lua_State* L, lua_Integer val)
		{
			pushinteger(L, (lua_Integer)val);
		}
		[Inline]
		public static lua_Unsigned tounsignedx(lua_State* L, int idx, bool* isnum)
		{
			return (lua_Unsigned)tointegerx(L, idx, isnum);
		}
		[Inline]
		public static lua_Unsigned tounsigned(lua_State* L, int idx)
		{
			return tounsignedx(L, idx, null);
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
		public const int HOOKCALL     = 0;
		public const int HOOKRET      = 1;
		public const int HOOKLINE     = 2;
		public const int HOOKCOUNT    = 3;
		public const int HOOKTAILCALL = 4;

		/*
		** Event masks
		*/
		public const int MASKCALL  = 1 << HOOKCALL;
		public const int MASKRET   = 1 << HOOKRET;
		public const int MASKLINE  = 1 << HOOKLINE;
		public const int MASKCOUNT = 1 << HOOKCOUNT;

		[Import(LIB_DLL), LinkName("lua_getstack")]
		public extern static int getstack(lua_State* L, int level, lua_Debug* ar);
		[Import(LIB_DLL), LinkName("lua_getinfo")]
		public extern static int getinfo(lua_State* L, char8* what, lua_Debug* ar);
		[Import(LIB_DLL), LinkName("lua_getlocal")]
		public extern static char8* getlocal(lua_State* L, lua_Debug* ar, int n);
		[Import(LIB_DLL), LinkName("lua_setlocal")]
		public extern static char8* setlocal(lua_State* L, lua_Debug* ar, int n);
		[Import(LIB_DLL), LinkName("lua_getupvalue")]
		public extern static char8* getupvalue(lua_State* L, int funcindex, int n);
		[Import(LIB_DLL), LinkName("lua_setupvalue")]
		public extern static char8* setupvalue(lua_State* L, int funcindex, int n);

		[Import(LIB_DLL), LinkName("lua_upvalueid")]
		public extern static void* upvalueid(lua_State* L, int fidx, int n);
		[Import(LIB_DLL), LinkName("lua_upvaluejoin")]
		public extern static void upvaluejoin(lua_State* L, int fidx1, int n1, int fidx2, int n2);

		[Import(LIB_DLL), LinkName("lua_sethook")]
		public extern static void sethook(lua_State* L, lua_Hook func, int mask, int count);
		[Import(LIB_DLL), LinkName("lua_gethook")]
		public extern static lua_Hook gethook(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_gethookmask")]
		public extern static int gethookmask(lua_State* L);
		[Import(LIB_DLL), LinkName("lua_gethookcount")]
		public extern static int gethookcount(lua_State* L);

		/* }====================================================================== */
	}
}

/* }====================================================================== */

/******************************************************************************
* Copyright (C) 1994-2020 Lua.org, PUC-Rio.
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
