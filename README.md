# GCC/Clang Compiler Switching Project

## Motivation

This project was born out of the need to seamlessly switch between GCC and Clang compilers in a Unix-like environment. The motivation behind this effort stems from several key factors:

1. **Cross-compiler compatibility**: Ensuring that code can be compiled and run correctly with both GCC (using libstdc++) and Clang (using libc++) is crucial for maintaining portability and catching potential compatibility issues early in the development process.

2. **Performance optimization**: Different compilers may produce more efficient code for specific architectures or use cases. The ability to easily switch between compilers allows developers to benchmark and optimize their code more effectively.

3. **Toolchain flexibility**: Some development tools or libraries may work better with one compiler over the other. A flexible switching mechanism allows developers to leverage the strengths of each compiler as needed.

4. **Continuous Integration (CI) robustness**: By testing with multiple compilers, CI pipelines can catch a wider range of potential issues and ensure broader compatibility of the codebase.

## Project Challenges

Implementing a seamless switching mechanism between GCC and Clang proved to be more challenging than initially anticipated. Some of the key difficulties we faced include:

1. **Environment variable conflicts**: Ensuring that all relevant environment variables are correctly set (and unset) when switching between compilers was tricky. Lingering variables from one compiler could interfere with the other.

2. **Library path management**: Managing the `LIBRARY_PATH` and `LD_LIBRARY_PATH` to point to the correct standard libraries for each compiler required careful consideration and testing.

3. **Linker issues**: Ensuring that Clang uses the LLVM linker (lld) instead of the system's default linker was crucial for avoiding conflicts with GCC's libraries.

4. **Compiler flag compatibility**: Some flags are specific to one compiler and can cause errors if accidentally used with the other. Managing these flags correctly was essential.

5. **System-wide configurations**: Overcoming system-wide compiler configurations that might override our custom settings required thorough investigation and testing.

6. **Build system integration**: Integrating the switching mechanism into existing build systems (like Make) in a clean and maintainable way posed its own set of challenges.

## Solution: System Setup or Docker Container

To address these challenges and provide a robust solution, we recommend setting up either a dedicated system or a Docker container for seamless GCC/Clang switching. Here's why this approach is beneficial:

1. **Isolated environment**: A dedicated system or Docker container provides an isolated environment where we can control all relevant variables and paths without interfering with the host system.

2. **Reproducibility**: Docker containers, in particular, ensure that the development environment is consistent across different machines, making it easier to reproduce builds and diagnose issues.

3. **Version control**: With a containerized approach, it's easier to manage and switch between different versions of GCC and Clang, allowing for even greater flexibility in testing and development.

4. **Simplified onboarding**: New team members can quickly set up a working environment by pulling a Docker image or following a well-defined system setup script, reducing onboarding time and potential configuration issues.

5. **CI/CD integration**: A containerized setup can be easily integrated into CI/CD pipelines, ensuring consistent testing across different environments.

## Project Components

This project consists of several key components that work together to achieve seamless compiler switching:

1. `clang_env_vars.sh`: A shell script that sets up the environment for each compiler, managing all necessary environment variables.
2. `Makefile`: Utilizes the shell script to build the project with both compilers, demonstrating the switching mechanism in action.
3. `main.cpp`: A simple C++ program that verifies the build process and demonstrates the use of compiler-specific features.
4. `clang_gcc_jammy.sh`: A setup script for Ubuntu Jammy (22.04) that installs and configures both GCC and Clang.

## Getting Started

To use this project, follow these steps:

1. Clone the repository to your local machine.
2. If using Ubuntu Jammy (22.04), run the `clang_gcc_jammy.sh` script to set up your system. Otherwise, adapt the script for your specific environment.
3. Source the `clang_env_vars.sh` script in your shell: `source ~/clang_env_vars.sh`
4. Use the `gcc_mode` and `clang_mode` functions to switch between compilers.
5. Run `make` to build the project with both compilers and see the switching in action.

## Common Issues and Solutions

If the test breaks, consider the following:

1. **Lingering Environment Variables:** Ensure that all compiler-specific variables are unset when switching modes. Check for variables like `GCC_EXEC_PREFIX`, `COMPILER_PATH`, and `CPATH`.

2. **Incorrect Linker:** Verify that Clang is using the LLVM linker (lld) and not the system's default linker. The `LD` variable should be set to `lld` in Clang mode.

3. **Library Path Issues:** Check that `LIBRARY_PATH` and `LD_LIBRARY_PATH` are set correctly for each compiler, pointing to the appropriate standard library locations.

4. **Compiler Flags:** Ensure that `-stdlib=libc++` is included in `CXXFLAGS` for Clang, and that no Clang-specific flags are present for GCC.

5. **System-wide Configurations:** Look for any system-wide compiler configurations that might be overriding your settings. Check files like `/etc/environment`, `/etc/profile`, and any `.bashrc` or `.bash_profile` files.

## Debugging Tips

- Use the `-v` flag with your compiler commands to see the detailed compilation and linking process.
- Check the output of `ldd` on the produced executables to verify which libraries they're linked against.
- Use `env` to print all environment variables and check for any unexpected settings.

## Conclusion

While setting up a seamless switching mechanism between GCC and Clang presented significant challenges, the resulting system provides valuable flexibility and robustness for C++ development. By leveraging either a dedicated system setup or a Docker container, we've created a solution that allows developers to easily switch between compilers, catch compatibility issues early, and leverage the strengths of both GCC and Clang in their development workflow.