program test

use, intrinsic :: iso_fortran_env, only : real64

implicit none (type, external)

real(real64) :: x

real(real64), external :: dnrm2

x = dnrm2(2, [real(real64) :: 2, 2], 1)

print *, x

end program
