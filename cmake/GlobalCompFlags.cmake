add_compile_definitions(_LIBCPP_REMOVE_TRANSITIVE_INCLUDES)

add_compile_options(-fdiagnostics-color
  -pedantic-errors
  -Wall
  -Wextra
  -Wdeprecated
  -fexperimental-library
  -ferror-limit=0
  -ftemplate-backtrace-limit=0
  -fdiagnostics-show-template-tree
  -fno-elide-type
  -ftrivial-auto-var-init=pattern)

if(CMAKE_BUILD_TYPE MATCHES Debug)
  if(CXXLAB_ENABLE_BASIC_SANITIZERS)
    add_compile_options(-fsanitize=address,undefined)
  elseif(CXXLAB_ENABLE_THREAD_SANITIZERS)
    add_compile_options(-fsanitize=thread)
  endif()
  add_compile_options(-glldb)
else()
  add_compile_options(-flto=thin
    -fsplit-lto-unit)
endif()
