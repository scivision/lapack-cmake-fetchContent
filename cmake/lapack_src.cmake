include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

set(lapack_urls)
set(lapack_sha256)

string(JSON N LENGTH ${json} lapack urls)
math(EXPR N "${N}-1")
foreach(i RANGE ${N})
  string(JSON _u GET ${json} lapack urls ${i})
  list(APPEND lapack_urls ${_u})
endforeach()

string(JSON lapack_sha256 GET ${json} lapack sha256)

set(FETCHCONTENT_QUIET no)


FetchContent_Declare(LAPACK
URL ${lapack_urls}
URL_HASH SHA256=${lapack_sha256}
)

FetchContent_Populate(LAPACK)
