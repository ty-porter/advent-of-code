SHELL := /bin/bash
CXX = g++
CXXFLAGS = -std=c++17 -O2 -Wall -Wextra
COMMON = common
BUILD_DIR = build

# Generate list of days: 01 02 03 ... 12
DAYS := $(shell printf "%02d " {1..12})

# Default target
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make 01           - Build day 01"
	@echo "  make run01        - Run day 01"
	@echo "  make test01       - Build and run day 01"
	@echo "  make clean        - Clean all executables"

# Mark all day patterns as phony
.PHONY: $(DAYS)

# Pattern rule for building a day
$(DAYS):
	@mkdir -p $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) -I$(COMMON) $@/main.cpp -o $(BUILD_DIR)/$@.o
	@echo "Built day $@"

# Pattern rule for running a day
run%:
	@$(BUILD_DIR)/$*.o $*/prompt.txt

# Pattern rule for build and run
test%:
	@$(MAKE) $* --no-print-directory
	@$(MAKE) run$* --no-print-directory

# Clean all executables
.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleaned build directory"
