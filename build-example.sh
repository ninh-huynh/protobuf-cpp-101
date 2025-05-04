#!/usr/bin/env bash
set -e

# Check for argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <static|shared>"
  exit 1
fi

LINK_TYPE=$1

rm add_person list_people || true

ABSL_LIBS=(                        
  -labsl
  -lutf8_validity
  -lutf8_range
)

compile() {
  local source_file=$1
  local output_file=$2
  local extra_flags=$3

  clang++ "$source_file" \
    ./proto-code-gen/addressbook.pb.cc \
    -std=c++17 \
    -o "$output_file" \
    -I./protobuf-libs/include \
    -I./abseil-fat-libs/include \
    -I./proto-code-gen \
    -L./protobuf-libs/lib \
    -lprotobuf \
    -L./abseil-fat-libs/lib \
    "${ABSL_LIBS[@]}" \
    $extra_flags
}

if [ "$LINK_TYPE" == "shared" ]; then
  # Link shared
  compile list_people.cc list_people "-Wl,-rpath,./abseil-libs/lib -Wl,-rpath,./protobuf-libs/lib"
  compile add_person.cc add_person "-Wl,-rpath,./abseil-libs/lib -Wl,-rpath,./protobuf-libs/lib"
elif [ "$LINK_TYPE" == "static" ]; then
  # Link static
  compile list_people.cc list_people "-framework CoreFoundation"
  compile add_person.cc add_person "-framework CoreFoundation"
fi

# -L./protobuf-libs/lib \
# -L./abseil-libs/lib \

# /usr/lib/llvm-19/lib
# /usr/lib/llvm-19/include/c++/v1
# /usr/lib/llvm-19/bin

# Shared
# -Wl,-rpath,/path/to/libc++/lib \
# -L/path/to/libc++/lib -lc++


# Static
# clang++ -std=c++17 -L/path/to/lib -Wl,-Bstatic -lc++ -lc++abi -Wl,-Bdynamic -o main

# Check what being linked
# clang++ -### -stdlib=libc++ main.cpp
