# cython: language_level=3
cimport cython

from pyalgorithms cimport c_arraylist

from cpython.ref cimport Py_INCREF, Py_DECREF

cdef object _equalfunc
cdef object _comparefunc

cdef int arraylistcomparefunc(c_arraylist.ArrayListValue value1, c_arraylist.ArrayListValue value2) with gil:
    return _comparefunc(<object> value1, <object> value2)

cdef int arraylistequalfunc(c_arraylist.ArrayListValue value1, c_arraylist.ArrayListValue value2) with gil:
    return _equalfunc(<object> value1, <object> value2)

cdef class ArrayList:
    """
    #[start, end]

    """
    def __cinit__(self, unsigned int len = 0):
        self._carraylist = c_arraylist.arraylist_new(len)
        if self._carraylist is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._carraylist is not NULL:
            c_arraylist.arraylist_free(self._carraylist)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef append(self, object data):
        if not c_arraylist.arraylist_append(self._carraylist, <c_arraylist.ArrayListValue> data):
            raise MemoryError()
        Py_INCREF(data)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef extend(self, object datas):
        for data in datas:
            self.append(data)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef appendleft(self, object data):
        if not c_arraylist.arraylist_prepend(self._carraylist, <c_arraylist.ArrayListValue> data):
            raise MemoryError()
        Py_INCREF(data)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef extendleft(self, object datas):
        for data in datas:
            self.appendleft(data)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove(self, int index):
        if index < 0:
            index = self._carraylist.length + index
        if index < 0 or <unsigned int>index > self._carraylist.length - 1:
            raise IndexError("index out of range")
        Py_DECREF(<object> self._carraylist.data[index])
        c_arraylist.arraylist_remove(self._carraylist, <unsigned int> index)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove_range(self, int index, unsigned int length):
        if index < 0:
            index = self._carraylist.length + index
        if index < 0 or <unsigned int>index > self._carraylist.length - length:
            raise IndexError("index out of range")
        cdef unsigned int i
        for i in range(index, index + length):
            Py_DECREF(<object> self._carraylist.data[i])
        c_arraylist.arraylist_remove_range(self._carraylist, <unsigned int> index, length)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int insert(self, int index, object data):
        if index < 0:
            index = self._carraylist.length + index
        if index < 0 or <unsigned int>index > self._carraylist.length - 1:
            raise IndexError("index out of range")
        if not c_arraylist.arraylist_insert(self._carraylist, <unsigned int> index, <c_arraylist.ArrayListValue> data):
            raise MemoryError()
        Py_INCREF(data)


    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int index_of(self, object callback, object data):
        cdef int ret
        _equalfunc = callback
        Py_INCREF(callback)
        try:
            ret = c_arraylist.arraylist_index_of(self._carraylist,<c_arraylist.ArrayListEqualFunc> arraylistequalfunc,
                                                     <c_arraylist.ArrayListValue> data)
            if ret == -1:
                raise IndexError("not found")
            return ret
        finally:
            Py_DECREF(callback)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef clear(self):
        cdef unsigned int i
        for i in range(self._carraylist.length):
            Py_DECREF(<object> self._carraylist.data[i])
        c_arraylist.arraylist_clear(self._carraylist)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef sort(self, object compare_func):
        _comparefunc = compare_func
        Py_INCREF(compare_func)
        try:
            c_arraylist.arraylist_sort(self._carraylist,<c_arraylist.ArrayListCompareFunc>arraylistcomparefunc)
        finally:
            Py_DECREF(compare_func)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __len__(self):
        return self._carraylist.length

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __getitem__(self, int item):
        if item < 0:
            item = self._carraylist.length + item
        if item < 0 or <unsigned int>item > self._carraylist.length - 1:
            raise IndexError("index out of range")
        return <object> self._carraylist.data[item]

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __setitem__(self, int key, object value):
        if key < 0:
            key = self._carraylist.length + key
        if key < 0 or <unsigned int>key > self._carraylist.length - 1:
            raise IndexError("index out of range")
        Py_DECREF(<object> self._carraylist.data[key])
        self._carraylist.data[key] = <c_arraylist.ArrayListValue> value
        Py_INCREF(<object> self._carraylist.data[key])

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __delitem__(self, key):
        self.remove(key)
