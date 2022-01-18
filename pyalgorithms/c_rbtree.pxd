# cython: language_level=3
cdef extern from "rb-tree.h" nogil:
    ctypedef struct  RBTree:
        pass
    ctypedef void *RBTreeKey
    ctypedef void *RBTreeValue
    ctypedef struct RBTreeNode:
        pass
    ctypedef int (*RBTreeCompareFunc)(RBTreeValue data1, RBTreeValue data2)
    ctypedef enum RBTreeNodeColor:
        RB_TREE_NODE_RED
        RB_TREE_NODE_BLACK
    ctypedef enum RBTreeNodeSide:
        RB_TREE_NODE_LEFT = 0
        RB_TREE_NODE_RIGHT = 1

    RBTree *rb_tree_new(RBTreeCompareFunc compare_func)
    void rb_tree_free(RBTree *tree)
    RBTreeNode *rb_tree_insert(RBTree *tree, RBTreeKey key, RBTreeValue value)
    void rb_tree_remove_node(RBTree *tree, RBTreeNode *node)
    int rb_tree_remove(RBTree *tree, RBTreeKey key)
    RBTreeNode *rb_tree_lookup_node(RBTree *tree, RBTreeKey key)
    RBTreeValue rb_tree_lookup(RBTree *tree, RBTreeKey key)

    RBTreeNode *rb_tree_root_node(RBTree *tree)
    RBTreeKey rb_tree_node_key(RBTreeNode *node)
    RBTreeValue rb_tree_node_value(RBTreeNode *node)
    RBTreeNode *rb_tree_node_child(RBTreeNode *node, RBTreeNodeSide side)
    RBTreeNode *rb_tree_node_parent(RBTreeNode *node)
    # int rb_tree_subtree_height(RBTreeNode *node)
    RBTreeValue *rb_tree_to_array(RBTree *tree)
    int rb_tree_num_entries(RBTree *tree)






