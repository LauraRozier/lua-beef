#include <stdlib.h>

void *LSU_malloc(size_t size)
{
    return malloc(size);
}

void *LSU_realloc(void *ptr, size_t size)
{
    return realloc(ptr, size);
}

void LSU_free(void *ptr)
{
    free(ptr);
}
