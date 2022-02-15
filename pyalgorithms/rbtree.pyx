# cython: language_level=3
cimport cython
from cpython.ref cimport Py_INCREF, Py_DECREF

from pyalgorithms cimport c_rbtree

cdef object _cmp_func

cdef int rbtreecomparefunc(c_rbtree.RBTreeValue data1, c_rbtree.RBTreeValue data2) with gil:
    return _cmp_func(<object> data1, <object> data2)

cdef class RBTree:
    def __cinit__(self, object compare_func):
        self._ctree = c_rbtree.rb_tree_new(rbtreecomparefunc)
        if self._ctree is NULL:
            raise MemoryError()
        Py_INCREF(compare_func)
        self._compare_func = compare_func
        self.strongrefs = []

    def __dealloc__(self):
        self.strongrefs.clear()
        if self._ctree is not NULL:
            c_rbtree.rb_tree_free(self._ctree)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef RBTreeNode insert(self, object key, object value):
        _cmp_func = self._compare_func
        cdef c_rbtree.RBTreeNode * node
        node = c_rbtree.rb_tree_insert(self._ctree, <c_rbtree.RBTreeKey> key, <c_rbtree.RBTreeValue> value)
        if node is NULL:
            raise MemoryError()
        self.strongrefs.append(key)
        self.strongrefs.append(value)
        return RBTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove_node(self, RBTreeNode node):
        _cmp_func = self._compare_func
        self.strongrefs.remove(<object> c_rbtree.rb_tree_node_key(node._cnode))
        self.strongrefs.remove(<object> c_rbtree.rb_tree_node_value(node._cnode))
        c_rbtree.rb_tree_remove_node(self._ctree, node._cnode)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove(self, object key):
        _cmp_func = self._compare_func
        cdef c_rbtree.RBTreeNode *node
        node = c_rbtree.rb_tree_lookup_node(self._ctree, <c_rbtree.RBTreeKey> key)
        if node is NULL:
            raise ValueError("no entry with the given key is found.")
        if not c_rbtree.rb_tree_remove(self._ctree, <c_rbtree.RBTreeKey> key):
            raise ValueError("no node with the specified key was found in the tree")
        self.strongrefs.remove(<object> c_rbtree.rb_tree_node_key(node))
        self.strongrefs.remove(<object> c_rbtree.rb_tree_node_value(node))

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef RBTreeNode lookup_node(self, object key):
        _cmp_func = self._compare_func
        cdef c_rbtree.RBTreeNode *node
        node = c_rbtree.rb_tree_lookup_node(self._ctree, <c_rbtree.RBTreeKey> key)
        if node is NULL:
            raise ValueError("no entry with the given key is found.")
        Py_INCREF(<object> c_rbtree.rb_tree_node_key(node))
        Py_INCREF(<object> c_rbtree.rb_tree_node_value(node))
        return RBTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object lookup(self, object key):
        _cmp_func = self._compare_func
        cdef c_rbtree.RBTreeValue data
        data = c_rbtree.rb_tree_lookup(self._ctree, <c_rbtree.RBTreeKey> key)
        if data is NULL:
            raise ValueError("no entry with the given key is found.")
        Py_INCREF(<object> data)
        return <object> data

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef RBTreeNode root_node(self):
        _cmp_func = self._compare_func
        cdef c_rbtree.RBTreeNode *node
        node = c_rbtree.rb_tree_root_node(self._ctree)
        if node is NULL:
            return None
        Py_INCREF(<object> c_rbtree.rb_tree_node_key(node))
        Py_INCREF(<object> c_rbtree.rb_tree_node_value(node))
        return RBTreeNode.from_ptr(node)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int num_entries(self):
        _cmp_func = self._compare_func
        return c_rbtree.rb_tree_num_entries(self._ctree)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __len__(self):
        return self.num_entries()

cdef class RBTreeNode:
    @staticmethod
    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef RBTreeNode from_ptr(c_rbtree.RBTreeNode * node):
        cdef RBTreeNode self = RBTreeNode()
        self._cnode = node
        return self

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_rbtree.RBTreeKey node_key(self):
        return c_rbtree.rb_tree_node_key(self._cnode)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef  c_rbtree.RBTreeValue node_value(self):
        return c_rbtree.rb_tree_node_value(self._cnode)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_rbtree.RBTreeNode * node_child(self, c_rbtree.RBTreeNodeSide side):
        return c_rbtree.rb_tree_node_child(self._cnode, side)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cdef c_rbtree.RBTreeNode * node_parent(self):
        return c_rbtree.rb_tree_node_parent(self._cnode)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int subtree_height(self):
        return 1   # todo https://github.com/fragglet/c-algorithms/issues/33
        # return c_rbtree.rb_tree_subtree_height(self._cnode)

    @property
    def key(self):
        ret = <object>self.node_key()
        Py_INCREF(ret)
        return ret

    @property
    def value(self):
        ret = <object>self.node_value()
        Py_INCREF(ret)
        return ret

    @property
    def leftchild(self):
        cdef c_rbtree.RBTreeNode * node
        node = self.node_child(c_rbtree.RB_TREE_NODE_LEFT)
        if node is NULL:
            return None
        Py_INCREF(<object> c_rbtree.rb_tree_node_key(node))
        Py_INCREF(<object> c_rbtree.rb_tree_node_value(node))
        return RBTreeNode.from_ptr(node)

    @property
    def rightchild(self):
        cdef c_rbtree.RBTreeNode * node
        node = self.node_child(c_rbtree.RB_TREE_NODE_RIGHT)
        if node is NULL:
            return None
        Py_INCREF(<object> c_rbtree.rb_tree_node_key(node))
        Py_INCREF(<object> c_rbtree.rb_tree_node_value(node))
        return RBTreeNode.from_ptr(node)

    @property
    def parent(self):
        cdef c_rbtree.RBTreeNode * node
        node = self.node_parent()
        if node is NULL:
            return None
        Py_INCREF(<object> c_rbtree.rb_tree_node_key(node))
        Py_INCREF(<object> c_rbtree.rb_tree_node_value(node))
        return RBTreeNode.from_ptr(node)