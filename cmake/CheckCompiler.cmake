message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "18.0.0")
    message(WARNING "Clang 18 or newer is recommended")
  endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "14.0.0")
    message(WARNING "GCC 14 or newer is recommended")
  endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "16.0.0")
    message(WARNING "
Please consider downloading Clang via Homebrew (https://brew.sh):
brew install --HEAD llvm
")
  endif()
else()
  message(WARNING "You compiler might not work with this project, YMMV.")
endif()
