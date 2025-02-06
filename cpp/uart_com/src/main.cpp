//=============================================================================
// [Filename]       main.cpp
// [Project]        uart_ip
// [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]       C++ 17
// [Created]        Jan 2025
// [Modified]
// [Description]    C++ code to perform UART communication
// [Notes]          This project uses this library
//                  https://github.com/wjwwood/serial
// [Status]         stable
// [Revisions]
//=============================================================================

#include <iostream>
#include <string>
#include <thread>
#include <chrono>
#include "serial/serial.h"

int main(int argc, char** argv){
  std::cout << "[Ports]" << std::endl;
  auto ports = serial::list_ports();
  for (auto port : ports) {
    std::cout << port.port;
    std::cout << std::endl;
  }

  std::cout << std::endl;

  serial::Serial my_serial(
    "/dev/ttyUSB1",
    115200,
    serial::Timeout::simpleTimeout(10000),
    serial::bytesize_t::eightbits,
    serial::parity_t::parity_none,
    serial::stopbits_t::stopbits_one
  );

  std::string send_buffer;
  std::string receive_buffer;

  // Write to the serial port
  std::cout << "[INFO]: Writing data" << std::endl;
  send_buffer = "ciro fabian bermudez marquez";
  my_serial.write(send_buffer);

  // Write to the serial port one by one
  for (char c : send_buffer) {
    my_serial.write(std::string(1, c));
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
  }

  // Reading from the serial port
  std::cout << "[INFO]: Reading data" << std::endl;
  receive_buffer = my_serial.read(4);
  std::cout << "Received message:" << std::endl;
  std::cout << receive_buffer << std::endl;
  std::cout << std::endl;

  // Sending multiple values
  while (true) {
    std::cout << "Enter a character: " << std::endl;
    std::getline(std::cin, send_buffer);

    if ("exit" == send_buffer) {
      break;
    }

    my_serial.write(send_buffer);

  }

  my_serial.close();
  
  return 0;
}

// g++ -Wall -o main main.cpp $(find ./serial/src -type f -name "*.cc") -I ./serial/include
