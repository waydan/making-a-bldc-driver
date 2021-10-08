add_executable(startup-example)
add_subdirectory(source)

target_compile_features(startup-example PRIVATE cxx_std_17)
target_compile_options(startup-example PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>)
target_link_options(startup-example PRIVATE -nostdlib -Wl,-T${CMAKE_CURRENT_SOURCE_DIR}/mkv11z7_flash.ld)
target_export_mapfile(startup-example)
target_export_binary_image(startup-example binary)