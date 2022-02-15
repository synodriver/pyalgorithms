# cython: language_level=3
from pyalgorithms cimport c_avltree

cdef class AVLTree:
    cdef c_avltree.AVLTree * _ctree
    cdef object _cmpfunc
    cdef list strongrefs
    cpdef AVLTreeNode insert(self, object key, object value)

    cpdef remove_node(self, AVLTreeNode node)

    cpdef remove(self, object key)

    cpdef AVLTreeNode lookup_node(self, object key)

    cpdef object lookup(self, object key)

    cpdef AVLTreeNode root_node(self)

    cpdef list to_array(self)

    cdef unsigned int num_entries(self)

cdef class AVLTreeNode:
    cdef c_avltree.AVLTreeNode * _cnode

    @staticmethod
    cdef AVLTreeNode from_ptr(c_avltree.AVLTreeNode * node)

    cdef c_avltree.AVLTreeKey node_key(self)

    cdef c_avltree.AVLTreeValue node_value(self)

    cdef c_avltree.AVLTreeNode * node_child(self, c_avltree.AVLTreeNodeSide side)

    cdef c_avltree.AVLTreeNode * node_parent(self)

    cpdef int subtree_height(self)