# cxxlab

Caveat: **Only tested on macOS 14 Sonoma**

## Introduction

This project builds libc++ as a dependency. By default, the dependency is fulfilled by downloading the whole LLVM mono-repo from GitHub if `llvm-project.tar.gz` is not present at project source directory.

Setting `CXXLAB_LLVM_ARCHIVE` to the path to an archive of the LLVM mono-repo surppresses the default behavior and that archive is used instead.

The archive can be downloaded from https://github.com/llvm/llvm-project/archive/refs/heads/main.tar.gz or
if you have a local git repository do `git -C <PATH/TO/LLVM> archive --format=tar.gz -0 --prefix=llvm-project/ -o $(pwd)/llvm-project.tar.gz HEAD`

## Build instructions

### Prerequisites

* CMake 3.28

* Ninja 11.1

* Clang 18 (can be obtained via `brew install llvm` with [Homebrew](https://brew.sh) once [this PR](https://github.com/Homebrew/homebrew-core/pull/165206) is merged.)

If you're building Clang yourself, be sure to also build lld. (ninja -C <BUILD_DIR> clang llvm-cxxfilt llvm-libtool-darwin clang-scan-deps lld)

### Configure, Build, and Run the Program

If you have llvm installed via Homebrew on macOS:

```shell
cmake --preset macOS-static

ninja -C build/static-rel run-all
```

Otherwise:

```shell
cmake --preset default \
  -DCMAKE_CXX_COMPILER=path/to/clang++ \
  -DCMAKE_AR=path/to/llvm-ar \
  -DCMAKE_LIBTOOL=path/to/llvm-libtool-darwin

ninja -C build/static-rel run-all
```

`-DCMAKE_LIBTOOL=path/to/llvm-libtool-darwin` is only neede on macOS
