//
// Created by orion on 11/16/20.
//

#ifndef CS3B_LINKED_LIST_H
#define CS3B_LINKED_LIST_H
#include <cstddef>

extern "C" struct Node {
  char *data;
  Node *next;
  Node *prev;
};
extern "C" struct LinkedList_t {
  Node *head;
  Node *tail;
  size_t len;
};
/// Allocates a new LinkedList
extern "C" LinkedList_t *LinkedList();
/// pushes `data` to the linked list
extern "C" LinkedList_t *LinkedList_push(LinkedList_t *, char *data);
/// returns the length of the linked list
extern "C" size_t LinkedList_len(LinkedList_t *);
/// pops a node from the LL
extern "C" char* LinkedList_pop_n(LinkedList_t*, size_t n);

extern "C" bool is_substring(char *substring , char *superstring);

#endif // CS3B_LINKED_LIST_H
