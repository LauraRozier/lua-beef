/*
** {============================================================
** Additional goodies by Thibmo
** }============================================================
*/
using System;

namespace lua54_beef
{
	public abstract class luautils
	{
		public const int ERR_IDX     = -1;
		public const int ERR_POP_IDX = 1;

		[Inline]
		public static void PushGlobalNil(lua_State* L, String name)
		{
			lua.pushnil(L);
			lua.setglobal(L, name.CStr());
		}

		[Inline]
		public static void PushGlobalNumber(lua_State* L, String name, lua_Number val)
		{
			lua.pushnumber(L, val);
			lua.setglobal(L, name.CStr());
		}

		[Inline]
		public static void PushGlobalInteger(lua_State* L, String name, lua_Integer val)
		{
			lua.pushinteger(L, val);
			lua.setglobal(L, name.CStr());
		}

		[Inline]
		public static void PushGlobalString(lua_State* L, String name, String val)
		{ 
			lua.pushstring(L, val.CStr());
			lua.setglobal(L, name.CStr());
		}

		[Inline]
		public static void PushGlobalBool(lua_State* L, String name, bool val)
		{
			lua.pushboolean(L, val);
			lua.setglobal(L, name.CStr());
		}

		[Inline]
		public static void PushModule(lua_State* L, String name, lua_CFunction fn, bool glb)
		{
			lauxlib.requiref(L, name.CStr(), fn, glb);
			lua.pop(L, 1); // Pop is required because requiref leaves the lib table on the stack
		}

		[Inline]
		public static void PushModule(lua_State* L, luaL_Reg[] funcs, bool glb)
		{
			for (luaL_Reg item in funcs) {
				lauxlib.requiref(L, item.name, item.func, glb);
				lua.pop(L, 1); // Pop is required because requiref leaves the lib table on the stack
			}
		}
	}
}
