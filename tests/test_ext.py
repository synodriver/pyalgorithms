"""
Copyright (c) 2008-2021 synodriver <synodriver@gmail.com>
"""
from unittest import TestCase

from pyalgorithms import Trie, TrieNotFound, ArrayList


class TestExt(TestCase):
    def setUp(self) -> None:
        self.trie = Trie()
        self.arr = ArrayList()

    def test_lookup_fail(self):
        try:
            self.trie.lookup("haha")
        except TrieNotFound:
            print("ok")

    def test_lookup(self):
        self.trie.insert("haha","haha的值")
        self.assertEqual(self.trie.lookup("haha"),"haha的值")

    def test_lookup_bin(self):
        try:
            self.trie.lookup_binary(b"haha")
        except TrieNotFound as e:
            print(e, type(e))
            print("ok")

    def test_arr(self):
        self.arr.append(123)
        self.arr.append(456)
        self.arr.remove(0)
        self.assertEqual(self.arr[0],456)


    def tearDown(self) -> None:
        pass
