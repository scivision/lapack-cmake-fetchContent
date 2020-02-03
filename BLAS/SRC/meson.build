#######################################################################
#  Create a library for the BLAS.
#  The files are grouped as follows:
#
#       SBLAS1 -- Single precision real BLAS routines
#       CBLAS1 -- Single precision complex BLAS routines
#       DBLAS1 -- Double precision real BLAS routines
#       ZBLAS1 -- Double precision complex BLAS routines
#
#       CB1AUX -- Real BLAS routines called by complex routines
#       ZB1AUX -- D.P. real BLAS routines called by d.p. complex
#                 routines
#
#      ALLBLAS -- Auxiliary routines for Level 2 and 3 BLAS
#
#       SBLAS2 -- Single precision real BLAS2 routines
#       CBLAS2 -- Single precision complex BLAS2 routines
#       DBLAS2 -- Double precision real BLAS2 routines
#       ZBLAS2 -- Double precision complex BLAS2 routines
#
#       SBLAS3 -- Single precision real BLAS3 routines
#       CBLAS3 -- Single precision complex BLAS3 routines
#       DBLAS3 -- Double precision real BLAS3 routines
#       ZBLAS3 -- Double precision complex BLAS3 routines
#
#######################################################################

#---------------------------------------------------------
#  Level 1 BLAS
#---------------------------------------------------------
sblas1 = files('isamax.f', 'sasum.f', 'saxpy.f', 'scopy.f', 'sdot.f', 'snrm2.f',
  'srot.f', 'srotg.f', 'sscal.f', 'sswap.f', 'sdsdot.f', 'srotmg.f', 'srotm.f')

cblas1 = files('scabs1.f', 'scasum.f', 'scnrm2.f', 'icamax.f', 'caxpy.f', 'ccopy.f',
  'cdotc.f', 'cdotu.f', 'csscal.f', 'crotg.f', 'cscal.f', 'cswap.f', 'csrot.f')

dblas1 = files('idamax.f', 'dasum.f', 'daxpy.f', 'dcopy.f', 'ddot.f', 'dnrm2.f',
  'drot.f', 'drotg.f', 'dscal.f', 'dsdot.f', 'dswap.f', 'drotmg.f', 'drotm.f')

zblas1 = files('dcabs1.f', 'dzasum.f', 'dznrm2.f', 'izamax.f', 'zaxpy.f', 'zcopy.f',
  'zdotc.f', 'zdotu.f', 'zdscal.f', 'zrotg.f', 'zscal.f', 'zswap.f', 'zdrot.f')

cb1aux = files('isamax.f', 'sasum.f', 'saxpy.f', 'scopy.f', 'snrm2.f', 'sscal.f')

zb1aux = files('idamax.f', 'dasum.f', 'daxpy.f', 'dcopy.f', 'dnrm2.f', 'dscal.f')

#---------------------------------------------------------------------
#  Auxiliary routines needed by both the Level 2 and Level 3 BLAS
#---------------------------------------------------------------------
allblas = files('lsame.f', 'xerbla.f', 'xerbla_array.f')

#---------------------------------------------------------
#  Level 2 BLAS
#---------------------------------------------------------
sblas2 = files('sgemv.f', 'sgbmv.f', 'ssymv.f', 'ssbmv.f', 'sspmv.f',
  'strmv.f', 'stbmv.f', 'stpmv.f', 'strsv.f', 'stbsv.f', 'stpsv.f',
  'sger.f', 'ssyr.f', 'sspr.f', 'ssyr2.f', 'sspr2.f')

cblas2 = files('cgemv.f', 'cgbmv.f', 'chemv.f', 'chbmv.f', 'chpmv.f',
  'ctrmv.f', 'ctbmv.f', 'ctpmv.f', 'ctrsv.f', 'ctbsv.f', 'ctpsv.f',
  'cgerc.f', 'cgeru.f', 'cher.f', 'chpr.f', 'cher2.f', 'chpr2.f')

dblas2 = files('dgemv.f', 'dgbmv.f', 'dsymv.f', 'dsbmv.f', 'dspmv.f',
  'dtrmv.f', 'dtbmv.f', 'dtpmv.f', 'dtrsv.f', 'dtbsv.f', 'dtpsv.f',
  'dger.f', 'dsyr.f', 'dspr.f', 'dsyr2.f', 'dspr2.f')

zblas2 = files('zgemv.f', 'zgbmv.f', 'zhemv.f', 'zhbmv.f', 'zhpmv.f',
  'ztrmv.f', 'ztbmv.f', 'ztpmv.f', 'ztrsv.f', 'ztbsv.f', 'ztpsv.f',
  'zgerc.f', 'zgeru.f', 'zher.f', 'zhpr.f', 'zher2.f', 'zhpr2.f')

#---------------------------------------------------------
#  Level 3 BLAS
#---------------------------------------------------------
sblas3 = files('sgemm.f', 'ssymm.f', 'ssyrk.f', 'ssyr2k.f', 'strmm.f', 'strsm.f')

cblas3 = files('cgemm.f', 'csymm.f', 'csyrk.f', 'csyr2k.f', 'ctrmm.f', 'ctrsm.f',
  'chemm.f', 'cherk.f', 'cher2k.f')

dblas3 = files('dgemm.f', 'dsymm.f', 'dsyrk.f', 'dsyr2k.f', 'dtrmm.f', 'dtrsm.f')

zblas3 = files('zgemm.f', 'zsymm.f', 'zsyrk.f', 'zsyr2k.f', 'ztrmm.f', 'ztrsm.f',
  'zhemm.f', 'zherk.f', 'zher2k.f')

blas_sources = []

if arith.contains('s')
  blas_sources += [sblas1, allblas, sblas2, sblas3]
endif
if arith.contains('d')
  blas_sources += [dblas1, allblas, dblas2, dblas3]
endif
if arith.contains('c')
  blas_sources += [cblas1, cb1aux, allblas, cblas2, cblas3]
endif
if arith.contains('z')
  blas_sources += [zblas1, zb1aux, allblas, zblas2, zblas3]
endif
