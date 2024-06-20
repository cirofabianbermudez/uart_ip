# Variables
CXX = g++
CXXFLAGS = -std=c++23
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)
TARGET = uart

# Targets
.PHONY: run clean

all: $(TARGET) run

# Rule to compile every .cpp to a .o
%.o: %.cpp
	@echo "> Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	@echo "> Linking object files"
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET) 

run:
	@echo "> Running $(TARGET)"
	./$(TARGET)

clean:
	@echo "> Removing *.exe and *.o"
	rm -rf *.o *.exe *.txt *.png *.pdf $(TARGET)
