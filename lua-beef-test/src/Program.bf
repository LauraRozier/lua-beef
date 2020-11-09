// NOTE : If you change this, first clean, then build.
#define USE_LUA54

using System;
using System.IO;
#if USE_LUA54
	using lua54_beef;
#else
	using lua53_beef;
#endif

namespace lua_beef_test
{
	class Program
	{
		private static lua_State* fLuaState;
		private static String fExeDir                   = new .() ~ delete _;
		private const String TEST_SCRIPT                = "test.lua";
#if USE_LUA54
		private const String TEST_SCRIPT_COMPILED       = "compiledLua.54.luac";
		private const String TEST_SCRIPT_COMPILED_DEBUG = "compiledLua_d.54.luac";
#else
		private const String TEST_SCRIPT_COMPILED       = "compiledLua.53.luac";
		private const String TEST_SCRIPT_COMPILED_DEBUG = "compiledLua_d.53.luac";
#endif

		static void Main()
		{
			/** Retrieve the exe's directory, Lua's "dofile", "loadfile" and "loadfilex" require a full path **/
			String tmp = new .();
			Environment.GetExecutableFilePath(tmp);
			Path.GetDirectoryPath(tmp, fExeDir);
			delete tmp;

			/*---------------------------------------------------------------------------
			** Lua from a text file
			*/
			
			Console.WriteLine("DEBUG > Running LUA script using run-time compiler\n");
			/** Initialize the Lua library and create the main Lua thread **/
			fLuaState = lauxlib.newstate();
			/* TODO: Custom alloc is broken, needs a working implementation. Throws "EXCEPTION_ACCESS_VIOLATION reading from 0xFFFFFFFF'FFFFFFFF" */
			//fLuaState = lua.newstate(=> l_alloc, null);

			PushModules();
			PushGlobals();
			/* Overwrite the built-in print(..) method */
			lua.register(fLuaState, "print", => l_print);

			RunScript(TEST_SCRIPT, "World");

			/** Stop the main thread, perform last remaining cleanups and destruct the Lua library **/
			lua.close(fLuaState);

			/*---------------------------------------------------------------------------
			** Lua from a compiled script with debug symbols
			*/
			
			Console.WriteLine("DEBUG > Running pre-compiled (using luac.exe) LUA script with debug symbols\n");
			/** Initialize the Lua library and create the main Lua thread **/
			fLuaState = lauxlib.newstate();
			PushModules();
			PushGlobals();
			/* Overwrite the built-in print(..) method */
			lua.register(fLuaState, "print", => l_print);

			RunScript(TEST_SCRIPT_COMPILED_DEBUG, " with debug symbols");

			/** Stop the main thread, perform last remaining cleanups and destruct the Lua library **/
			lua.close(fLuaState);

			/*---------------------------------------------------------------------------
			** Lua from a compiled script
			*/
			
			Console.WriteLine("DEBUG > Running pre-compiled (using luac.exe) LUA script without debug symbols\n");
			/** Initialize the Lua library and create the main Lua thread **/
			fLuaState = lauxlib.newstate();
			PushModules();
			PushGlobals();
			/* Overwrite the built-in print(..) method */
			lua.register(fLuaState, "print", => l_print);

			RunScript(TEST_SCRIPT_COMPILED, "");

			/** Stop the main thread, perform last remaining cleanups and destruct the Lua library **/
			lua.close(fLuaState);

			Console.WriteLine("Press Enter to exit");
			Console.In.Read();
		}

		private static void RunScript(String file, String val)
		{
			String errorStr   = new .("Error: ");
			String scriptFile = new .(fExeDir);
			scriptFile.AppendF("{}{}", Path.DirectorySeparatorChar, file);

			/* Save ourselves some typing work and just make use of the wonderfull mixins */
			mixin exit() {
				delete errorStr;
				delete scriptFile;
				return;
			}
			mixin errorOut() {
				lua.tostring(fLuaState, luautils.ERR_IDX, errorStr);
				lua.pop(fLuaState, luautils.ERR_POP_IDX); // Pop the error off of the stack
				lauxlib.writestringerror(errorStr);
				exit!();
			}
			mixin errorOut(String msg) {
				errorStr.Append(msg);
				lauxlib.writestringerror(errorStr);
				exit!();
			}

			if (lauxlib.dofile(fLuaState, scriptFile) != lua.OK) { // Load and compile the LUA script
				errorOut!();
			}

			if (lua.getglobal(fLuaState, "Run") <= lua.TNIL) { // Locate the "Run" function
				errorOut!("Could not find the required 'Run' function");
			}

			if (!lua.isfunction(fLuaState, -1)) { // Verify the type
				errorOut!("'Run' if not a function");
			}

			Console.WriteLine("DEBUG > Found the 'Run' function\n");
			/** Push a variable onto the stack, this is how we provide arguments for the function we're about to call **/
			lua.pushstring(fLuaState, val.CStr());

			if (lua.pcall(fLuaState, 1, 0, 0) != lua.OK) { // Call the "Run" function
				errorOut!();
			}
			
			Console.WriteLine("""

DEBUG > 'Run' method ran OK

<=======================================================================================>

""");
			exit!();
		}

		private static void PushModules()
		{
			/*** Open specific libs in bulk ***/
			luaL_Reg[] mods = scope:: luaL_Reg[](
				.(lualib.BASELIBNAME, => lualib.OpenBase),
				.(lualib.COLIBNAME,   => lualib.OpenCoroutine),
				.(lualib.TABLIBNAME,  => lualib.OpenTable),
				.(lualib.IOLIBNAME,   => lualib.OpenIo),
				.(lualib.OSLIBNAME,   => lualib.OpenOs),
				.(lualib.STRLIBNAME,  => lualib.OpenString),
				.(lualib.UTF8LIBNAME, => lualib.OpenUtf8),
				//.(lualib.BITLIBNAME,  => lualib.OpenBit32), // Removed in Lua 5.4
				.(lualib.MATHLIBNAME, => lualib.OpenMath),
				.(lualib.DBLIBNAME,   => lualib.OpenDebug),
				.(lualib.LOADLIBNAME, => lualib.OpenPackage)
			);
			luautils.PushModule(fLuaState, mods, true);
			/*** Open specific libs one-by-one ***/
			// luautils.PushModule(fLuaState, lualib.BASELIBNAME, => lualib.OpenBase,      true);
			// luautils.PushModule(fLuaState, lualib.COLIBNAME,   => lualib.OpenCoroutine, true);
			// luautils.PushModule(fLuaState, lualib.TABLIBNAME,  => lualib.OpenTable,     true);
			// luautils.PushModule(fLuaState, lualib.IOLIBNAME,   => lualib.OpenIo,        true);
			// luautils.PushModule(fLuaState, lualib.OSLIBNAME,   => lualib.OpenOs,        true);
			// luautils.PushModule(fLuaState, lualib.STRLIBNAME,  => lualib.OpenString,    true);
			// luautils.PushModule(fLuaState, lualib.UTF8LIBNAME, => lualib.OpenUtf8,      true);
			// luautils.PushModule(fLuaState, lualib.BITLIBNAME,  => lualib.OpenBit32,     true); // Removed in Lua 5.4
			// luautils.PushModule(fLuaState, lualib.MATHLIBNAME, => lualib.OpenMath,      true);
			// luautils.PushModule(fLuaState, lualib.DBLIBNAME,   => lualib.OpenDebug,     true);
			// luautils.PushModule(fLuaState, lualib.LOADLIBNAME, => lualib.OpenPackage,   true);
			/*** Open all libs ***/
			// lualib.openlibs(fLuaState);
		}

		private static void PushGlobals()
		{
			luautils.PushGlobalString(fLuaState,  "LUA_VERSION_MAJOR",   lua.VERSION_MAJOR);
			luautils.PushGlobalString(fLuaState,  "LUA_VERSION_MINOR",   lua.VERSION_MINOR);
			luautils.PushGlobalInteger(fLuaState, "LUA_VERSION_NUM",     lua.VERSION_NUM);
			luautils.PushGlobalString(fLuaState,  "LUA_VERSION_RELEASE", lua.VERSION_RELEASE);
			luautils.PushGlobalString(fLuaState,  "LUA_VERSION",         lua.VERSION);
			luautils.PushGlobalString(fLuaState,  "LUA_RELEASE",         lua.RELEASE);
			luautils.PushGlobalString(fLuaState,  "LUA_COPYRIGHT",       lua.COPYRIGHT);
			luautils.PushGlobalString(fLuaState,  "LUA_AUTHORS",         lua.AUTHORS);
		}

		/* TODO: Custom alloc is broken, needs a working implementation. Throws "EXCEPTION_ACCESS_VIOLATION reading from 0xFFFFFFFF'FFFFFFFF" */
		private static void* l_alloc(void* ud, void* ptr, int osize, int nsize)
		{
			if (nsize == 0) {
				if (ptr != null)
					Internal.StdFree(ptr);

				return null;
			} else {
				if (ptr != null)
					Internal.StdFree(ptr);

				return Internal.StdMalloc(nsize);
			}
		}

		private static int l_print(lua_State* L)
 		{
			String sb = new .();

			for (int32 I = 1; I <= lua.gettop(L); I++) {
				if (lua.isboolean(L, I)) {
					if (lua.toboolean(L, I)) {
						sb.Append("True ");
					} else {
						sb.Append("False ");
					}
				} else {
					lua.tostring(L, I, sb);
					sb.Append(" ");
				}
			}

			Console.WriteLine(sb);
			delete sb;
			return 0;
		}
	}
}
