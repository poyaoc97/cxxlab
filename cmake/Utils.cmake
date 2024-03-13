macro(add_nonmodular_lib TARGET_NAME)
  add_library(${TARGET_NAME})
  set_target_properties(${TARGET_NAME}
    PROPERTIES CXX_SCAN_FOR_MODULES OFF)

  install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR})
endmacro()

macro(add_modular_lib TARGET_NAME)
  add_library(${TARGET_NAME})
  set_target_properties(${TARGET_NAME}
    PROPERTIES CXX_SCAN_FOR_MODULES ON)
  target_link_libraries(${TARGET_NAME} PRIVATE std-cxx-modules)

  install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR})
endmacro()

macro(add_nonmodular_executable TARGET_NAME)
  add_executable(${TARGET_NAME})
  set_target_properties(${TARGET_NAME}
    PROPERTIES CXX_SCAN_FOR_MODULES OFF)

  add_custom_target(run-${TARGET_NAME}
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    DEPENDS ${TARGET_NAME})
  add_dependencies(run-all run-${TARGET_NAME})

  install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endmacro()

macro(add_modular_executable TARGET_NAME)
  add_nonmodular_executable(${TARGET_NAME})
  set_target_properties(${TARGET_NAME}
    PROPERTIES CXX_SCAN_FOR_MODULES ON)
  target_link_libraries(${TARGET_NAME} PRIVATE std-cxx-modules)
endmacro()
