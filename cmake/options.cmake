option(build_cblas "Build CBLAS" false)
option(build_lapack "Build LAPACK" true)
option(build_lapacke "Build LAPACKE" false)
option(build_xblas "Build extended blas" false)


# default build all
if(NOT DEFINED arith)
  set(arith "s;d")
endif()

if(c IN_LIST arith AND NOT s IN_LIST arith)
  list(APPEND arith s)
endif()
if(z IN_LIST arith AND NOT d IN_LIST arith)
  list(APPEND arith d)
endif()

if(build_lapacke)
  set(build_lapack true)

  if(s IN_LIST arith AND NOT d IN_LIST arith)
    list(APPEND arith d)
  endif()
  if(d IN_LIST arith AND NOT s IN_LIST arith)
    list(APPEND arith s)
  endif()
  if(c IN_LIST arith OR z IN_LIST arith)
    set(arith "s;d;c;z")
  endif()
endif()

set(CMAKE_TLS_VERIFY ON)

set(FETCHCONTENT_UPDATES_DISCONNECTED_LAPACK true)

# Rpath options necessary for shared library install to work correctly in user projects
set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/lib)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  # will not take effect without FORCE
  # CMAKE_BINARY_DIR for use from FetchContent
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR} CACHE PATH "Install top-level directory" FORCE)
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
