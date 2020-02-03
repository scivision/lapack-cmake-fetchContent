project('LAPACK', 'c', 'fortran',
  version : '3.9.0',
  meson_version: '>=0.50.0',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=lapack', 'includedir=lapack/include'])

use_xblas = get_option('use_xblas')
arith = get_option('arith')

fc = meson.get_compiler('fortran')
if fc.get_id() == 'intel-cl'
  # /fpp is necessary for any Fortran preprocessing statement with Intel ifort on Windows
  # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-fpp
   add_project_arguments('/fpp', language: 'fortran')
endif

if meson.is_subproject()
  quiet = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
  add_project_arguments(quiet, language: 'fortran')
endif

# --- BLAS
subdir('BLAS/SRC')
blas = library('blas', blas_sources,
  install: true)

blas_test_exe = executable('test_nrm2', 'TESTING/test_nrm2.f90',
  link_with: blas)
test('BLAS NRM2', blas_test_exe,
  timeout: 10, suite: 'blas')


## CBLAS
if get_option('use_cblas')
  subdir('CBLAS/src')
  # TODO: need to configure blas_mangling*.h
  cblas = library('cblas', cblas_sources,
    link_with : blas,
    include_directories : 'CBLAS/include',
    install: true)
endif

if get_option('blas_only')
  subdir_done()
endif

## LAPACK
subdir('SRC')

lapack_lib = library('lapack', lapack_sources,
  link_with : blas,
  install: true)
lapack = declare_dependency(link_with: lapack_lib)

# --- generate pkg-config
pkg = import('pkgconfig')
pkg.generate(lapack_lib,
  url: 'https://github.com/Reference-LAPACK/lapack',
  subdirs: 'lapack',
  description: 'Netlib LAPACK')

### test lapack
if fc.links('x=norm2([0.]); end', name: 'F2008 norm2')
  if arith.contains('d')
    test_dgesv = executable('test_dgesvd', 'TESTING/test_dgesvd.f90',
      dependencies: lapack)
    test('dGESV', test_dgesv, timeout: 15, suite: 'lapack')
  endif
  if arith.contains('s')
    test_sgesv = executable('test_sgesvd', 'TESTING/test_sgesvd.f90',
      dependencies: lapack)
    test('sGESV', test_sgesv, timeout: 15, suite: 'lapack')
  endif
endif

## LAPACKE
if get_option('use_lapacke')
	subdir('LAPACKE/src')

	lapacke_lib = library('lapacke',
    sources: lapacke_sources,
	  dependencies : lapack,
	  include_directories : 'LAPACKE/include',
    install: true)

  lapacke = declare_dependency(link_with: lapacke_lib, include_directories: 'LAPACKE/include', dependencies: lapack)
endif
