
#include <bsp.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "s_malloc.h"

typedef struct node *Node;
struct node
{
  size_t size;
  Node next;
} node_t;

Node alloc()
{
  size_t size = sizeof(node_t) + (rand() % 0x4000);
  Node n = (Node)s_malloc(size);
  
  if (!n) 
    return NULL;
  memset(n, 0xFF, size);
  n->size = size - (sizeof(node_t));
  return n;
}

void dealloc(Node n)
{
  size_t size = n->size;
  memset(n, 0x00, size);
  s_free(n);
}

void checkData(Node data)
{
  Node walker = data;
  do 
  {
    char *ptr = ((char *)walker) + sizeof(node_t);
    char *end = ptr + walker->size;
    for (; ptr != end; ptr++)
    {
      if (*ptr != '\xFF')
      {
        fprintf(stderr, "User Data Corrupted\n");
        return;
      }
    }
  } while (walker != data);
}

rtems_task Init(
  rtems_task_argument ignored
)
{
  int total = 0;
  srand(time(0));
  // Start with a circular linked list
  Node head  = s_malloc(sizeof(node_t));
  head->next = head;

  for (int ii = 0; ii < 100000; ii ++) 
  {
    int mallocCount = 1 + (rand() % 25);
    for (int jj = 0; jj < mallocCount; jj++)
    {
      Node next = (Node)alloc();
      if (next)
      {
        next->next = head->next;
        head->next = next;
        total++;
      }
      checkData(head);
    }

    int freeCount = rand() % total;
    if (freeCount == total)
      freeCount = total - 1;
    for (int jj = 0; jj < freeCount; jj++)
    {
      int steps = rand() % 10;
      Node prev = head;
      Node next = head->next;
      for (int kk = 0; kk < steps; kk++)
      {
        prev = next;
        next = next->next;
      }
      prev->next = next->next;
      dealloc(next);
      total--;
      head = prev;
      checkData(head);
    }
  }
  exit(0);
}

/* configuration information */

#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
//#define CONFIGURE_APPLICATION_DOES_NOT_NEED_CLOCK_DRIVER

#define CONFIGURE_RTEMS_INIT_TASKS_TABLE

#define CONFIGURE_MAXIMUM_TASKS 1

#define CONFIGURE_INIT
#include <rtems/confdefs.h>
/* end of file */
