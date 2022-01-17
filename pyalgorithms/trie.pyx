# cython: language_level=3
cimport cython
from cpython.ref cimport Py_INCREF, Py_DECREF
from cpython.object cimport PyObject

from pyalgorithms cimport c_trie
from pyalgorithms cimport utils
from pyalgorithms import utils

class TrieNotFound(Exception):
    pass


cdef class Trie:
    # cdef c_trie.Trie * _ctrie
    def __cinit__(self):
        self._ctrie = c_trie.trie_new()
        if self._ctrie is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._ctrie is not NULL:
            c_trie.trie_free(self._ctrie)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef insert(self, key,object value):
        cdef char* key_c = utils._chars(key)
        if not c_trie.trie_insert(self._ctrie,key_c,<c_trie.TrieValue>value):
            raise MemoryError()
        Py_INCREF(value)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef insert_binary(self, const unsigned char[:] key, object value):
        if not c_trie.trie_insert_binary(self._ctrie,&key[0], <int>key.shape[0],<c_trie.TrieValue>value):
            raise TrieNotFound("not found in the trie")
        Py_INCREF(value)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object lookup(self, key):
        cdef char* key_c = utils._chars(key)
        cdef PyObject* value = <PyObject*> c_trie.trie_lookup(self._ctrie,key_c)
        if value is NULL:
            raise TrieNotFound("not found in the trie")
        cdef object pyvalue = <object> value
        return pyvalue

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef object lookup_binary(self, const unsigned char[:] key):
        cdef PyObject* value = <PyObject*> c_trie.trie_lookup_binary(self._ctrie,&key[0], <int>key.shape[0])
        if value is NULL:
            raise TrieNotFound("not found in the trie")
        cdef object pyvalue = <object> value
        return pyvalue

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove(self, key):
        cdef char* key_c = utils._chars(key)
        cdef PyObject * value = <PyObject *> c_trie.trie_lookup(self._ctrie, key_c)
        if value is NULL:
            raise TrieNotFound("not found in the trie")
        Py_DECREF(<object>value)
        if not c_trie.trie_remove(self._ctrie, key_c):
            raise TrieNotFound("not found in the trie")

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef remove_binary(self, const unsigned char[:] key):
        cdef PyObject * value = <PyObject *> c_trie.trie_lookup_binary(self._ctrie, &key[0],<int> key.shape[0])
        if value is NULL:
            raise TrieNotFound("not found in the trie")
        Py_DECREF(<object> value)
        if not c_trie.trie_remove_binary(self._ctrie,  &key[0], <int> key.shape[0]):
            raise TrieNotFound("not found in the trie")

    @cython.wraparound(False)
    @cython.boundscheck(False)
    cpdef int num_entries(self):
        return c_trie.trie_num_entries(self._ctrie)

    @cython.wraparound(False)
    @cython.boundscheck(False)
    def __len__(self):
        return c_trie.trie_num_entries(self._ctrie)
