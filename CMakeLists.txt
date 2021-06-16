cmake_minimum_required(VERSION 3.14...3.20)

project(LAPACK
LANGUAGES C Fortran
VERSION 3.9.1
HOMEPAGE_URL "http://netlib.org/lapack")

include(CTest)

include(cmake/options.cmake)

if(NOT arith)
  # build all by default
  set(arith "s;d;c;z")
endif()

include(cmake/compilers.cmake)

# --- download LAPACK
include(cmake/get_lapack.cmake)

# --- BLAS
add_library(blas)
set_target_properties(blas PROPERTIES
  LINKER_LANGUAGE Fortran
  VERSION ${LAPACK_VERSION}
  EXPORT_NAME BLAS
  )


configure_file(BLAS/src/CMakeLists.txt ${lapack_SOURCE_DIR}/BLAS/SRC/ COPYONLY)
add_subdirectory(${lapack_SOURCE_DIR}/BLAS/SRC ${lapack_BINARY_DIR}/BLAS/SRC)

if(BUILD_TESTING AND "d" IN_LIST arith)
  add_executable(test_nrm2 tests/test_nrm2.f90)
  target_link_libraries(test_nrm2 blas)
  add_test(NAME blasNRM2 COMMAND test_nrm2)
endif()

install(TARGETS blas EXPORT ${PROJECT_NAME}Targets)

# --- CBLAS
if(build_cblas)
  add_library(cblas)
  target_link_libraries(cblas PRIVATE blas)
  set_target_properties(cblas PROPERTIES
    LINKER_LANGUAGE C
    VERSION ${LAPACK_VERSION}
    EXPORT_NAME CBLAS
    )
  target_include_directories(cblas PUBLIC
    $<BUILD_INTERFACE:${lapack_SOURCE_DIR}/CBLAS/include>
    $<INSTALL_INTERFACE:include>
  )
  configure_file(CBLAS/src/CMakeLists.txt ${lapack_SOURCE_DIR}/CBLAS/src/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/CBLAS/src ${lapack_BINARY_DIR}/CBLAS/src)

  install(TARGETS cblas EXPORT ${PROJECT_NAME}Targets)
endif()

# --- LAPACK
if(build_lapack)
  add_library(lapack)
  target_link_libraries(lapack PRIVATE blas)
  set_target_properties(lapack PROPERTIES
    LINKER_LANGUAGE Fortran
    VERSION ${LAPACK_VERSION}
    EXPORT_NAME LAPACK
    )

  configure_file(src/CMakeLists.txt ${lapack_SOURCE_DIR}/SRC/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/SRC ${lapack_BINARY_DIR}/SRC)

  ### test lapack
  if(BUILD_TESTING)
    include(CheckFortranSourceCompiles)
    check_fortran_source_compiles("real :: x; x=norm2([0.]); end" f08_norm2 SRC_EXT f90)
  endif()

  if(f08_norm2)
    if("d" IN_LIST arith)
      add_executable(test_dgesvd tests/test_dgesvd.f90)
      target_link_libraries(test_dgesvd lapack)
      add_test(NAME dGESV COMMAND test_dgesvd)
    endif()
    if("s" IN_LIST arith)
      add_executable(test_sgesvd tests/test_sgesvd.f90)
      target_link_libraries(test_sgesvd lapack)
      add_test(NAME sGESV COMMAND test_sgesvd)
    endif()
  endif()

  install(TARGETS lapack EXPORT ${PROJECT_NAME}Targets)
endif()

# --- LAPACKE
if(build_lapacke)
  add_library(lapacke)
  target_link_libraries(lapacke PRIVATE lapack)
  set_target_properties(lapacke PROPERTIES
    LINKER_LANGUAGE C
    VERSION ${LAPACK_VERSION}
    EXPORT_NAME LAPACKE
    )
  target_include_directories(lapacke PUBLIC
    $<BUILD_INTERFACE:${lapack_SOURCE_DIR}/LAPACKE/include>
    $<INSTALL_INTERFACE:include>
  )

  configure_file(LAPACKE/src/CMakeLists.txt ${lapack_SOURCE_DIR}/LAPACKE/src/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/LAPACKE/src ${lapack_BINARY_DIR}/LAPACKE/src)

  configure_file(LAPACKE/utils/CMakeLists.txt ${lapack_SOURCE_DIR}/LAPACKE/utils/ COPYONLY)
  add_subdirectory(${lapack_SOURCE_DIR}/LAPACKE/utils ${lapack_BINARY_DIR}/LAPACKE/utils)

  install(TARGETS lapacke EXPORT ${PROJECT_NAME}Targets)
endif()

# --- install

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindLAPACK.cmake
  DESTINATION lib/cmake/${PROJECT_NAME}/Modules)

include(cmake/install.cmake)

include(FeatureSummary)
add_feature_info(C-BLAS build_cblas "Build CBLAS")
add_feature_info(FortranLapack build_lapack "Build Fortran LAPACK")
add_feature_info(C-LapackE build_lapacke "Build C-langauge LAPACKE")
add_feature_info(ExtendedBLAS build_xblas "Build extended BLAS")
feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
