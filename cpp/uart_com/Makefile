##=============================================================================
## [Filename]       Makefile
## [Project]        uart_ip
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        Nov 2024
## [Modified]       -
## [Description]    Makefile to manage C++ code
## [Notes]          g++ -Wall -o main main.cpp $(find ./serial/src -type f -name "*.cc") -I ./serial/include
## [Status]         devel
## [Revisions]      -
##=============================================================================

# ===============================  VARIABLES  =================================

# Miscellaneous variables
CUR_DATE := $(shell date +%Y-%m-%d_%H-%M-%S)

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
INC_DIR := include

# Compiler and flags
CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -I ./$(INC_DIR)
LDFLAGS += -lpthread
#CXXFLAGS := -std=c++23

# Output executable
TARGET := $(BIN_DIR)/app

# Files
SRCS := $(shell find $(SRC_DIR) -name "*.cpp" -or -name "*.cc")
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRCS))
OBJS := $(patsubst $(SRC_DIR)/%.cc, $(OBJ_DIR)/%.o, $(OBJS))


# Colors
C_RED := \033[31m
C_GRE := \033[32m
C_BLU := \033[34m
C_YEL := \033[33m
C_ORA := \033[38;5;214m
NC    := \033[0m 

# ================================  TARGETS  ==================================

.DEFAULT_GOAL := all

.PHONY: all
all: help

check:
	@echo "$(SRCS)"
	@echo "---"
	@echo "$(OBJS)"
#______________________________________________________________________________

.PHONY: compile
compile: $(TARGET) ## Compile the app
#______________________________________________________________________________

# Rule to compile source files to object files cpp
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	@echo -e "$(C_ORA)Compiled: $< -> $@ $(NC)"
	$(CXX) $(CXXFLAGS) -c $< -o $@
	
# Rule to compile source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	@mkdir -p $(dir $@)
	@echo -e "$(C_ORA)Compiled: $< -> $@ $(NC)"
	$(CXX) $(CXXFLAGS) -c $< -o $@
#______________________________________________________________________________

# Rule to create the executable
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	@echo -e "$(C_ORA)Linked: $@ $(NC)"
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LDFLAGS)
#______________________________________________________________________________

.PHONY: run
run: ## Run C++ code
	@echo -e "$(C_ORA)Running $(TARGET) $(NC)"
	./$(TARGET)
#______________________________________________________________________________

.PHONY: clean
clean: ## Remove compilation and executable files
	@echo -e "$(C_ORA)Removing compilation files$(NC)"
	rm -rf $(OBJ_DIR) $(BIN_DIR)
#______________________________________________________________________________

.PHONY: help
help: ## Display help message
	@echo ""
	@echo "====================================================================="
	@echo "Usage: make <target> "
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "- make \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "====================================================================="
	@echo ""
