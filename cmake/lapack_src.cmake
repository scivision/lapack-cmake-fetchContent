include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(CMAKE_VERSION VERSION_LESS 3.19)
  include(${CMAKE_CURRENT_LIST_DIR}/Modules/JsonParse.cmake)
  sbeParseJson(meta json)
  set(lapack_url ${meta.lapack.url})
  set(lapack_tag ${meta.lapack.tag})
else()
  string(JSON lapack_url GET ${json} lapack url)
  string(JSON lapack_tag GET ${json} lapack tag)
endif()

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(LAPACK
GIT_REPOSITORY ${lapack_url}
GIT_TAG ${lapack_tag}
GIT_SHALLOW true
INACTIVITY_TIMEOUT 60
TLS_VERIFY true
)

FetchContent_Populate(LAPACK)
