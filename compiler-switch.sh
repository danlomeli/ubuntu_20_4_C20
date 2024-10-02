#!/bin/bash

# Function to switch to GCC mode
gcc_mode () 
{ 
    local GCC_VERSION=${1:-11}

    # echo "Setting up GCC Mode with GCC Version: $GCC_VERSION"

    export CC="gcc-$GCC_VERSION"
    export CXX="g++-$GCC_VERSION"
    export CFLAGS="-march=native -O2 -pipe"
    export CXXFLAGS="$CFLAGS"
    export LDFLAGS=""

    # Unset Clang-specific variables
    unset CPLUS_INCLUDE_PATH
    unset LD_LIBRARY_PATH
    unset LIBRARY_PATH
    unset CLANG_USE_LIBCXX

    # Set GCC-specific library path
    export LIBRARY_PATH="/usr/lib/gcc/x86_64-linux-gnu/$GCC_VERSION"

    # echo "After gcc_mode:"
    # echo "CC: $CC"
    # echo "CXX: $CXX"
    # echo "CFLAGS: $CFLAGS"
    # echo "CXXFLAGS: $CXXFLAGS"
    # echo "LDFLAGS: $LDFLAGS"
    # echo "LIBRARY_PATH: $LIBRARY_PATH"
    # echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

    # echo "Switched to GCC $GCC_VERSION mode"
}

# Function to switch to Clang mode
clang_mode() {
    # echo "Setting up Clang Mode"

    export CC="clang"
    export CXX="clang++"
    export CFLAGS="-march=native -O2 -pipe"
    export CXXFLAGS="$CFLAGS -stdlib=libc++"
    export LDFLAGS="-fuse-ld=lld -stdlib=libc++ -L/usr/lib/llvm-16/lib -L/usr/lib/x86_64-linux-gnu -lc++abi"

    # Set Clang-specific paths
    export LIBRARY_PATH="/usr/lib/llvm-16/lib:/usr/lib/x86_64-linux-gnu"
    export LD_LIBRARY_PATH="/usr/lib/llvm-16/lib:/usr/lib/x86_64-linux-gnu"
    export CPLUS_INCLUDE_PATH="/usr/include/c++/v1"

    # Modify PATH to prioritize Clang binaries
    export PATH="/usr/lib/llvm-16/bin:$PATH"

    # Ensure Clang uses libc++
    export CLANG_USE_LIBCXX=1

    # Unset GCC-specific variables
    unset GCC_EXEC_PREFIX
    unset COMPILER_PATH
    unset C_INCLUDE_PATH
    unset CPATH
    unset LIBRARY_PATH

    # Force use of lld linker
    export LD="lld"

    # echo "After clang_mode:"
    # echo "CC: $CC"
    # echo "CXX: $CXX"
    # echo "CFLAGS: $CFLAGS"
    # echo "CXXFLAGS: $CXXFLAGS"
    # echo "LDFLAGS: $LDFLAGS"
    # echo "CPLUS_INCLUDE_PATH: $CPLUS_INCLUDE_PATH"
    # echo "LIBRARY_PATH: $LIBRARY_PATH"
    # echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
    # echo "PATH: $PATH"
    # echo "CLANG_USE_LIBCXX: $CLANG_USE_LIBCXX"
    # echo "LD: $LD"

    # echo "Switched to Clang mode"
}