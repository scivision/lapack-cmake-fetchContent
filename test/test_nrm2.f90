program test

use, intrinsic :: iso_fortran_env, only : real64

implicit none

real(real64) :: x

real(real64), external :: dnrm2

x = dnrm2(2, [real(real64) :: 2, 2], 1)

if( abs(x-2.8284271247461903) > 0.0001 ) error stop "norm2 incorrect computation"

print *, "OK: BLAS nrm2"

end program
