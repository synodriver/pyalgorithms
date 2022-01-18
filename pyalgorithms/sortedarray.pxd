# cython: language_level=3
from pyalgorithms cimport c_sortedarray

cdef class SortedArray:
    cdef c_sortedarray.SortedArray * _carray

    cpdef object  get(self, int i)

    cpdef remove_range(self,int index, unsigned int length)
    cpdef int insert(self, object data)
    cpdef int index_of(self, object data)
    cpdef clear(self)
