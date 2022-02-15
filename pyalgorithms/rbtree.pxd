# cython: language_level=3
from pyalgorithms cimport c_rbtree

cdef class RBTree:
    cdef c_rbtree.RBTree * _ctree
    cdef object _compare_func   # callback
    cdef list strongrefs

    cpdef RBTreeNode insert(self, object key, object value)

    cpdef remove_node(self, RBTreeNode node)

    cpdef remove(self, object key)

    cpdef RBTreeNode lookup_node(self, object key)
    cpdef object lookup(self, object key)
    cpdef RBTreeNode root_node(self)
    cpdef int num_entries(self)

cdef class RBTreeNode:
    cdef c_rbtree.RBTreeNode * _cnode

    @staticmethod
    cdef RBTreeNode from_ptr(c_rbtree.RBTreeNode * node)

    cdef c_rbtree.RBTreeKey node_key(self)
    cdef c_rbtree.RBTreeValue node_value(self)
    cdef c_rbtree.RBTreeNode * node_child(self, c_rbtree.RBTreeNodeSide side)
    cdef c_rbtree.RBTreeNode * node_parent(self)
    cpdef int subtree_height(self)