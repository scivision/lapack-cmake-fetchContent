cmake_minimum_required(VERSION 3.13...3.25)

project(LapackExamples LANGUAGES Fortran)

enable_testing()

include(CheckFortranSourceCompiles)

find_package(LAPACK CONFIG REQUIRED)

set(CMAKE_REQUIRED_LIBRARIES LAPACK::LAPACK)

check_fortran_source_compiles("
program a
use, intrinsic :: iso_fortran_env, only : real64
implicit none

real(real64), external :: dnrm2

print *, dnrm2(1, [0._real64], 1)
end program
"
lapack_d
SRC_EXT f90
)

check_fortran_source_compiles("
program a
use, intrinsic :: iso_fortran_env, only : real32
implicit none

real(real32), external :: snrm2

print *, snrm2(1, [0._real32], 1)
end program
"
lapack_s
SRC_EXT f90
)

if(lapack_d)
  add_executable(test_dgesvd test_dgesvd.f90)
  target_link_libraries(test_dgesvd PRIVATE LAPACK::LAPACK)
  add_test(NAME dGESV COMMAND test_dgesvd)
endif()

if(lapack_s)
  add_executable(test_sgesvd test_sgesvd.f90)
  target_link_libraries(test_sgesvd PRIVATE LAPACK::LAPACK)
  add_test(NAME sGESV COMMAND test_sgesvd)
endif()
