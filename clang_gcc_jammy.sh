#!/bin/bash

set -e

echo "This script will set up GCC and Clang on Ubuntu Jammy (22.04)."
echo "It requires sudo access and will modify system packages."
echo "Please ensure you have a backup of important data before proceeding."
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Update package lists
sudo apt update

# Install required packages
sudo apt install -y software-properties-common wget

# Add LLVM repository
wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
echo "deb [signed-by=/etc/apt/trusted.gpg.d/apt.llvm.org.asc] http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main" | sudo tee /etc/apt/sources.list.d/llvm.list

# Update package lists again
sudo apt update

# Install GCC, Clang, and related tools
sudo apt install -y gcc-11 g++-11 clang-16 lldb-16 lld-16 clangd-16 \
                    clang-tidy-16 clang-format-16 \
                    libc++-16-dev libc++abi-16-dev \
                    libclang-16-dev libclang-cpp16-dev \
                    llvm-16-dev cmake ninja-build \
                    libstdc++-11-dev

# Set up alternatives
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-11 \
                         --slave /usr/bin/gcov gcov /usr/bin/gcov-11

sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 160 \
                         --slave /usr/bin/clang++ clang++ /usr/bin/clang++-16 \
                         --slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-16
sudo update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-16 160
sudo update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-16 160

# Set up Clang as an alternative for cc and c++
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 160
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 160

# Set Clang as the default compiler
sudo update-alternatives --set cc /usr/bin/clang
sudo update-alternatives --set c++ /usr/bin/clang++

# Create clang environment setup file
cat << EOF > $HOME/compiler-switch.sh
# Clang environment variables
export CC=clang
export CXX=clang++
export LDFLAGS="-fuse-ld=lld"
export CXXFLAGS="-stdlib=libc++"
export PATH="/usr/lib/llvm-16/bin:\$PATH"

# Ensure pkg-config finds Clang libraries
export PKG_CONFIG_PATH="/usr/lib/llvm-16/lib/pkgconfig:\$PKG_CONFIG_PATH"

# Set default compiler flags for Clang
export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="\$CFLAGS -stdlib=libc++"

# Use Clang's linker
export LDFLAGS="-fuse-ld=lld"

# Use Clang's standard library
export LD_LIBRARY_PATH="/usr/lib/llvm-16/lib:\$LD_LIBRARY_PATH"

# Set up for debugging with LLDB
alias lldb='lldb-16'

# Prefer Clang tools
alias clang-tidy='clang-tidy-16'
alias clang-format='clang-format-16'
alias clangd='clangd-16'

# Function to switch to GCC if needed
gcc_mode() {
    export CC=gcc
    export CXX=g++
    export CXXFLAGS="-march=native -O2 -pipe"
    unset LDFLAGS
    echo "Switched to GCC mode"
}

# Function to switch back to Clang
clang_mode() {
    export CC=clang
    export CXX=clang++
    export CXXFLAGS="-march=native -O2 -pipe -stdlib=libc++"
    export LDFLAGS="-fuse-ld=lld"
    echo "Switched to Clang mode"
}

# Default to Clang mode
clang_mode

# Custom aliases
alias docker-custom=\$HOME/builds/cli/build/docker
alias docker-system=/usr/bin/docker
EOF

# Add source command to .bashrc if not already present
if ! grep -q "source.*compiler-switch.sh" $HOME/.bashrc; then
    echo "source \$HOME/compiler-switch.sh" >> $HOME/.bashrc
fi

# Add aliases to .bashrc if not already present
if ! grep -q "alias docker-custom" $HOME/.bashrc; then
    echo "alias docker-custom=\$HOME/builds/cli/build/docker" >> $HOME/.bashrc
fi

if ! grep -q "alias docker-system" $HOME/.bashrc; then
    echo "alias docker-system=/usr/bin/docker" >> $HOME/.bashrc
fi

echo "Script completed. Please restart your terminal or run 'source ~/.bashrc' to apply changes."
echo "You can switch between Clang and GCC using the 'clang_mode' and 'gcc_mode' functions."

# Verify installations
echo "Verification of installations:"
echo "GCC version:"
gcc --version
echo "G++ version:"
g++ --version
echo "Clang version:"
clang --version
echo "Clang++ version:"
clang++ --version