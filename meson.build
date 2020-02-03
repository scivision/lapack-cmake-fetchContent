project('LAPACK', 'c', 'fortran',
  version : '3.9.0',
  meson_version: '>=0.50.0',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=lapack', 'includedir=lapack/include'])

arith = get_option('arith')
build_xblas = get_option('build_xblas')

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

if arith.contains('d')
  blas_test_exe = executable('test_nrm2', 'TESTING/test_nrm2.f90',
    link_with: blas)
  test('BLAS NRM2', blas_test_exe,
    timeout: 10, suite: 'blas')
endif

## CBLAS
if get_option('build_cblas')
  subdir('CBLAS/src')
  # TODO: need to configure blas_mangling*.h
  cblas_lib = library('cblas', cblas_sources,
    link_with : blas,
    include_directories : 'CBLAS/include',
    install: true)
  cblas = declare_dependency(link_with: [cblas_lib, blas], include_directories: 'CBLAS/include')
endif

## LAPACK
if get_option('build_lapack')
  subdir('SRC')

  lapack = library('lapack', lapack_sources,
    link_with : blas,
    install: true)

  # --- generate pkg-config
  pkg = import('pkgconfig')
  pkg.generate(lapack,
    url: 'https://github.com/Reference-LAPACK/lapack',
    subdirs: 'lapack',
    description: 'Netlib LAPACK')

  ### test lapack
  if fc.links('x=norm2([0.]); end', name: 'F2008 norm2')
    if arith.contains('d')
      test_dgesv = executable('test_dgesvd', 'TESTING/test_dgesvd.f90',
        link_with: lapack)
      test('dGESV', test_dgesv, timeout: 15, suite: 'lapack')
    endif
    if arith.contains('s')
      test_sgesv = executable('test_sgesvd', 'TESTING/test_sgesvd.f90',
        link_with: lapack)
      test('sGESV', test_sgesv, timeout: 15, suite: 'lapack')
    endif
  endif
endif

## LAPACKE
if get_option('build_lapacke')
	subdir('LAPACKE/src')
  subdir('LAPACKE/utils')

	lapacke_lib = library('lapacke',
    sources: [lapacke_sources, lapacke_utils],
	  link_with : lapack,
	  include_directories : 'LAPACKE/include',
    install: true)

  lapacke = declare_dependency(link_with: [lapacke_lib, lapack], include_directories: 'LAPACKE/include')
endif
