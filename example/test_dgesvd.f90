module svd64

use, intrinsic :: iso_fortran_env, only: stderr=>error_unit, wp=>real64

implicit none (type, external)

integer, parameter :: LRATIO=8
integer, parameter :: M=3, N=3

integer, parameter :: Lwork = LRATIO*M !at least 5M for sgesvd

real(wp) :: U(M,M), VT(N,N)
real(wp) :: S(N), SWORK(LRATIO*M) !this Swork is real

private
public :: svd, wp, errchk, M, N

contains

subroutine errchk(info)

integer, intent(in) :: info

if (info /= 0) then
  write(stderr,*) 'GESVD return code', info
  if (info > 0) write(stderr,'(A,I3,A)') 'index #',info,' has sigma=0'
  error stop
endif

end subroutine errchk


integer function svd(A, B) result(info)

external :: dgesvd

real(wp), intent(in) :: A(M, N), B(M, 1)
real(wp) :: truthS(N), errmag(N)

truthS = [3.97303, 1.46913, 1.02795]

call dgesvd('A','N',M,N, A, M,S,U,M,VT, N, SWORK, LWORK, info)

errmag = norm2(s-truthS)
if (any(errmag > 1e-3)) then
  print *,'estimated singular values: ',S
  print *,'true singular values: ',truthS
  write(stderr,*) 'large error on singular values', errmag
  error stop
endif

end function svd

end module svd64


program test

use svd64

implicit none (type, external)

integer :: info
real(wp) :: A(M, N), B(M,1)

! print *,compiler_version()

A = reshape([3.,       1., 1., &
             sqrt(2.), 2., 0., &
             0.,       1., 1.], shape(A), order=[2,1])

B = reshape([8., 4.+sqrt(2.), 5.], shape(B), order=[2,1])


info = svd(A, B)

call errchk(info)

print *,'OK: Fortran SVD'

end program
