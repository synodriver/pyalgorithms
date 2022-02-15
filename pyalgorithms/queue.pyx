# cython: language_level=3
cimport cython
from cpython.ref cimport Py_INCREF, Py_DECREF
from cpython.object cimport PyObject

from pyalgorithms cimport c_queue

cdef class Queue:
    """A queue class for PyObject*.

    # [head tail]
    >>> q = Queue()
    >>> q.append(5)
    >>> q.peek()
    5
    >>> q.pop()
    5
    """
    # cdef c_queue.Queue* _cqueue
    def __cinit__(self):
        self._cqueue = c_queue.queue_new()
        if self._cqueue is NULL:
            raise MemoryError()

    def __dealloc__(self):
        self.clear()
        if self._cqueue is not NULL:
            c_queue.queue_free(self._cqueue)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef append(self, object value):
        if not c_queue.queue_push_tail(self._cqueue,
                                      <c_queue.QueueValue> value):
            raise MemoryError()
        Py_INCREF(value)
        self.len += 1
    # The `cpdef` feature is obviously not available for the original "extend()"
    # method, as the method signature is incompatible with Python argument
    # types (Python does not have pointers).  However, we can rename
    # the C-ish "extend()" method to e.g. "extend_ints()", and write
    # a new "extend()" method that provides a suitable Python interface by
    # accepting an arbitrary Python iterable.

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef appendleft(self, object value):
        if not c_queue.queue_push_head(self._cqueue,
                                       <c_queue.QueueValue> value):
            raise MemoryError()
        Py_INCREF(value)
        self.len += 1

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef extend(self, object values):
        for value in values:
            self.append(value)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef extendleft(self, object values):
        for value in values:
            self.appendleft(value)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object peek(self):
        cdef PyObject* value = <PyObject*> c_queue.queue_peek_tail(self._cqueue)

        if value is NULL:
            # this may mean that the queue is empty,
            # or that it happens to contain a 0 value
            if c_queue.queue_is_empty(self._cqueue):
                raise IndexError("Queue is empty")
        Py_INCREF(<object> value)
        return <object>value

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object peekleft(self):
        cdef PyObject* value = <PyObject*> c_queue.queue_peek_head(self._cqueue)
        if value is NULL:
            # this may mean that the queue is empty,
            # or that it happens to contain a 0 value
            if c_queue.queue_is_empty(self._cqueue):
                raise IndexError("Queue is empty")
        Py_INCREF(<object>value)
        return <object>value

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object pop(self):
        if c_queue.queue_is_empty(self._cqueue):
            raise IndexError("Queue is empty")
        cdef object value = <object> c_queue.queue_pop_tail(self._cqueue)
        self.len -= 1
        return value

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object popleft(self):
        if c_queue.queue_is_empty(self._cqueue):
            raise IndexError("Queue is empty")
        cdef object value = <object> c_queue.queue_pop_head(self._cqueue)
        self.len -= 1
        return value

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef bint empty(self):
        return c_queue.queue_is_empty(self._cqueue)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef clear(self):
        while not self.empty():
            item = self.pop()
            Py_DECREF(item)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __bool__(self):
        return not c_queue.queue_is_empty(self._cqueue)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __len__(self):
        return self.len