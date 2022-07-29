cmake_minimum_required(VERSION 3.19...3.24)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION PROJECT_VERSION
REGEX "^([0-9]+\.[0-9]+\.[0-9]+)" LIMIT_INPUT 16 LENGTH_MAXIMUM 16 LIMIT_COUNT 1
)

project(LAPACK
LANGUAGES C Fortran
VERSION ${PROJECT_VERSION}
HOMEPAGE_URL "http://netlib.org/lapack"
)

enable_testing()
if(DEFINED BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
else()
  set(${PROJECT_NAME}_BUILD_TESTING true)
endif()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

# --- download LAPACK
include(cmake/lapack_src.cmake)

# --- BLAS
add_library(blas)
set_property(TARGET blas PROPERTY LINKER_LANGUAGE Fortran)
set_property(TARGET blas PROPERTY VERSION ${LAPACK_VERSION})
set_property(TARGET blas PROPERTY EXPORT_NAME BLAS)


configure_file(BLAS/src/CMakeLists.txt ${lapack_SOURCE_DIR}/BLAS/SRC/ COPYONLY)
add_subdirectory(${lapack_SOURCE_DIR}/BLAS/SRC ${lapack_BINARY_DIR}/BLAS/SRC)

install(TARGETS blas EXPORT ${PROJECT_NAME}-targets)

# --- CBLAS
if(build_cblas)
  add_library(cblas)
  target_link_libraries(cblas PRIVATE blas)
  set_property(TARGET cblas PROPERTY LINKER_LANGUAGE C)
  set_property(TARGET cblas PROPERTY VERSION ${LAPACK_VERSION})
  set_property(TARGET cblas PROPERTY EXPORT_NAME CBLAS)
  target_include_directories(cblas PUBLIC
  "$<BUILD_INTERFACE:${lapack_SOURCE_DIR}/CBLAS/include;${lapack_BINARY_DIR}/include>"
  $<INSTALL_INTERFACE:include>
  )
  configure_file(CBLAS/src/CMakeLists.txt ${lapack_SOURCE_DIR}/CBLAS/src/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/CBLAS/src ${lapack_BINARY_DIR}/CBLAS/src)

  install(TARGETS cblas EXPORT ${PROJECT_NAME}-targets)
endif()

# --- LAPACK
add_library(lapack)
target_link_libraries(lapack PRIVATE blas)
set_property(TARGET lapack PROPERTY LINKER_LANGUAGE Fortran)
set_property(TARGET lapack PROPERTY VERSION ${LAPACK_VERSION})
set_property(TARGET lapack PROPERTY EXPORT_NAME LAPACK)

configure_file(src/CMakeLists.txt ${lapack_SOURCE_DIR}/SRC/ COPYONLY)
add_subdirectory(${lapack_SOURCE_DIR}/SRC ${lapack_BINARY_DIR}/SRC)

install(TARGETS lapack EXPORT ${PROJECT_NAME}-targets)


# --- LAPACKE
if(build_lapacke)
  add_library(lapacke)
  target_link_libraries(lapacke PRIVATE lapack)
  set_property(TARGET lapacke PROPERTY LINKER_LANGUAGE C)
  set_property(TARGET lapacke PROPERTY VERSION ${LAPACK_VERSION})
  set_property(TARGET lapacke PROPERTY EXPORT_NAME LAPACKE)
  target_include_directories(lapacke PUBLIC
  "$<BUILD_INTERFACE:${lapack_SOURCE_DIR}/LAPACKE/include;${lapack_BINARY_DIR}/include>"
  $<INSTALL_INTERFACE:include>
  )

  configure_file(LAPACKE/src/CMakeLists.txt ${lapack_SOURCE_DIR}/LAPACKE/src/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/LAPACKE/src ${lapack_BINARY_DIR}/LAPACKE/src)

  configure_file(LAPACKE/utils/CMakeLists.txt ${lapack_SOURCE_DIR}/LAPACKE/utils/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/LAPACKE/utils ${lapack_BINARY_DIR}/LAPACKE/utils)

  install(TARGETS lapacke EXPORT ${PROJECT_NAME}-targets)
endif()

# --- test
if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(test)
endif()

# --- install

install(FILES
${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindLAPACK.cmake
DESTINATION cmake
)

include(cmake/install.cmake)

include(FeatureSummary)
add_feature_info(C-BLAS build_cblas "Build CBLAS")
add_feature_info(C-LapackE build_lapacke "Build C-langauge LAPACKE")
add_feature_info(ExtendedBLAS build_xblas "Build extended BLAS")
feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
