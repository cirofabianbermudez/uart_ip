##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## [Filename]       Makefile
## [Project]        uart_ip
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       GNU Makefile
## [Created]        Nov 2024
## [Modified]       -
## [Description]    Makefile to manage C++ code
## [Notes]          -
## [Status]         devel
## [Revisions]      -
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## common variables
CUR_DATE := $(shell date +%Y-%m-%d_%H-%M-%S)
GIT_ROOT := $(shell git rev-parse --show-toplevel)
CPP_DIR  := $(GIT_ROOT)/cpp

## colors
C_RED := \033[31m
C_GRE := \033[32m
C_BLU := \033[34m
C_YEL := \033[33m
C_ORA := \033[38;5;214m
NC    := \033[0m 

# Variables
CXX = g++
CXXFLAGS = -std=c++23
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)
TARGET = uart

all: help

# Rule to compile every .cpp to a .o
%.o: %.cpp
	@echo "> Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	@echo "> Linking object files"
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET) 

.PHONY: run
run:
	@echo "> Running $(TARGET)"
	./$(TARGET)

.PHONY: clean
clean:
	@echo "> Removing *.exe and *.o"
	rm -rf *.o *.exe *.txt *.png *.pdf $(TARGET)

.PHONY: help
help: ## Display help message
	@echo ""
	@echo "============================================================="
	@echo "Usage: make <target> simulator=vcs [mode=gui|tcl|batch] [variables]"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "- make \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo ""
	@echo "   % make area"
	@echo "   % make digital"
	@echo "   % make ams"
	@echo "============================================================="
	@echo ""
