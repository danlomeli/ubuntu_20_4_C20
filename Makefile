ENV_SCRIPT = $(HOME)/compiler-switch.sh

SRCS = main.cpp
GCC_TARGET = my_program_gcc
CLANG_TARGET = my_program_clang

.PHONY: all gcc_build clang_build clean diagnostic

all: gcc_build clang_build

diagnostic:
	@echo "Running diagnostics for GCC mode..."
	@bash -c 'source $(ENV_SCRIPT) && gcc_mode && \
		echo "GCC Mode Variables:" && \
		echo "CC: $$CC" && \
		echo "CXX: $$CXX" && \
		echo "CFLAGS: $$CFLAGS" && \
		echo "CXXFLAGS: $$CXXFLAGS" && \
		echo "LDFLAGS: $$LDFLAGS" && \
		echo "LIBRARY_PATH: $$LIBRARY_PATH" && \
		echo "LD_LIBRARY_PATH: $$LD_LIBRARY_PATH" && \
		echo "CPLUS_INCLUDE_PATH: $$CPLUS_INCLUDE_PATH" && \
		echo "PATH: $$PATH"'
	
	@echo "\nRunning diagnostics for Clang mode..."
	@bash -c 'source $(ENV_SCRIPT) && clang_mode && \
		echo "Clang Mode Variables:" && \
		echo "CC: $$CC" && \
		echo "CXX: $$CXX" && \
		echo "CFLAGS: $$CFLAGS" && \
		echo "CXXFLAGS: $$CXXFLAGS" && \
		echo "LDFLAGS: $$LDFLAGS" && \
		echo "LIBRARY_PATH: $$LIBRARY_PATH" && \
		echo "LD_LIBRARY_PATH: $$LD_LIBRARY_PATH" && \
		echo "CPLUS_INCLUDE_PATH: $$CPLUS_INCLUDE_PATH" && \
		echo "PATH: $$PATH" && \
		echo "CLANG_USE_LIBCXX: $$CLANG_USE_LIBCXX" && \
		echo "LD: $$LD"'

gcc_build: diagnostic
	@echo "Building with GCC..."
	@bash -c 'source $(ENV_SCRIPT) && gcc_mode && $$CXX $$CXXFLAGS $(SRCS) -o $(GCC_TARGET) $$LDFLAGS && ./$(GCC_TARGET)'

clang_build: diagnostic
	@echo "Building with Clang..."
	@bash -c 'source $(ENV_SCRIPT) && clang_mode && $$CXX $$CXXFLAGS $(SRCS) -o $(CLANG_TARGET) $$LDFLAGS && ./$(CLANG_TARGET)'

clean:
	rm -f $(GCC_TARGET) $(CLANG_TARGET)