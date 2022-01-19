# cython: language_level=3
from pyalgorithms import queue
from pyalgorithms cimport queue

Queue = queue.Queue

from pyalgorithms import trie
from pyalgorithms cimport trie

Trie = trie.Trie
TrieNotFound = trie.TrieNotFound

from pyalgorithms import arraylist
from pyalgorithms cimport arraylist

ArrayList = arraylist.ArrayList

from pyalgorithms import sortedarray
from pyalgorithms cimport sortedarray

SortedArray = sortedarray.SortedArray

from pyalgorithms import avltree
from pyalgorithms cimport avltree

AVLTree = avltree.AVLTree
AVLTreeNode = avltree.AVLTreeNode

from pyalgorithms import rbtree
from pyalgorithms cimport rbtree

RBTree = rbtree.RBTree
RBTreeNode = rbtree.RBTreeNode