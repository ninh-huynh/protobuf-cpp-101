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
  -labsl_str_format_internal      
  -labsl_strings                  
  -labsl_strings_internal         
  -labsl_log_initialize           
  -labsl_log_entry                
  -labsl_log_flags                
  -labsl_log_severity             
  -labsl_log_internal_check_op    
  -labsl_log_internal_conditions  
  -labsl_log_internal_message     
  -labsl_log_internal_nullguard   
  -labsl_log_internal_proto       
  -labsl_log_internal_format      
  -labsl_log_internal_globals     
  -labsl_log_internal_log_sink_set
  -labsl_log_sink                 
  -labsl_raw_logging_internal     
  -labsl_log_globals              
  -lutf8_validity                 
  -labsl_cord                     
  -labsl_cordz_info               
  -labsl_cordz_handle             
  -labsl_cordz_functions          
  -labsl_cord_internal            
  -labsl_crc_cord_state           
  -labsl_crc32c                   
  -labsl_crc_internal             
  -labsl_exponential_biased       
  -labsl_synchronization          
  -labsl_time                     
  -labsl_time_zone                
  -labsl_int128                   
  -labsl_examine_stack            
  -labsl_stacktrace               
  -labsl_symbolize                
  -labsl_demangle_internal        
  -labsl_debugging_internal       
  -labsl_malloc_internal          
  -labsl_throw_delegate           
  -labsl_strerror                 
  -labsl_raw_hash_set             
  -labsl_hash                     
  -labsl_city                     
  -labsl_low_level_hash           
  -labsl_base                     
  -labsl_spinlock_wait
  -labsl_status
  -labsl_statusor
  -labsl_kernel_timeout_internal
  -labsl_crc_cpu_detect 
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
    -I./abseil-libs/include \
    -I./proto-code-gen \
    -L./protobuf-libs/lib \
    -lprotobuf \
    -L./abseil-libs/lib \
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
