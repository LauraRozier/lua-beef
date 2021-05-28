using System;

namespace lua53_beef
{
	public abstract class LuaSysUtils
	{
		[LinkName("LSU_malloc")]
		public extern static void* Malloc(size_t size);
		[LinkName("LSU_realloc")]
		public extern static void* Realloc(void* ptr, size_t size);
		[LinkName("LSU_free")]
		public extern static void Free(void* ptr);
	}
}
