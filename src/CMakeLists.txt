# module coro
set(TARGET_NAME CoroM)
add_modular_lib(${TARGET_NAME})
target_sources(${TARGET_NAME}
  PRIVATE Coro.cpp MulTable.cpp  # multiple module implementation units of the same module
  PUBLIC FILE_SET CXX_MODULES FILES
    Coro.cppm
    MulTable_interface.cppm
    MulTable_impl.cppm)

# main executable
set(TARGET_NAME coro)
add_modular_executable(${TARGET_NAME})
target_sources(${TARGET_NAME}
  PRIVATE main.cpp)
target_link_libraries(${TARGET_NAME}
  PRIVATE Threads::Threads CoroM)
