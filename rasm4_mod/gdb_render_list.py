import gdb
import attr
import ast
from loguru import logger

GET_LINKED_LIST_DATA = "(*{ptr}@2)"
GET_NODE_DATA = "(*{ptr}@3)"

# we need a char ptr type
CharPtr = gdb.lookup_type("char").pointer()


def convert_gdb_list(result):
    result = result.replace("{", "[").replace("}", "]")
    result = result[result.find("["): result.find("\n")]
    result = ast.literal_eval(result)
    return result


def convert_gdb_string(data: str) -> str:
    data = data[data.find('"'): data.rfind('"') + 1]
    return ast.literal_eval(data)


@attr.dataclass
class Node:
    """
    // struct Node {
    //  Char *data
    //  Node *next
    //  Node *previous
    //
    """

    data: str
    """ pointer to a char array """
    next: int
    """ pointer to next node """
    previous: int
    """ pointer to previous node """

    @classmethod
    def from_ptr(cls, ptr: int):
        # fetch the node's data
        cmd = GET_NODE_DATA.format(ptr=ptr)
        result = gdb.parse_and_eval(cmd)
        # the first word is a pointer to a c-string
        # so we need to re-interpret it as a char* and invoke .string() to recover
        # the actual data.
        data_str = result[0].reinterpret_cast(CharPtr).string()

        return cls(data=data_str, next=result[1], previous=result[2])

    def pretty(self) -> str:
        data = attr.asdict(self)
        data["next"] = str(data["next"])
        data["previous"] = str(data["previous"])
        return str(data)


@attr.dataclass
class LinkedList:
    """
    struct LinkedList{
    *Node head;
    *Node tail;
    }
    """

    head: Node
    """ Pointer to head node """
    tail: Node
    """ Pointer to tail node """
    len: int
    """ total nodes """

    @classmethod
    def from_ptr(cls, head: int, tail: int, size: int):
        head_data = Node.from_ptr(head)
        tail_data = Node.from_ptr(tail)
        return cls(head=head_data, tail=tail_data, len=size)


def init_linked_list(ptr):
    cmd = GET_LINKED_LIST_DATA.format(ptr=ptr)
    result = gdb.parse_and_eval(cmd)
    linked_list_struct = LinkedList.from_ptr(int(result[0]), int(result[1]),
                                             int(result[2]))

    return linked_list_struct


class RenderLinkedList(gdb.Command):
    def __init__(self):
        super(RenderLinkedList, self).__init__("render_ll", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        try:
            linked_list = init_linked_list(arg)

            gdb.write(f"LinkedList at {arg} with size {linked_list.len} :: [")

            current_node = linked_list.head
            while True:
                # while a next node exists.
                gdb.write(repr(current_node.data))
                gdb.write(", ")
                if current_node.next == 0:
                    break
                current_node = Node.from_ptr(int(current_node.next))
            gdb.write("]\n")
        except:
            logger.exception("failed.")
            raise


class RenderNode(gdb.Command):
    def __init__(self):
        super(RenderNode, self).__init__("view_node", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        node = Node.from_ptr(arg)
        print(node.pretty())


RenderLinkedList()
RenderNode()
