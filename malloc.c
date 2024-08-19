#include <stddef.h>
#include "printf.h"
#include "types.h"

/*
    Note: Before we define symbols in mem.S, where we use `.word`, but we use uint32_t to access these symbols, which is wrong.
	We correct this by redefine these symbols in assembly, using `quad` instead of `word`.
	This way, we can use uint64_t to access these symbols. And works fine.
*/

extern const uint64_t HEAP_START;  // read-only
extern const uint64_t HEAP_SIZE;
extern const uint64_t TEXT_START;
extern const uint64_t TEXT_END;
extern const uint64_t DATA_START;
extern const uint64_t DATA_END;
extern const uint64_t BSS_START;
extern const uint64_t BSS_END;
extern const uint64_t RODATA_START;
extern const uint64_t RODATA_END;


void print_memory() {
	printf("TEXT_START: %p\n", (void *) TEXT_START);
	printf("TEXT_END: %p\n", (void *) TEXT_END);
	printf("DATA_START: %p\n", (void *) DATA_START);
	printf("DATA_END: %p\n", (void *) DATA_END);
	printf("RODATA_START: %p\n", (void *) RODATA_START);
	printf("RODATA_END: %p\n", (void *) RODATA_END);
	printf("BSS_START: %p\n", (void *) BSS_START);
	printf("BSS_END: %p\n", (void *) BSS_END);
}

/*
    The easiest way to implement malloc is to use a static array to store the
   blocks, but that would limit the number of blocks we can have.
*/

/*
    We can't declare a static array with a size that is not a constant, so we
   can't do this:
   static unsigned char heap[HEAP_SIZE];

    Here, HEAP_SIZE is a constant, but it is not a compile-time constant.
    (We can't know the value of HEAP_SIZE at compile time, only at link time)
    Reference to C99 standard: static must be initialized with a constant
   expression

*/
// static unsigned char heap[HEAP_SIZE];  // heap memory

static uint64_t _alloc_start = 0;
static uint64_t _alloc_end = 0;
static uint64_t _num_pages = 0;

#define PAGE_SIZE 4096

void print_memory_layout(){

}
/*
 * Page Descriptor
 * flags:
 * - 00: This means this page hasn't been allocated
 * - 01: This means this page was allocated
 * - 11: This means this page was allocated and is the last page of the memory
 * block allocated
 */


// we use 8 bits to represent the flags, so we can have 4 different states
// 00, 01, 10, 11

#define PAGE_TAKEN \
	(uint8_t) 0x01  // 0000 0001, use & to check if the page is taken
#define PAGE_LAST \
	(uint8_t) 0x02  // 0000 0010, use & to check if the page is the last

struct page {
	uint8_t flags;
};

void _clear(struct page *p) {
	p->flags = 0;
}

// return1 if the page is free, 0 otherwise
int _is_free(struct page *p) {
	if (p->flags & PAGE_TAKEN) {
		return 0;
	} else {
		return 1;
	}
}

// indicate if the page is the last page of the memory block
int _is_last(struct page *p) {
	if (p->flags & PAGE_LAST) {
		return 1;
	} else {
		return 0;
	}
}

void _set_flag(struct page *page, uint8_t flags) {
  page->flags |= flags;
}

uint64_t _alignment(uint64_t address) {
	// 4k alignment, 0xFFF = 1111 1111 1111
	// for example: 0x101D, 0x101D + 0xFFF = 0x201C, 0x201C & ~0xFFF = 0x2000
	return (address + 0xFFF) & ~0xFFF;
}


void page_init() {
	_alloc_start = _alignment(HEAP_START);
	_alloc_end = _alignment(HEAP_START + HEAP_SIZE);
	// clear all the pages, although we can't use memset here, we can use a loop
	// to clear all the pages

	// Note that we only clear BSS in start.S, so we need to clear the heap in C
	// run time
	struct page *p = (struct page *) _alloc_start;
	while (p != (struct page *) _alloc_end) {
		_clear(p);
		p++;
	}
	printf("Page init done\n");
	printf("TEXT: 0x%x  ->  0x%x\n", TEXT_START, TEXT_END);
	printf("DATA: 0x%x  ->  0x%x\n", DATA_START,
	       DATA_END);  // Note that we align the address to 4k, so the address
	                   // is not continuous
	printf("RODATA: 0x%x  ->  0x%x\n", RODATA_START, RODATA_END);
	printf("BSS: 0x%x  ->  0x%x\n", BSS_START, BSS_END);
	printf("HEAP: 0x%x  ->  0x%x\n", _alloc_start, _alloc_end);
}


// When returning a void*, it can be implicitly converted to any other pointer
void *malloc(unsigned int size) {
	int found = 0;
	struct page *p = (struct page *) _alloc_start;
	// malloc is a linear search, we can use a free list to speed up the search
	// TODO: implement a free list
	struct page *start = _alloc_start;
	while (p != (struct page *) _alloc_end) {
		if (_is_free(p)){
			struct page *start = p;
			found++;
			_set_flag(p, PAGE_TAKEN);
			while(found <= size){
				p++;
				if(_is_free(p)){
					found++;
					_set_flag(p, PAGE_TAKEN);
				}else{
					p++;
				}
			}
			// set the last page flag
			p--;
			_set_flag(p, PAGE_LAST);
			return (void *) start;
		}
		else {
			p++;
		}
	}
	return NULL;
}


void print_allocated_pages() {
	struct page *p = (struct page *) _alloc_start;
	struct page *start = NULL;
	int flag = 0;
	while(p != (struct page *) _alloc_end){
		if(!_is_free(p)){
			if (flag == 0){
				start = p;
				flag = 1;
			}
		}
		if (_is_last(p)){
			printf("Allocated pages: %p -> %p\n", (void *) start, (void *) p);
			flag = 0;
		}
		p++;
	}
	
}


void free(void *ptr){
	struct page *p = (struct page *) ptr;
	while(!_is_last(p)){
		_clear(p);
		p++;
	}
	_clear(p);
}