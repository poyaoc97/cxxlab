add_link_options(-fdiagnostics-color
  -Wl,--color-diagnostics
  -fuse-ld=lld
  -fexperimental-library)

if(APPLE)
  add_link_options(-Wl,-bind_at_load,-all_load)
  list(APPEND CMAKE_INSTALL_RPATH @loader_path/../lib)
else()
  add_link_options(-Wl,-z,noexecstack,-z,relro,-z,now)
  list(APPEND CMAKE_INSTALL_RPATH $ORIGIN/../lib)
endif()

if(CMAKE_BUILD_TYPE MATCHES Debug)
  if(CXXLAB_ENABLE_BASIC_SANITIZERS)
    add_link_options(-fsanitize=address,undefined)
  elseif(CXXLAB_ENABLE_THREAD_SANITIZERS)
    add_link_options(-fsanitize=thread)
  endif()
else()
  add_link_options(-flto=thin
    -fwhole-program-vtables
    -Wl,--thinlto-cache-policy=cache_size=10%:cache_size_bytes=10g
    -Wl,--icf=all)
  if(APPLE)
    add_link_options(-Wl,-cache_path_lto,${PROJECT_BINARY_DIR}/thinlto-cache,-dead_strip)
  else()
    add_link_options(-Wl,--thinlto-cache-dir=${PROJECT_BINARY_DIR}/thinlto-cache)
  endif()
endif()
