cmake_minimum_required(VERSION 3.19)

project(LapackExamples LANGUAGES Fortran)

enable_testing()

include(CheckSourceCompiles)

find_package(LAPACK CONFIG REQUIRED)

set(CMAKE_REQUIRED_LIBRARIES LAPACK::LAPACK)

check_source_compiles(Fortran "
program a
use, intrinsic :: iso_fortran_env, only : real64
implicit none

real(real64), external :: dnrm2

print *, dnrm2(1, [0._real64], 1)
end program
"
lapack_d
)

check_source_compiles(Fortran "
program a
use, intrinsic :: iso_fortran_env, only : real32
implicit none

real(real32), external :: snrm2

print *, snrm2(1, [0._real32], 1)
end program
"
lapack_s
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
