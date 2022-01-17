# cython: language_level=3
cdef extern from "arraylist.h" nogil:
    ctypedef void *ArrayListValue
    ctypedef struct ArrayList:
        ArrayListValue *data
        unsigned int length
        unsigned int _alloced
    ctypedef int (*ArrayListEqualFunc)(ArrayListValue value1, ArrayListValue value2)
    ctypedef int (*ArrayListCompareFunc)(ArrayListValue value1, ArrayListValue value2)
    ArrayList *arraylist_new(unsigned int length)
    void arraylist_free(ArrayList *arraylist)
    int arraylist_append(ArrayList *arraylist, ArrayListValue data)
    int arraylist_prepend(ArrayList *arraylist, ArrayListValue data)
    void arraylist_remove(ArrayList *arraylist, unsigned int index)
    void arraylist_remove_range(ArrayList *arraylist, unsigned int index,
                                unsigned int length)

    int arraylist_insert(ArrayList *arraylist, unsigned int index,
                         ArrayListValue data)

    int arraylist_index_of(ArrayList *arraylist,
                           ArrayListEqualFunc callback,
                           ArrayListValue data)

    void arraylist_clear(ArrayList *arraylist)

    void arraylist_sort(ArrayList *arraylist, ArrayListCompareFunc compare_func)





