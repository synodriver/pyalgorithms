# cython: language_level=3
cdef extern from "avl-tree.h" nogil:
    ctypedef struct AVLTree:
        pass
    ctypedef void *AVLTreeKey
    ctypedef void *AVLTreeValue
    ctypedef struct AVLTreeNode:
        AVLTreeNode *children[2];
        AVLTreeNode *parent;
        AVLTreeKey key;
        AVLTreeValue value;
        int height;
    ctypedef enum AVLTreeNodeSide:
        AVL_TREE_NODE_LEFT = 0
        AVL_TREE_NODE_RIGHT = 1
    ctypedef int (*AVLTreeCompareFunc)(AVLTreeValue value1, AVLTreeValue value2)
    AVLTree *avl_tree_new(AVLTreeCompareFunc compare_func)
    void avl_tree_free(AVLTree *tree)

    AVLTreeNode *avl_tree_insert(AVLTree *tree, AVLTreeKey key,
                                 AVLTreeValue value)

    void avl_tree_remove_node(AVLTree *tree, AVLTreeNode *node)

    int avl_tree_remove(AVLTree *tree, AVLTreeKey key)
    AVLTreeNode *avl_tree_lookup_node(AVLTree *tree, AVLTreeKey key)
    AVLTreeValue avl_tree_lookup(AVLTree *tree, AVLTreeKey key)
    AVLTreeNode *avl_tree_root_node(AVLTree *tree)
    AVLTreeKey avl_tree_node_key(AVLTreeNode *node)
    AVLTreeValue avl_tree_node_value(AVLTreeNode *node)
    AVLTreeNode *avl_tree_node_child(AVLTreeNode *node, AVLTreeNodeSide side)
    AVLTreeNode *avl_tree_node_parent(AVLTreeNode *node)
    int avl_tree_subtree_height(AVLTreeNode *node)
    AVLTreeValue *avl_tree_to_array(AVLTree *tree)
    unsigned int avl_tree_num_entries(AVLTree *tree)



