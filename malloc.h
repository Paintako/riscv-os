#ifndef __MALLOC_H
#define __MALLOC_H

void *malloc(unsigned int num_bytes);
void *realloc(void *ptr, size_t size);
void free(void *ptr);
void print_memory();
void print_allocated_pages();

#endif