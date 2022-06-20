include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

string(JSON lapack_url GET ${json} lapack url)
string(JSON lapack_tag GET ${json} lapack tag)

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(LAPACK
GIT_REPOSITORY ${lapack_url}
GIT_TAG ${lapack_tag}
GIT_SHALLOW true
INACTIVITY_TIMEOUT 60
)

FetchContent_Populate(LAPACK)
