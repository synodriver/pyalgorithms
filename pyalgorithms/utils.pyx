# cython: language_level=3
cdef char* _chars(s):
    if isinstance(s, str):
        # encode to the specific encoding used inside of the module
        temp = s.encode('utf8')
    return <char*>temp