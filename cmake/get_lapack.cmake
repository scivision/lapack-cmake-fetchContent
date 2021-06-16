include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/lapack.json json)

string(JSON url0 GET ${json} lapack url0)
string(JSON url1 GET ${json} lapack url1)
string(JSON lapack_sha256 GET ${json} lapack sha256)
set(lapack_urls ${url0} ${url1})

FetchContent_Declare(lapack
URL ${lapack_urls}
URL_HASH SHA256=${lapack_sha256}
)

if(NOT lapack_POPULATED)
  FetchContent_Populate(lapack)
endif()
