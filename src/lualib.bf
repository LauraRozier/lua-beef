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
		public static extern int32 open_base(lua_State* L);

		public const String COLIBNAME = "coroutine";
		[Import(lua.LIB_DLL), LinkName("luaopen_coroutine")]
		public static extern int32 open_coroutine(lua_State* L);

		public const String TABLIBNAME = "table";
		[Import(lua.LIB_DLL), LinkName("luaopen_table")]
		public static extern int32 open_table(lua_State* L);

		public const String IOLIBNAME = "io";
		[Import(lua.LIB_DLL), LinkName("luaopen_io")]
		public static extern int32 open_io(lua_State* L);

		public const String OSLIBNAME = "os";
		[Import(lua.LIB_DLL), LinkName("luaopen_os")]
		public static extern int32 open_os(lua_State* L);

		public const String STRLIBNAME = "string";
		[Import(lua.LIB_DLL), LinkName("luaopen_string")]
		public static extern int32 open_string(lua_State* L);

		public const String UTF8LIBNAME = "utf8";
		[Import(lua.LIB_DLL), LinkName("luaopen_utf8")]
		public static extern int32 open_utf8(lua_State* L);

		public const String BITLIBNAME = "bit32";
		[Import(lua.LIB_DLL), LinkName("luaopen_bit32")]
		public static extern int32 open_bit32(lua_State* L);

		public const String MATHLIBNAME = "math";
		[Import(lua.LIB_DLL), LinkName("luaopen_math")]
		public static extern int32 open_math(lua_State* L);

		public const String DBLIBNAME = "debug";
		[Import(lua.LIB_DLL), LinkName("luaopen_debug")]
		public static extern int32 open_debug(lua_State* L);

		public const String LOADLIBNAME = "package";
		[Import(lua.LIB_DLL), LinkName("luaopen_package")]
		public static extern int32 open_package(lua_State* L);

		/* open all previous libraries */
		[Import(lua.LIB_DLL), LinkName("luaL_openlibs")]
		public static extern void openlibs(lua_State* L);

		[Inline]
		public static void* assert(bool b) {
			return null;
		}
	}
}
