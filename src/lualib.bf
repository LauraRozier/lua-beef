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

		[CLink]
		public static extern int32 luaopen_base(lua_State* L);

		public const String COLIBNAME = "coroutine";
		[CLink]
		public static extern int32 luaopen_coroutine(lua_State* L);

		public const String TABLIBNAME = "table";
		[CLink]
		public static extern int32 luaopen_table(lua_State* L);

		public const String IOLIBNAME = "io";
		[CLink]
		public static extern int32 luaopen_io(lua_State* L);

		public const String OSLIBNAME = "os";
		[CLink]
		public static extern int32 luaopen_os(lua_State* L);

		public const String STRLIBNAME = "string";
		[CLink]
		public static extern int32 luaopen_string(lua_State* L);

		public const String UTF8LIBNAME = "utf8";
		[CLink]
		public static extern int32 luaopen_utf8(lua_State* L);

		public const String BITLIBNAME = "bit32";
		[CLink]
		public static extern int32 luaopen_bit32(lua_State* L);

		public const String MATHLIBNAME = "math";
		[CLink]
		public static extern int32 luaopen_math(lua_State* L);

		public const String DBLIBNAME = "debug";
		[CLink]
		public static extern int32 luaopen_debug(lua_State* L);

		public const String LOADLIBNAME = "package";
		[CLink]
		public static extern int32 luaopen_package(lua_State* L);

		/* open all previous libraries */
		[LinkName("luaL_openlibs"), CLink]
		public static extern void openlibs(lua_State* L);

		[Inline]
		public static void* assert(bool b) {
			return null;
		}
	}
}
