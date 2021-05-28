using System;
// NOTE: If you undefine USE_LUA54 you will have to clean before rebuilding
#if USE_LUA54
using lua54_beef;
#else
using lua53_beef;
#endif

namespace lua_beef_test
{
	[Reflect(.Methods | .Type), AlwaysInclude(IncludeAllMethods = true)]
	public sealed class TestModule : LuaClass
	{
		public this(lua_State* L) : base(L) { }

		public int HelloWorld(lua_State L)
		{
			// Retrieve the LUA state
			let state = GetState!(L);

			// Retrieve the arg count
			int argc = lua.gettop(state);
			Console.Out.WriteLine("BeefLang : Hello World");
			Console.Out.WriteLine("Arg Count: {0}", argc);

			// Print the args
			for (int i = 1; i <= argc; i++)
				Console.Out.WriteLine("  - Arg {0} = {1}", i, lua.tointeger(state, i));

			// Clear the stack
			lua.pop(state, lua.gettop(state));

			// Push return values
			lua.pushinteger(state, 101);
			lua.pushinteger(state, 102);
			return 2;
		}

		public int HelloWorld2(lua_State L)
		{
			// Retrieve the LUA state
			let state = GetState!(L);
			Console.Out.WriteLine("BeefLang : Hello World 2");
			// Clear the stack
			lua.pop(state, lua.gettop(state));
			return 0;
		}
	}
}
