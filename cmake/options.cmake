option(build_cblas "Build CBLAS" false)
option(build_lapack "Build LAPACK" true)
option(build_lapacke "Build LAPACKE" false)
option(build_xblas "Build extended blas" false)


set(FETCHCONTENT_UPDATES_DISCONNECTED_LAPACK true)

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
