use, intrinsic:: iso_fortran_env, only: dp=>real64
implicit none

real(dp) :: x
real(dp), external :: dnrm2

x = dnrm2(2, [2._dp, 2._dp], 1)

print *, x

end program