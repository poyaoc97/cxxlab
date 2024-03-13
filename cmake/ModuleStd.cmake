add_library(std-cxx-modules STATIC)
add_dependencies(std-cxx-modules generate-cxx-modules cxx cxx_experimental)
target_sources(std-cxx-modules
  PUBLIC
    FILE_SET moduleStd
    TYPE CXX_MODULES
    BASE_DIRS ${llvm-project_BINARY_DIR}/modules/c++/v1
    FILES
      ${llvm-project_BINARY_DIR}/modules/c++/v1/std.cppm
      ${llvm-project_BINARY_DIR}/modules/c++/v1/std.compat.cppm)
target_compile_options(std-cxx-modules
  PRIVATE
    -Wno-reserved-module-identifier
    -Wno-reserved-user-defined-literal)
