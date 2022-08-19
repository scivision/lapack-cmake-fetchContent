include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(local)

string(TOLOWER ${PROJECT_NAME}_src name)

find_file(${name}_archive
NAMES ${name}.tar.bz2 ${name}.tar.gz ${name}.tar ${name}.zip ${name}.zstd ${name}.tar.xz
HINTS ${local}
NO_DEFAULT_PATH
)

if(NOT ${name}_archive)
message(FATAL_ERROR "Archive file for ${name} does not exist under ${local}")
endif()

message(STATUS "${name}: using source archive ${${name}_archive}")

FetchContent_Declare(LAPACK
URL ${${name}_archive}
)

else()

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

endif()

FetchContent_Populate(LAPACK)
