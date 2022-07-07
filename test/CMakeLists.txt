include(CheckSourceCompiles)

check_source_compiles(Fortran
"program a
implicit none (type, external)
real :: x
x = norm2([0.])
end program"
f08_norm2
)

if("d" IN_LIST arith)
  add_executable(test_nrm2 test_nrm2.f90)
  target_link_libraries(test_nrm2 blas)
  add_test(NAME blasNRM2 COMMAND test_nrm2)
endif()



if(f08_norm2)
  if("d" IN_LIST arith)
    add_executable(test_dgesvd test_dgesvd.f90)
    target_link_libraries(test_dgesvd lapack)
    add_test(NAME dGESV COMMAND test_dgesvd)
  endif()
  if("s" IN_LIST arith)
    add_executable(test_sgesvd test_sgesvd.f90)
    target_link_libraries(test_sgesvd lapack)
    add_test(NAME sGESV COMMAND test_sgesvd)
  endif()
endif()
