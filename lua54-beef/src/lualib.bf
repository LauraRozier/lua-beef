/*
** $Id: lualib.bf
** Lua standard libraries
** See Copyright Notice in lua.bf
*/
using System;

namespace lua54_beef
{
	public abstract class lualib
	{
		/* version suffix for environment variable names */
		public const String VERSUFFIX = "_" + lua.VERSION_MAJOR + "_" + lua.VERSION_MINOR;
		
		[Import(lua.LIB_DLL), LinkName("luaopen_base")]
		private static extern int open_base(lua_State* L);
		public const String BASELIBNAME = "G_";
		public static int OpenBase(lua_State* L)
		{
			return open_base(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_coroutine")]
		private static extern int open_coroutine(lua_State* L);
		public const String COLIBNAME = "coroutine";
		public static int OpenCoroutine(lua_State* L)
		{
			return open_coroutine(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_table")]
		private static extern int open_table(lua_State* L);
		public const String TABLIBNAME = "table";
		public static int OpenTable(lua_State* L)
		{
			return open_table(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_io")]
		private static extern int open_io(lua_State* L);
		public const String IOLIBNAME = "io";
		public static int OpenIo(lua_State* L)
		{
			return open_io(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_os")]
		private static extern int open_os(lua_State* L);
		public const String OSLIBNAME = "os";
		public static int OpenOs(lua_State* L)
		{
			return open_os(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_string")]
		private static extern int open_string(lua_State* L);
		public const String STRLIBNAME = "string";
		public static int OpenString(lua_State* L)
		{
			return open_string(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_utf8")]
		private static extern int open_utf8(lua_State* L);
		public const String UTF8LIBNAME = "utf8";
		public static int OpenUtf8(lua_State* L)
		{
			return open_utf8(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_math")]
		private static extern int open_math(lua_State* L);
		public const String MATHLIBNAME = "math";
		public static int OpenMath(lua_State* L)
		{
			return open_math(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_debug")]
		private static extern int open_debug(lua_State* L);
		public const String DBLIBNAME = "debug";
		public static int OpenDebug(lua_State* L)
		{
			return open_debug(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_package")]
		private static extern int open_package(lua_State* L);
		public const String LOADLIBNAME = "package";
		public static int OpenPackage(lua_State* L)
		{
			return open_package(L);
		}

		/* open all previous libraries */
		[Import(lua.LIB_DLL), LinkName("luaL_openlibs")]
		public static extern void openlibs(lua_State* L);

		[Inline]
		public static void* assert(bool b) {
			return null;
		}
	}
}
