add_executable(pwm-blinky)
add_subdirectory(source)

target_compile_options(pwm-blinky PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>)
target_link_options(pwm-blinky PRIVATE -nostdlib -Wl,-T${CMAKE_SOURCE_DIR}/linker_scripts/mkv11z7_flash.ld)
