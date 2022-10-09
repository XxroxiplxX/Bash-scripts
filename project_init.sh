#!/bin/bash
cd CLionProjects
mkdir -p $1/{build,lib,src,tst}
cd $1
echo "
cmake_minimum_required(VERSION 3.10)
project($1)

set(CMAKE_CXX_STANDARD 14)

include_directories(src)

add_subdirectory(src)
add_subdirectory(tst)
add_subdirectory(lib/googletest)
" > CMakeLists.txt
cd src
echo 'set(BINARY ${CMAKE_PROJECT_NAME})

file(GLOB_RECURSE SOURCES LIST_DIRECTORIES true *.h *.cpp)

set(SOURCES ${SOURCES})

add_executable(${BINARY}_run ${SOURCES})

add_library(${BINARY}_lib STATIC ${SOURCES})
' > CMakeLists.txt
echo "#include <iostream>
int main() {
return 0;
}" > main.cpp
cd ..
cd tst
echo 'set(BINARY ${CMAKE_PROJECT_NAME}_tst)

file(GLOB_RECURSE TEST_SOURCES LIST_DIRECTORIES false *.h *.cpp)

set(SOURCES ${TEST_SOURCES})

add_executable(${BINARY} ${TEST_SOURCES})

add_test(NAME ${BINARY} COMMAND ${BINARY})

target_link_libraries(${BINARY} PUBLIC ${CMAKE_PROJECT_NAME}_lib gtest)' > CMakeLists.txt
echo '#include "gtest/gtest.h"

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}' > main.cpp
cd ..
cd lib
git clone https://github.com/google/googletest/
cd ..
cd build

