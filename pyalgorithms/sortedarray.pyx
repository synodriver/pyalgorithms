# cython: language_level=3
cimport cython
from cpython.ref cimport Py_INCREF, Py_DECREF

from pyalgorithms cimport c_sortedarray

cdef object _equ_func  # dynamic seted when used
cdef object _cmp_func

cdef int sortedarrayequalfunc(c_sortedarray.SortedArrayValue value1, c_sortedarray.SortedArrayValue value2) with gil:
    return _equ_func(<object> value1, <object> value2)

cdef int sortedarraycomparefunc(c_sortedarray.SortedArrayValue value1, c_sortedarray.SortedArrayValue value2) with gil:
    return _cmp_func(<object> value1, <object> value2)

cdef class SortedArray:
    def __cinit__(self, unsigned int length, object equ_func, object cmp_func):
        Py_INCREF(equ_func)
        Py_INCREF(cmp_func)
        self._equ_func = equ_func
        self._cmp_func = cmp_func
        self._carray = c_sortedarray.sortedarray_new(length, sortedarrayequalfunc, sortedarraycomparefunc)
        if self._carray is NULL:
            raise MemoryError()

    def __del__(self):
        Py_DECREF(self._equ_func)
        Py_DECREF(self._cmp_func)


    def __dealloc__(self):
        if self._carray is not NULL:
            c_sortedarray.sortedarray_free(self._carray)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object  get(self, int i):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        cdef c_sortedarray.SortedArrayValue * ret
        if i < 0:
            i = len(self) + i
        if i < 0 or <unsigned int> i > len(self) - 1:
            raise IndexError("index out of range")
        ret = c_sortedarray.sortedarray_get(self._carray, <unsigned int> i)
        if ret is NULL:
            raise IndexError("index out of range")
        return <object> ret[0]

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __getitem__(self, int i):
        return self.get(i)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __len__(self):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        return c_sortedarray.sortedarray_length(self._carray)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __delitem__(self, int index):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        Py_DECREF(self.get(index))
        c_sortedarray.sortedarray_remove(self._carray, <unsigned int> index)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef  remove_range(self, int index, unsigned int length):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        cdef int i
        for i in range(i, i + length):
            Py_DECREF(self.get(i))
        c_sortedarray.sortedarray_remove_range(self._carray, <unsigned int> index, length)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int insert(self, object data):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        if not c_sortedarray.sortedarray_insert(self._carray, <c_sortedarray.SortedArrayValue> data):
            raise MemoryError()
        Py_INCREF(data)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int index_of(self, object data):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        cdef int ret
        ret = c_sortedarray.sortedarray_index_of(self._carray, <c_sortedarray.SortedArrayValue> data)
        if ret == -1:
            raise ValueError("the value is not found")
        return ret

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef clear(self):
        _equ_func, _cmp_func = self._equ_func, self._cmp_func
        cdef int i
        for i in range(len(self)):
            Py_DECREF(self.get(i))
        c_sortedarray.sortedarray_clear(self._carray)
