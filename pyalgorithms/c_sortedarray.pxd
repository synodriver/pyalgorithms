# cython: language_level=3
cdef extern from "sortedarray.h" nogil:
    ctypedef void *SortedArrayValue
    ctypedef struct SortedArray
    ctypedef int (*SortedArrayEqualFunc)(SortedArrayValue value1,
                                    SortedArrayValue value2)
    ctypedef int (*SortedArrayCompareFunc)(SortedArrayValue value1,
                                      SortedArrayValue value2)
    SortedArrayValue *sortedarray_get(SortedArray *array, unsigned int i)
    unsigned int sortedarray_length(SortedArray *array)
    SortedArray *sortedarray_new(unsigned int length,
                                 SortedArrayEqualFunc equ_func,
                                 SortedArrayCompareFunc cmp_func)
    void sortedarray_free(SortedArray *sortedarray)
    void sortedarray_remove(SortedArray *sortedarray, unsigned int index)
    void sortedarray_remove_range(SortedArray *sortedarray, unsigned int index,
                                  unsigned int length)
    int sortedarray_insert(SortedArray *sortedarray, SortedArrayValue data)
    int sortedarray_index_of(SortedArray *sortedarray, SortedArrayValue data)
    void sortedarray_clear(SortedArray *sortedarray)