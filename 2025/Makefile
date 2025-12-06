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
	@echo "  make new          - Generate a new solution from template"
	@echo "  make build        - Build solution runner"
	@echo "  make run          - Run all solutions with benchmarking"
	@echo "  make run DAY=N    - Run specific day N with benchmarking"
	@echo "  make clean        - Clean all executables"

# Mark all day patterns as phony
.PHONY: $(DAYS)

# Generate a new solution directory
.PHONY: new
new:
	@./generate.sh

# Build the solution executor
.PHONY: build
build:
	@mkdir -p $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) -I$(COMMON) main.cpp -o $(BUILD_DIR)/runner.o
	@echo "Built runner"


# Run the runner, optionally with a day
.PHONY: run
run:
ifdef DAY
	@$(BUILD_DIR)/runner.o $(DAY)
else
	@$(BUILD_DIR)/runner.o
endif

# Clean all executables
.PHONY: clean
clean:
	@find build -name '*.o' -delete
	@echo "Cleaned build directory"
