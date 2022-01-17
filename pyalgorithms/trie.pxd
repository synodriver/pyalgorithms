# cython: language_level=3
from pyalgorithms cimport c_trie

cdef class Trie:
    cdef c_trie.Trie * _ctrie

    cpdef insert(self, key, object value)

    cpdef insert_binary(self, const unsigned char[:] key, object value)

    cpdef object lookup(self, key)

    cpdef object lookup_binary(self, const unsigned char[:] key)

    cpdef remove(self, key)

    cpdef remove_binary(self,const unsigned char[:] key)

    cpdef int num_entries(self)
