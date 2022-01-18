# -*- coding: utf-8 -*-
import os
import re
from collections import defaultdict

from setuptools import Extension, setup, find_packages
from setuptools.command.build_ext import build_ext
from Cython.Build import cythonize

BUILD_ARGS = defaultdict(lambda: ['-O3', '-g0'])

for compiler, args in [
    ('msvc', ['/EHsc', '/DHUNSPELL_STATIC', "/Oi", "/O2", "/Ot"]),
    ('gcc', ['-O3', '-g0'])]:
    BUILD_ARGS[compiler] = args


class build_ext_compiler_check(build_ext):
    def build_extensions(self):
        compiler = self.compiler.compiler_type
        args = BUILD_ARGS[compiler]
        for ext in self.extensions:
            ext.extra_compile_args = args
        super().build_extensions()


c_source = ["c-algorithms/src/" + file for file in os.listdir('c-algorithms/src') if file.endswith('c')]
pyx_source = ["pyalgorithms/" + file for file in os.listdir('pyalgorithms') if file.endswith('pyx')]

ext_modules = [
    Extension("pyalgorithms._core",
              sources=["pyalgorithms/_core.pyx"],
              language="c",
              library_dirs=["c-algorithms/src"],
              include_dirs=['c-algorithms/src/']),
    Extension("pyalgorithms.queue",
              sources=["pyalgorithms/queue.pyx", "c-algorithms/src/queue.c"],
              language="c",
              library_dirs=["c-algorithms/src"],
              include_dirs=['c-algorithms/src/']),
    Extension("pyalgorithms.trie",
              sources=["pyalgorithms/trie.pyx", "c-algorithms/src/trie.c"],
              language="c",
              library_dirs=["c-algorithms/src"],
              include_dirs=['c-algorithms/src/']),
    Extension("pyalgorithms.arraylist",
              sources=["pyalgorithms/arraylist.pyx", "c-algorithms/src/arraylist.c"],
              language="c",
              library_dirs=["c-algorithms/src"],
              include_dirs=['c-algorithms/src/']),
    Extension("pyalgorithms.sortedarray",
              sources=["pyalgorithms/sortedarray.pyx", "c-algorithms/src/sortedarray.c"],
              language="c",
              library_dirs=["c-algorithms/src"],
              include_dirs=['c-algorithms/src/']),
    Extension("pyalgorithms.utils",
              sources=["pyalgorithms/utils.pyx"],
              language="c")

]


def get_version() -> str:
    path = os.path.join(os.path.abspath(os.path.dirname(__file__)), "pyalgorithms", "__init__.py")
    with open(path, "r", encoding="utf-8") as f:
        data = f.read()
    result = re.findall(r"(?<=__version__ = \")\S+(?=\")", data)
    return result[0]


def get_dis():
    with open("README.markdown", "r", encoding="utf-8") as f:
        return f.read()


packages = find_packages(exclude=('test', 'tests.*', "test*"))


def main():
    version: str = get_version()

    dis = get_dis()
    setup(
        name="pyalgorithms",
        version=version,
        url="https://github.com/synodriver/pyalgorithms",
        packages=packages,
        keywords=["algorithms"],
        description="fast algorithms implements in C",
        long_description_content_type="text/markdown",
        long_description=dis,
        author="synodriver",
        author_email="diguohuangjiajinweijun@gmail.com",
        python_requires=">=3.6",
        install_requires=["cython"],
        license='GPLv3',
        ext_modules=cythonize(ext_modules, compiler_directives={"cdivision": False}),
        classifiers=[
            "Development Status :: 4 - Beta",
            "Operating System :: OS Independent",
            "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
            "Topic :: Security :: Cryptography",
            "Programming Language :: C",
            "Programming Language :: Cython",
            "Programming Language :: Python",
            "Programming Language :: Python :: 3.6",
            "Programming Language :: Python :: 3.7",
            "Programming Language :: Python :: 3.8",
            "Programming Language :: Python :: 3.9",
            "Programming Language :: Python :: 3.10",
            "Programming Language :: Python :: Implementation :: CPython"
        ],
        cmdclass={'build_ext': build_ext_compiler_check},
        include_package_data=True,
        zip_safe=False
    )


if __name__ == "__main__":
    main()
