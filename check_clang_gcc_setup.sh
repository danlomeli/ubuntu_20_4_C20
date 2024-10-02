#!/bin/bash

echo "Compiler Reset and Test Script"
echo "=============================="

# Reset environment variables
unset CC CXX CFLAGS CXXFLAGS LDFLAGS LD_LIBRARY_PATH

# Reset PATH to default
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create a simple C++ test file
cat << EOF > test.cpp
#include <iostream>
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF

# Test GCC
echo -e "\nTesting GCC:"
g++ --version
g++ -v test.cpp -o test_gcc 2>&1
if [ $? -eq 0 ]; then
    echo "GCC compilation successful"
    ./test_gcc
else
    echo "GCC compilation failed"
fi

# Test Clang
echo -e "\nTesting Clang:"
clang++ --version
clang++ -v test.cpp -o test_clang 2>&1
if [ $? -eq 0 ]; then
    echo "Clang compilation successful"
    ./test_clang
else
    echo "Clang compilation failed"
fi

# Check for libstdc++ and libc++
echo -e "\nChecking for C++ libraries:"
ldconfig -p | grep libstdc++
ldconfig -p | grep libc++

# Check system default C and C++ compilers
echo -e "\nChecking system default compilers:"
ls -l /etc/alternatives/cc
ls -l /etc/alternatives/c++

echo -e "\nScript complete. Please review the output for any issues."