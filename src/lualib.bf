/*
** $Id: lualib.bf
** Lua standard libraries
** See Copyright Notice in lua.bf
*/
using System;

namespace lua535_beef
{
	public static class lualib
	{
		/* version suffix for environment variable names */
		public const String VERSUFFIX = "_" + lua.VERSION_MAJOR + "_" + lua.VERSION_MINOR;
		
		[Import(lua.LIB_DLL), LinkName("luaopen_base")]
		private static extern int32 open_base(lua_State* L);
		public const String BASELIBNAME = "G_";
		public static int32 OpenBase(lua_State* L)
		{
			return open_base(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_coroutine")]
		private static extern int32 open_coroutine(lua_State* L);
		public const String COLIBNAME = "coroutine";
		public static int32 OpenCoroutine(lua_State* L)
		{
			return open_coroutine(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_table")]
		private static extern int32 open_table(lua_State* L);
		public const String TABLIBNAME = "table";
		public static int32 OpenTable(lua_State* L)
		{
			return open_table(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_io")]
		private static extern int32 open_io(lua_State* L);
		public const String IOLIBNAME = "io";
		public static int32 OpenIo(lua_State* L)
		{
			return open_io(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_os")]
		private static extern int32 open_os(lua_State* L);
		public const String OSLIBNAME = "os";
		public static int32 OpenOs(lua_State* L)
		{
			return open_os(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_string")]
		private static extern int32 open_string(lua_State* L);
		public const String STRLIBNAME = "string";
		public static int32 OpenString(lua_State* L)
		{
			return open_string(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_utf8")]
		private static extern int32 open_utf8(lua_State* L);
		public const String UTF8LIBNAME = "utf8";
		public static int32 OpenUtf8(lua_State* L)
		{
			return open_utf8(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_bit32")]
		private static extern int32 open_bit32(lua_State* L);
		public const String BITLIBNAME = "bit32";
		public static int32 OpenBit32(lua_State* L)
		{
			return open_bit32(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_math")]
		private static extern int32 open_math(lua_State* L);
		public const String MATHLIBNAME = "math";
		public static int32 OpenMath(lua_State* L)
		{
			return open_math(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_debug")]
		private static extern int32 open_debug(lua_State* L);
		public const String DBLIBNAME = "debug";
		public static int32 OpenDebug(lua_State* L)
		{
			return open_debug(L);
		}

		[Import(lua.LIB_DLL), LinkName("luaopen_package")]
		private static extern int32 open_package(lua_State* L);
		public const String LOADLIBNAME = "package";
		public static int32 OpenPackage(lua_State* L)
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
