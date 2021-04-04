//
// Created by orion on 11/16/20.
//

#include "include/linked_list.h"
#include <assert.h>
#include <iomanip>
#include <iostream>
void test1();
void test2();
void test3();
void test4();
void test5();
void test6();
void test7();

int main() {
  std::cout << "hello world!\n";
  std::cout.flush();
  char foo[] = "foo";
  char bar[] = "bar";
  char snafu[] = "snafu";
  std::cout << "Test case 1: pop become empty (size 1)...";
  std::cout.flush();
  test1();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 2: pop Left. (size 2)...";
  std::cout.flush();
  test2();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 3: pop Left. (size 3)...";
  std::cout.flush();

  test3();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 4: pop middle. (size 3)...";
  std::cout.flush();
  test4();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 5: pop right. (size 3)...";
  std::cout.flush();
  test5();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 6: pop right. (size 2)...";
  std::cout.flush();
  test6();
  std::cout << "passed!\n" <<std::endl;
  std::cout << "Test case 7: 'fo' is substring of 'foo'...";
  std::cout.flush();
  test7();
  std::cout << "passed!\n" <<std::endl;
  return 0;
}

void test1() {
  char foo[] = "foo";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  assert(LinkedList_len(list) == 1);
  auto result = LinkedList_pop_n(list, 0);
  assert(result == foo);
  assert(LinkedList_len(list) == 0);
  delete list;
}

void test2() {
  char foo[] = "foo";
  char bar[] = "bar";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  LinkedList_push(list, bar);
  assert(LinkedList_len(list) == 2);
  auto result = LinkedList_pop_n(list, 0);
  assert(result == foo);
  assert(LinkedList_len(list) == 1);
  assert(list->head->data == bar);
  delete list;
}
void test3(){
  char foo[] = "foo";
  char bar[] = "bar";
  char snafu[] = "snafu";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  LinkedList_push(list, bar);
  LinkedList_push(list, snafu);
  assert(LinkedList_len(list) == 3);
  auto result = LinkedList_pop_n(list, 0);
  assert(result == foo);
  assert(LinkedList_len(list) == 2);
  assert(list->head->data == bar);
  assert(list->head->next->data == snafu);


}


void test4(){
  char foo[] = "foo";
  char bar[] = "bar";
  char snafu[] = "snafu";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  LinkedList_push(list, bar);
  LinkedList_push(list, snafu);
  assert(LinkedList_len(list) == 3);
  auto result = LinkedList_pop_n(list, 1);
  assert(result == bar);
  assert(LinkedList_len(list) == 2);
  assert(list->head->data == foo);
  assert(list->head->next->data == snafu);


}

void test5(){
  char foo[] = "foo";
  char bar[] = "bar";
  char snafu[] = "snafu";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  LinkedList_push(list, bar);
  LinkedList_push(list, snafu);
  assert(LinkedList_len(list) == 3);
  auto result = LinkedList_pop_n(list, 2);
  assert(result == snafu);
  assert(LinkedList_len(list) == 2);
  assert(list->head->data == foo);
  assert(list->head->next->data == bar);
  assert(list->tail->data == bar);


}

void test6() {
  char foo[] = "foo";
  char bar[] = "bar";

  auto list = LinkedList();
  LinkedList_push(list, foo);
  LinkedList_push(list, bar);
  assert(LinkedList_len(list) == 2);
  auto result = LinkedList_pop_n(list, 1);
  assert(result == bar);
  assert(LinkedList_len(list) == 1);
  assert(list->head->data == foo);
}

void test7(){
  char superstring[] = "foo";
  char substring[] = "fo";

  bool result = is_substring(substring, superstring);
  assert(result);

}