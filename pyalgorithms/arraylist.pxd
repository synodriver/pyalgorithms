# cython: language_level=3
from pyalgorithms cimport c_arraylist

cdef class ArrayList:
    cdef c_arraylist.ArrayList * _carraylist

    cpdef append(self, object data)
    cpdef extend(self, object datas)
    cpdef appendleft(self, object data)
    cpdef extendleft(self, object datas)
    cpdef remove(self, int index)
    cpdef remove_range(self, int index,
                             unsigned int length)

    cpdef int insert(self, int index,
                     object data)

    cpdef int index_of(self, object callback,
                       object data)

    cpdef clear(self)

    cpdef sort(self, object compare_func)
