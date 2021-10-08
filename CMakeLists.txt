cmake_minimum_required(VERSION 3.18)

set(CMAKE_TOOLCHAIN_FILE cmake/arm-none-gcc-toolchain.cmake)
project(make-a-bldc-driver LANGUAGES C CXX ASM)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(00_startup)
add_subdirectory(01_pwm_blinky)