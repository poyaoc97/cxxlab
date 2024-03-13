cmake_minimum_required(VERSION 3.28)

project(CXXLAB CXX)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(CheckCompiler)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(CXXLAB_LINK_LIBCXX_DYLIB "Link to custom-built libc++ dynamic library." OFF)
option(CXXLAB_ENABLE_BASIC_SANITIZERS "Enable the Address and Undefined Behavior Sanitizers in Debug build." ON)
option(CXXLAB_ENABLE_THREAD_SANITIZER "Enable the Thread Sanitizer in Debug build." OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "" FORCE)

# Default install prefixes
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/out" CACHE PATH "Default CMAKE_INSTALL_PREFIX" FORCE)
endif()

if(APPLE)
  execute_process(COMMAND xcrun --show-sdk-path
    OUTPUT_VARIABLE CMAKE_OSX_SYSROOT_RES
    ECHO_OUTPUT_VARIABLE
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(CMAKE_OSX_SYSROOT ${CMAKE_OSX_SYSROOT_RES} CACHE PATH "")
endif(APPLE)

include(GNUInstallDirs)
include(FetchLibcxx)
include(GlobalCompFlags)
include(GlobalLinkFlags)
include(ModuleStd)

set(CMAKE_THREAD_PREFER_PTHREAD ON)
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

add_custom_target(run-all)

include(Utils)
add_subdirectory(src)
