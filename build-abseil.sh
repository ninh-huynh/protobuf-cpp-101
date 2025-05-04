#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "❌ Please provide the PROJECT_PATH"
    exit 1
else
    PROJECT_PATH=$1
fi

BUILD_PATH=$(pwd)/abseil-build
INSTALL_PATH=$(pwd)/abseil-libs

echo "🚀 Configuring ..."

cmake -S $PROJECT_PATH \
      -B $BUILD_PATH \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_TESTING=OFF \
      -DABSL_ENABLE_INSTALL=ON \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_FLAGS="-stdlib=libc++" \
      -G Ninja

#   -DCMAKE_EXE_LINKER_FLAGS="-stdlib=libc++ -Wl,-rpath,/path/to/libc++/lib -L/path/to/libc++/lib -lc++"

# ninja -C build
cmake --build $BUILD_PATH --target install
