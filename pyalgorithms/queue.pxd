# cython: language_level=3
from pyalgorithms cimport c_queue

cdef class Queue:
    cdef c_queue.Queue * _cqueue
    cdef Py_ssize_t len

    cpdef append(self, object value)

    cpdef appendleft(self, object value)

    cpdef extend(self, object values)

    cpdef extendleft(self, object values)

    cpdef object peek(self)

    cpdef object peekleft(self)

    cpdef object pop(self)

    cpdef object popleft(self)

    cpdef bint empty(self)

    cpdef clear(self)