// NOTE : If you change this, first clean, then build.
#define USE_LUA54

#if USE_LUA54
using lua54_beef;
#else
using lua53_beef;
#endif

namespace lua_beef_test
{
	class TestModule
	{
	}
}
