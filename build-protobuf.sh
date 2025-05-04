#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "❌ Please provide the PROJECT_PATH"
    exit 1
else
    PROJECT_PATH=$1
fi

BUILD_PATH=$(pwd)/protobuf-build
INSTALL_PATH=$(pwd)/protobuf-libs
ABSL_LIB_DIR=$(pwd)/abseil-fat-libs

echo "🚀 Configuring ..."

cmake -S $PROJECT_PATH \
      -B $BUILD_PATH \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH \
      -DBUILD_SHARED_LIBS=OFF \
      -Dprotobuf_BUILD_SHARED_LIBS=OFF \
      -Dprotobuf_VERBOSE=ON \
      -Dprotobuf_INSTALL=ON \
      -Dprotobuf_BUILD_EXAMPLES=OFF \
      -Dprotobuf_BUILD_TESTS=OFF \
      -Dprotobuf_BUILD_PROTOBUF_BINARIES=ON \
      -Dprotobuf_BUILD_PROTOC_BINARIES=OFF \
      -Dprotobuf_BUILD_LIBUPB=OFF \
      -Dprotobuf_ABSL_PROVIDER=package \
      -Dabsl_DIR="$ABSL_LIB_DIR/lib/cmake/absl" \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
      -G Ninja

#   -DCMAKE_EXE_LINKER_FLAGS="-stdlib=libc++ -Wl,-rpath,/path/to/libc++/lib -L/path/to/libc++/lib -lc++"

# ninja -C build
cmake --build $BUILD_PATH --target install
