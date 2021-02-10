cmake_minimum_required(VERSION 3.13)

include(CMAKE/policy.cmake)

project(LAPACK
LANGUAGES C Fortran
VERSION 3.9.0
HOMEPAGE_URL "http://netlib.org/lapack")

include(CTest)

include(CMAKE/options.cmake)

if(NOT arith)
  # build all by default
  set(arith "s;d;c;z")
endif()

# typical projects set options too strict for old code style, so if
# being used as external project, locally override compile options
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
# being compiled by itself or as ExternalProject
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
    add_compile_options(/QxHost)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      string(APPEND CMAKE_Fortran_FLAGS " /warn:declarations /heap-arrays")
    else()
      add_compile_options(-xHost)
      string(APPEND CMAKE_Fortran_FLAGS " -warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")
  endif()
else()
  # being compiled via FetchContent, override options to avoid tens of megabytes of warnings
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      set(CMAKE_Fortran_FLAGS "/nologo /fpp /libs:dll /threads /warn:declarations /heap-arrays")
    else()
      set(CMAKE_Fortran_FLAGS "-warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    set(CMAKE_Fortran_FLAGS "-fimplicit-none")
  endif()
endif()

# --- BLAS
add_library(blas)
set_target_properties(
  blas PROPERTIES
  LINKER_LANGUAGE Fortran
  VERSION ${LAPACK_VERSION}
  )
add_subdirectory(BLAS/SRC)

if(BUILD_TESTING AND "d" IN_LIST arith)
  add_executable(test_nrm2 TESTING/test_nrm2.f90)
  target_link_libraries(test_nrm2 blas)
  add_test(NAME blasNRM2 COMMAND test_nrm2)
endif()

install(TARGETS blas
EXPORT LAPACKTargets
ARCHIVE DESTINATION lib
LIBRARY DESTINATION lib)

# --- CBLAS
if(build_cblas)
  add_library(cblas)
  target_link_libraries(cblas PRIVATE blas)
  set_target_properties(
    cblas PROPERTIES
    LINKER_LANGUAGE C
    VERSION ${LAPACK_VERSION}
    )
  target_include_directories(cblas PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CBLAS/include>
    $<INSTALL_INTERFACE:include>
  )
  add_subdirectory(CBLAS/src)

  install(TARGETS cblas
  EXPORT LAPACKTargets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include)
endif()

# --- LAPACK
if(build_lapack)
  add_library(lapack)
  target_link_libraries(lapack PRIVATE blas)
  set_target_properties(
    lapack PROPERTIES
    LINKER_LANGUAGE Fortran
    VERSION ${LAPACK_VERSION}
    )
  add_subdirectory(SRC)

  ### test lapack
  if(BUILD_TESTING)
    include(CheckFortranSourceCompiles)
    check_fortran_source_compiles("real :: x; x=norm2([0.]); end" f08_norm2 SRC_EXT f90)
  endif()

  if(f08_norm2)
    if("d" IN_LIST arith)
      add_executable(test_dgesvd TESTING/test_dgesvd.f90)
      target_link_libraries(test_dgesvd lapack)
      add_test(NAME dGESV COMMAND test_dgesvd)
    endif()
    if("s" IN_LIST arith)
      add_executable(test_sgesvd TESTING/test_sgesvd.f90)
      target_link_libraries(test_sgesvd lapack)
      add_test(NAME sGESV COMMAND test_sgesvd)
    endif()
  endif()

  install(TARGETS lapack
  EXPORT LAPACKTargets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib)
endif()

# --- LAPACKE
if(build_lapacke)
  add_library(lapacke)
  target_link_libraries(lapacke PRIVATE lapack)
  set_target_properties(
    lapacke PROPERTIES
    LINKER_LANGUAGE C
    VERSION ${LAPACK_VERSION}
    )
  target_include_directories(lapacke PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/LAPACKE/include>
    $<INSTALL_INTERFACE:include>
  )
  add_subdirectory(LAPACKE/src)
  add_subdirectory(LAPACKE/utils)

  install(TARGETS lapacke
  EXPORT LAPACKTargets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include)
endif()

# --- install

include(CMAKE/install.cmake)

include(FeatureSummary)
add_feature_info(C-BLAS build_cblas "Build CBLAS")
add_feature_info(FortranLapack build_lapack "Build Fortran LAPACK")
add_feature_info(C-LapackE build_lapacke "Build C-langauge LAPACKE")
add_feature_info(ExtendedBLAS build_xblas "Build extended BLAS")
feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES)
