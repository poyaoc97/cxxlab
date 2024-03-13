# Set up libcxx and libcxxabi
set(CXXLAB_LLVM_ARCHIVE_DEFAULT llvm-project.tar.gz CACHE INTERNAL "")
set(CXXLAB_LLVM_ARCHIVE ${CXXLAB_LLVM_ARCHIVE_DEFAULT} CACHE STRING "\
Path to an archive of the LLVM mono-repo. This can be downloaded from GitHub via\
https://github.com/llvm/llvm-project/archive/refs/heads/main.{zip,tar.gz} or\
obtained from \"git -C <path/to/llvm-project> archive --format=tar.gz -0 --prefix=llvm-project/\
 -o $(pwd)/llvm-project.tar.gz HEAD\". See https://git-scm.com/docs/git-archive for more.")

include(FetchContent)
if(EXISTS ${PROJECT_SOURCE_DIR}/${CXXLAB_LLVM_ARCHIVE})
  message(STATUS "Extracting ${PROJECT_SOURCE_DIR}/${CXXLAB_LLVM_ARCHIVE}")
  FetchContent_Declare(
    llvm-project
    URL file://${PROJECT_SOURCE_DIR}/${CXXLAB_LLVM_ARCHIVE}
    SOURCE_SUBDIR runtimes
    EXCLUDE_FROM_ALL
    SYSTEM)
else()
  message(STATUS "Downloading llvm-project, this may take a while.")
  FetchContent_Declare(
    llvm-project
    URL https://github.com/llvm/llvm-project/archive/6d3cec01a6c29fa4e51ba129fa13dbf55d2b928e.tar.gz
    SOURCE_SUBDIR runtimes
    DOWNLOAD_DIR ${PROJECT_SOURCE_DIR}
    EXCLUDE_FROM_ALL
    SYSTEM)
endif()

set(LLVM_ENABLE_RUNTIMES "libcxx;libcxxabi" CACHE INTERNAL "")
set(LLVM_ENABLE_PER_TARGET_RUNTIME_DIR OFF CACHE INTERNAL "")
set(LLVM_INCLUDE_TESTS OFF CACHE INTERNAL "")
set(LIBCXX_INSTALL_MODULES ON CACHE INTERNAL "")
set(LIBCXX_INCLUDE_BENCHMARKS OFF CACHE INTERNAL "")
set(LIBCXX_SHARED_OUTPUT_NAME c++_shared CACHE INTERNAL "")
set(LIBCXX_STATIC_OUTPUT_NAME c++_static CACHE INTERNAL "")
set(LIBCXX_ABI_UNSTABLE OFF CACHE INTERNAL "")
set(LIBCXX_HERMETIC_STATIC_LIBRARY ON CACHE INTERNAL "")
set(LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE INTERNAL "")
set(LIBCXX_ENABLE_ABI_LINKER_SCRIPT OFF CACHE INTERNAL "")
set(LIBCXX_CXX_ABI libcxxabi CACHE INTERNAL "")
set(LIBCXXABI_ENABLE_SHARED OFF CACHE INTERNAL "")
set(LIBCXXABI_INSTALL_LIBRARY OFF CACHE INTERNAL "")
set(LIBCXXABI_ENABLE_ASSERTIONS OFF CACHE INTERNAL "")
set(LIBCXXABI_HERMETIC_STATIC_LIBRARY ON CACHE INTERNAL "")
set(LIBCXXABI_USE_LLVM_UNWINDER OFF CACHE INTERNAL "")
if(APPLE)
  set(LIBCXX_PSTL_CPU_BACKEND libdispatch CACHE INTERNAL "")
  set(LIBCXX_USE_COMPILER_RT ON CACHE INTERNAL "")
endif()
FetchContent_MakeAvailable(llvm-project)

# compile options for libc++
add_compile_options(-nostdinc++)
include_directories(SYSTEM ${llvm-project_BINARY_DIR}/include/c++/v1)
# link options for libc++
add_link_options(-nostdlib++ -L${llvm-project_BINARY_DIR}/lib -lc++experimental)

list(PREPEND CMAKE_BUILD_RPATH ${llvm-project_BINARY_DIR}/lib)
if(CXXLAB_LINK_LIBCXX_DYLIB)
  # Install dylibs to <INSTALL_PREFIX>/lib/libcxxTrunk and setup rpath or runpath.
  install(DIRECTORY ${llvm-project_BINARY_DIR}/lib/ DESTINATION ${CMAKE_INSTALL_LIBDIR}/libcxxTrunk)
  if(APPLE)
    list(PREPEND CMAKE_INSTALL_RPATH @loader_path/../lib/libcxxTrunk)
  else()
    list(PREPEND CMAKE_INSTALL_RPATH $ORIGIN/../lib/libcxxTrunk)
  endif()
  add_link_options(-lc++_shared)
else()
  add_link_options(-lc++_static)
endif()
