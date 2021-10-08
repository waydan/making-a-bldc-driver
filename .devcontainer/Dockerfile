FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
    # Toolchain pakages
    build-essential \
    cmake ninja-build \
    clang-format clang-tidy \
    git wget tar

# Install cross-compiler
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.07/gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2 \
    && tar -xf gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2 -C /usr/local \
    && rm -r gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2 \
ENV PATH="$PATH:/usr/local/gcc-arm-none-eabi-10.3-2021.07/bin"