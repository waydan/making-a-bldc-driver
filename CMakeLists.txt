cmake_minimum_required(VERSION 3.18)

set(CMAKE_TOOLCHAIN_FILE cmake/arm-none-gcc-toolchain.cmake)
project(make-a-bldc-driver LANGUAGES C CXX ASM)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# include peripheral register headers
# add_subdirectory(mkv11z7)

add_subdirectory(00_startup)