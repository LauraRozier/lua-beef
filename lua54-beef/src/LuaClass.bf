using System;
using System.Reflection;

namespace lua54_beef
{
	public abstract class LuaClass
	{
		private const BindingFlags ReflectFlags = .Instance | .Public;
		private String _className = new .() ~ delete _;

		// Retrieve the LUA state pointer
		protected mixin GetState(lua_State L)
		{
			var L;
			&L
		}

		// Push a single function to LUA
		private static void PushFunction(lua_State* L, Object obj, StringView objName, StringView name)
		{
			var obj;
			
			String funcName = scope .();
			funcName.AppendF("{0}_{1}", objName, name);
			// prepare Closure value (Method Name)
			//lua.pushstring(L, name.Ptr);
			// prepare Closure value (CallBack Object Pointer and function name)
			lua.pushlightuserdata(L, &obj);
			lua.pushstring(L, name.Ptr);
			// set new Lua function with Closure values
			lua.pushcclosure(L, => LuaCallBack, 2);
			// set table using the method's name
  			lua.setglobal(L, funcName.Ptr);
		}

		// Callback function to actually execute the requested function
		private static int LuaCallBack(lua_State* L)
		{
			String name = scope .();
			// retrieve Closure value (CallBack Object Pointer and function name)
			Object obj = *(Object*)lua.topointer(L, lua.upvalueindex(1));
			lua.tostring(L, lua.upvalueindex(2), name);
			// reflect the function
			let method = obj.GetType().GetMethod(name, ReflectFlags).Value;
			// execute the function and return it's value
			return method.Invoke(obj, *L).Value.Get<int>();
		}

		// Register the object's functions to LUA as globals
		private static void RegisterFunctions(lua_State* L, Object obj, StringView objName)
		{
			for (let item in obj.GetType().GetMethods(ReflectFlags)) {
				if (item.ParamCount == 1 && item.GetParamType(0) == typeof(lua_State) && item.ReturnType == typeof(int))
					PushFunction(L, obj, objName, item.Name);
			}
		}

		public this(lua_State* L)
		{
			this.GetType().GetName(_className);
			RegisterFunctions(L, this, _className);
		}
	}
}
