include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/lapack.json json)

string(JSON lapack_url GET ${json} lapack url)
string(JSON lapack_sha256 GET ${json} lapack sha256)

FetchContent_Declare(LAPACK
URL ${lapack_url}
URL_HASH SHA256=${lapack_sha256}
)

if(NOT lapack_POPULATED)
  FetchContent_Populate(LAPACK)
endif()
