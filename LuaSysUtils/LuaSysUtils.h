#ifndef SYSUTILS_H_INCLUDED
#define SYSUTILS_H_INCLUDED

void *LSU_malloc(size_t size);
void *LSU_realloc(void *ptr, size_t size);
void LSU_free(void *ptr);

#endif // SYSUTILS_H_INCLUDED
