set(CMAKE_SYSTEM_NAME       Generic)
set(CMAKE_SYSTEM_PROCESSOR  arm)

set(CMAKE_TRY_COMPILE_TARGET_TYPE   STATIC_LIBRARY)

set(tool_prefix arm-none-eabi-)
set(toolchainPath "/usr/local/gcc-arm-none-eabi-10.3-2021.07")

set(CMAKE_AR            "${toolchainPath}/bin/${tool_prefix}ar")
set(CMAKE_C_COMPILER    "${toolchainPath}/bin/${tool_prefix}gcc")
set(CMAKE_CXX_COMPILER  "${toolchainPath}/bin/${tool_prefix}g++")
set(CMAKE_ASM_COMPILER  "${CMAKE_C_COMPILER}") # GNU `as` often fails with unusable flags
set(CMAKE_LINKER        "${toolchainPath}/bin/${tool_prefix}ld")
set(CMAKE_OBJCOPY       "${toolchainPath}/bin/${tool_prefix}objcopy")
set(CMAKE_RANLIB        "${toolchainPath}/bin/${tool_prefix}ranlib")
set(CMAKE_SIZE          "${toolchainPath}/bin/${tool_prefix}size")
set(CMAKE_STRIP         "${toolchainPath}/bin/${tool_prefix}strip")

set(CMAKE_C_FLAGS_INIT       "-march=armv6-m")
set(CMAKE_CXX_FLAGS_INIT     ${CMAKE_C_FLAGS_INIT})

set(CMAKE_SYSROOT ${toolchainPath}/arm-none-eabi)
include_directories(SYSTEM ${toolchainPath}/arm-none-eabi/include ${toolchainPath}/arm-none-eabi/include/c++/10.3.1)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM     NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY     ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE     ONLY)

function(target_export_binary_image targetName format)
    add_custom_command(TARGET ${targetName} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O ${format} $<TARGET_FILE:${targetName}> $<TARGET_FILE_DIR:${targetName}>/${targetName}.bin
        # BYPRODUCTS ${targetName}.bin
        COMMENT "Binary image has been saved to ${targetName}.bin")
endfunction()

function(target_export_mapfile targetName)
    target_link_options(${targetName} PRIVATE "-Wl,-Map=$<TARGET_FILE:${targetName}>.map")
endfunction()