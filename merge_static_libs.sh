#!/usr/bin/env bash
set -e

# Help message
usage() {
  echo "Usage: $0 <input_dir> <output_dir> [output_lib_name]"
  echo "Example: $0 ./libs ./build libcustom.a"
  exit 1
}

# Parse arguments
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  usage
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"
OUTPUT_NAME="${3:-libmerged.a}"
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_NAME"
TMP_DIR=$(mktemp -d)

# Make sure input and output directories exist
if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: Input directory does not exist: $INPUT_DIR"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Input directory:  $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Output library:   $OUTPUT_PATH"
echo

full_input_dir=$(realpath $INPUT_DIR/*.a)
pushd $TMP_DIR > /dev/null

# Extract all object files into the temp directory
for lib in $full_input_dir; do
  echo "Extracting from $lib"

  # Get archive name without path and extension
  archive_name=$(basename "$lib" .a)

  # Extract all .o files and rename them to avoid conflicts
  ar t "$lib" | while read obj; do
      ar x "$lib" "$obj"
      # echo "ar x done."
      mv "$obj" "${archive_name}_$obj"
      # echo "mv done"
  done  
  # ar x "$lib"
done

popd > /dev/null

# Create merged static library
echo
echo "Creating merged library..."
ar rcs "$OUTPUT_PATH" "$TMP_DIR"/*.o

# Clean up
rm -rf "$TMP_DIR"

echo "Done. Created: $OUTPUT_PATH"

