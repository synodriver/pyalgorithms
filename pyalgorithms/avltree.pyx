cimport cython
from cpython.ref cimport Py_INCREF, Py_DECREF
from cpython.list cimport PyList_New, PyList_SET_ITEM

from pyalgorithms cimport c_avltree

cdef object _cmpfunc

cdef int avltreecomparefunc(c_avltree.AVLTreeValue value1, c_avltree.AVLTreeValue value2) with gil:
    return _cmpfunc(<object> value1, <object> value2)

cdef class AVLTree:
    def __cinit__(self, compare_func):
        self._ctree = c_avltree.avl_tree_new(<c_avltree.AVLTreeCompareFunc> avltreecomparefunc)
        if self._ctree is NULL:
            raise MemoryError()
        Py_INCREF(compare_func)
        self._cmpfunc = compare_func

    def __del__(self):
        Py_DECREF(self._cmpfunc)

    def __dealloc__(self):
        if self._ctree is not NULL:
            c_avltree.avl_tree_free(self._ctree)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef AVLTreeNode insert(self, object key, object value):
        cdef c_avltree.AVLTreeNode * node
        node = c_avltree.avl_tree_insert(self._ctree, <c_avltree.AVLTreeKey> key, <c_avltree.AVLTreeValue> value)
        if node is NULL:
            raise MemoryError()
        Py_INCREF(key)
        Py_INCREF(value)
        return AVLTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove_node(self, AVLTreeNode node):
        c_avltree.avl_tree_remove_node(self._ctree, node._cnode)
        Py_DECREF(<object> c_avltree.avl_tree_node_key((node._cnode)))
        Py_DECREF(<object> c_avltree.avl_tree_node_value(node._cnode))

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove(self, object key):
        cdef c_avltree.AVLTreeNode * node
        node = c_avltree.avl_tree_lookup_node(self._ctree, <c_avltree.AVLTreeKey> key)
        if node is NULL:
            raise ValueError("no entry with the given key is found")
        Py_DECREF(<object> c_avltree.avl_tree_node_key(node))
        Py_DECREF(<object> c_avltree.avl_tree_node_value(node))
        if not c_avltree.avl_tree_remove(self._ctree, <c_avltree.AVLTreeKey> key):
            raise ValueError("no node with the specified key was found in the tree")

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef AVLTreeNode lookup_node(self, object key):
        cdef c_avltree.AVLTreeNode * node
        node = c_avltree.avl_tree_lookup_node(self._ctree, <c_avltree.AVLTreeKey> key)
        if node is NULL:
            raise ValueError("no entry with the given key is found")
        return AVLTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object lookup(self, object key):
        cdef c_avltree.AVLTreeValue value
        value = c_avltree.avl_tree_lookup(self._ctree, <c_avltree.AVLTreeKey> key)
        if value is NULL:
            raise ValueError("no entry with the given key is found")
        return <object> value

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef AVLTreeNode root_node(self):
        cdef c_avltree.AVLTreeNode * node
        node = c_avltree.avl_tree_root_node(self._ctree)
        if node is NULL:
            return None
        return AVLTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef list to_array(self):
        cdef:
            unsigned int i
            unsigned int length = self.num_entries()
            c_avltree.AVLTreeValue * datas

        datas = c_avltree.avl_tree_to_array(self._ctree)
        ret = PyList_New(<Py_ssize_t> length)  # alloc directly so avoid realloc call
        for i in range(length):
            PyList_SET_ITEM(ret, <Py_ssize_t> i, <object> datas[i])
            Py_INCREF(<object> datas[i])
        return ret

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef unsigned int num_entries(self):
        return c_avltree.avl_tree_num_entries(self._ctree)

    def __len__(self):
        return self.num_entries()

cdef class AVLTreeNode:
    # cdef c_avltree.AVLTreeNode * _cnode
    @staticmethod
    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef AVLTreeNode from_ptr(c_avltree.AVLTreeNode * node):
        cdef AVLTreeNode self = AVLTreeNode()
        # should we call `cdef AVLTreeNode self = AVLTreeNode.__new__(AVLTreeNode)` to bypass __init__ ?
        # see https://cython.readthedocs.io/en/latest/src/userguide/extension_types.html#extension-types-and-none
        self._cnode = node
        return self

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_avltree.AVLTreeKey node_key(self):
        return c_avltree.avl_tree_node_key(self._cnode)

    @property
    def key(self):
        return <object> self.node_key()

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_avltree.AVLTreeValue node_value(self):
        return c_avltree.avl_tree_node_value(self._cnode)

    @property
    def value(self):
        return <object> self.node_value()

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_avltree.AVLTreeNode * node_child(self, c_avltree.AVLTreeNodeSide side):
        return c_avltree.avl_tree_node_child(self._cnode, side)

    @property
    def leftchild(self):
        cdef c_avltree.AVLTreeNode * node
        node = self.node_child(c_avltree.AVL_TREE_NODE_LEFT)
        if node is NULL:
            return None
        return AVLTreeNode.from_ptr(node)

    @property
    def rightchild(self):
        cdef c_avltree.AVLTreeNode * node
        node = self.node_child(c_avltree.AVL_TREE_NODE_RIGHT)
        if node is NULL:
            return None
        return AVLTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_avltree.AVLTreeNode * node_parent(self):
        return c_avltree.avl_tree_node_parent(self._cnode)

    @property
    def parent(self):
        cdef c_avltree.AVLTreeNode * node
        node = self.node_parent()
        if node is NULL:
            return None
        return AVLTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int subtree_height(self):
        return c_avltree.avl_tree_subtree_height(self._cnode)
