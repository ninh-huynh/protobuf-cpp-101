project(protobuf_101)

cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(protobuf_DIR ${CMAKE_CURRENT_SOURCE_DIR}/protobuf-libs/lib/cmake/protobuf)
set(utf8_range_DIR ${CMAKE_CURRENT_SOURCE_DIR}/protobuf-libs/lib/cmake/utf8_range)
set(absl_DIR ${CMAKE_CURRENT_SOURCE_DIR}/abseil-libs/lib/cmake/absl)

find_package(protobuf REQUIRED CONFIG)

add_executable(list_peple)
target_sources(list_peple PRIVATE list_people.cc ${CMAKE_CURRENT_SOURCE_DIR}/proto-code-gen/addressbook.pb.cc)
target_include_directories(list_peple PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/proto-code-gen)
target_link_libraries(list_peple PRIVATE protobuf::libprotobuf)

add_executable(add_person)
target_sources(add_person PRIVATE add_person.cc ${CMAKE_CURRENT_SOURCE_DIR}/proto-code-gen/addressbook.pb.cc)
target_include_directories(add_person PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/proto-code-gen)
target_link_libraries(add_person PRIVATE protobuf::libprotobuf)