#include "malloc.h"
#include <stdint.h>
#include <sys/mman.h>
#include <errno.h>
#include <stdio.h>

typedef struct blk_t 
{
  size_t prevFree:1;
  size_t prevSize:31;
  size_t free:1;
  size_t size:31;
  struct blk_t *prev;
  struct blk_t *next;
} blk_t, *Block;

struct {
  Block head;
  Block guard;
  void  *mem;
} Control = {NULL, NULL};

#define HEADER_SIZE  (2*sizeof(size_t))
#define ROUND_UP(x)  ((x + 0x3F) & (~0x3F))
#define MIN_SIZE     ROUND_UP(sizeof(blk_t))
#define PTR_ADD(x,y) ( (void *)( (intptr_t)(x) + (intptr_t)(y) ))
#define PTR_SUB(x,y) ( (void *)( (intptr_t)(x) - (intptr_t)(y) ))

Block PREV_BLOCK(Block x) 
{
  return (Block)PTR_SUB(x , x->prevSize);
}

Block NEXT_BLOCK(Block x){
  return (Block)PTR_ADD(x , x->size);
}

#ifdef TEST
int sanityTest(void);
#endif 

#define POOL_SIZE 0x100000
void init_malloc(void)
{
  Control.mem = mmap(NULL,
      POOL_SIZE, 
      PROT_READ|PROT_WRITE, 
      MAP_PRIVATE | MAP_ANONYMOUS,
      -1, 0); 

  if (!Control.mem)
    printf("%d\n", errno);
  Control.head = (Block)Control.mem;

  // Setup links
  Control.head->prev = NULL;
  Control.head->next = NULL;

  // Setup Sizes
  Control.head->size = POOL_SIZE - HEADER_SIZE; // Space for guard
  Control.head->prevSize = 0;

  // Setup Frees
  Control.head->free = 1;
  Control.head->prevFree = 0;

  // Setup Guard
  Control.guard = NEXT_BLOCK(Control.head);
  Control.guard->free = 0;
  Control.guard->size = 0;
  Control.guard->prevFree = 1;
  Control.guard->prevSize = Control.head->size;
}

int __attribute__ ((noinline)) isValidAddr(void *addr)
{
  return !(0x1 ^ ((intptr_t)addr >> 30));
}

void __attribute__ ((noinline)) unlink(Block blk)
{
  if (isValidAddr(blk->prev))
    blk->prev->next = blk->next;
  if (isValidAddr(blk->next))
    blk->next->prev = blk->prev;
}

void * splitBlk(Block blk, size_t blk_size)
{
  return blk;
}

void * s_malloc(size_t size) 
{
  Block blk = NULL;
  size_t blk_size = ROUND_UP(HEADER_SIZE + size);
  
#ifdef TEST
    sanityTest();
#endif 

  if (size <= 0)
    return NULL;

  if (NULL == Control.head)
  {
    init_malloc();
  } 
  blk = Control.head;

  do 
  {
    if (blk_size + MIN_SIZE <= blk->size)
    {
      // Split block current block 
      // add the remainder to the free list
      Block remainder = (Block)PTR_ADD(blk, blk_size);

      // We allocate the 
      remainder->prevFree = 0;
      remainder->free = 1;
      blk->free = 0;
      
      // Update the block sizes.
      remainder->size = blk->size - blk_size;
      remainder->prevSize = blk_size;
      blk->size = blk_size;

      // Update next block
      NEXT_BLOCK(remainder)->prevSize = remainder->size;

      // Update Links
      remainder->prev = blk->prev;
      remainder->next = blk->next;
      if (NULL != blk->prev)
        blk->prev->next = remainder;
      if (NULL != blk->next)
        blk->next->prev = remainder;

      if (Control.head == blk)
        Control.head = remainder;

#ifdef TEST
      sanityTest();
#endif 
      return PTR_ADD(blk, HEADER_SIZE);
    }
    else if (blk_size <= blk->size)
    {
      // Don't split, just return it
      NEXT_BLOCK(blk)->prevFree = 0;
      blk->free = 0;

      // Update pointers
      if (Control.head == blk)
        Control.head = blk->next;
      unlink(blk);
      

#ifdef TEST
      sanityTest();
#endif 
      return PTR_ADD(blk, HEADER_SIZE);
    }
    else {
      // Keep Looking
      blk = blk->next;
    }
  } while (blk != NULL);

  return NULL;
}

void s_free(void * b)
{
  Block blk = (Block)PTR_SUB(b,HEADER_SIZE);

  if (blk->free)
    return;

  // Look Forward
  Block nextBlk = NEXT_BLOCK(blk);
  if (nextBlk->free)
  {
    // We need to absorb next block into this block
    blk->size += nextBlk->size;
    unlink(nextBlk);
    if (Control.head == nextBlk)
      Control.head = nextBlk->next;
  }

  // Look Back
  if (blk->prevFree && blk->prevSize)
  {
    // Prev is free, merge this block into it, nothing else needs to change
    // there is already a block in the list
    Block prevBlk = PREV_BLOCK(blk);
    prevBlk->size += blk->size;
    unlink(prevBlk);

    if (Control.head == prevBlk)
      Control.head = prevBlk->next;
    blk = prevBlk;
  }

  nextBlk = NEXT_BLOCK(blk);
  nextBlk->prevSize = blk->size;
  nextBlk->prevFree = 1;

  // We are now adding a new block (or re-adding a merged block)
  blk->free = 1;
  blk->next = Control.head;
  blk->prev = NULL;
  

  if (Control.head)
    Control.head->prev = blk;
  Control.head = blk;
#ifdef TEST
  sanityTest();
#endif 
}


#ifdef TEST

#include <stdio.h>

void printPart(Block from, Block till)
{

}

int memWalker(void)
{
  if (!Control.mem)
    return 1;
  
  Block blk  = Control.mem;
  Block next = NULL;
  Block walker = NULL;

  if (blk->prevFree || blk->prevSize)
  {
    fprintf(stderr, "First block sizes wrong\n");
    return 0;
  }

  while (blk < Control.guard)
  {
    if (blk->size == 0)
    {
      fprintf(stderr, "Found empty sized block\n");
      return 0;
    }
    next = NEXT_BLOCK(blk);
    if (blk != PREV_BLOCK(next))
    {
      fprintf(stderr, "Mem Block sizes corruption detected\n");
      return 0;
    }

    if (blk->free)
    {
      walker = Control.mem;
      while (walker != blk)
      {
        if (walker == NULL)
        {
          fprintf(stderr, "Couldn't find free block in list\n");
          return 0;
        }
        walker = NEXT_BLOCK(walker);
      }

    }

    blk = next;
  }
  return 1;
}

int listWalker(void)
{
  if (!Control.head)
  {
    // Empty List
    return 1;
  }
  if (Control.head->prev)
  {
    fprintf(stderr, "Head->prev != NULL\n");
    return 0;
  }
 
  Block blk = Control.head;
  Block next = blk->next;
  Block walker = NULL;

  while (next != NULL)
  {
    if (next->prev != blk)
    {
      fprintf(stderr, "Detected bad reverse link @ %p <-> %p\n", blk, next);
      return 0;
    }
    
    walker = Control.head;
    while (walker != blk)
    {
      if (walker == next)
      {
        fprintf(stderr, "Detected Infinite Cycle: Forward\n");
        return 0;
      }
      walker = walker->next;
    }

    walker = blk;
    while (walker != Control.head)
    {
      if (walker == next)
      {
        fprintf(stderr, "Detected Infinite Cycle: Backward\n");
        return 0;
      }
      walker = walker->prev;
    }
    blk = next;
    next = blk->next;
  }
  return 1;
}

int sanityTest(void)
{
  if (!listWalker())
    return 0;
  if (!memWalker())
    return 0;
  return 1;
}

void printHeap(void)
{

}

void printList()
{

}

#endif // TEST
