#include <iostream>
#include <iomanip>
#include <vector>
#include <cmath>

int main(int argc, char** argv){

  std::vector<double> speeds = {9600, 19200, 28800, 38400, 57600, 76800, 115200, 230400, 460800, 576000, 921600};
  double freq_fpga = 100e6;
  double oversample = 16.0;
  double counter_value = 0.0;

  std::cout << std::fixed << std::setprecision(4);
  std::cout << "// "<< "   Baud"
                    <<  "        TxTime"
                    <<  "   CntValue"
                    <<  "       log2"
                    <<  "     ceil" << std::endl;



  for (std::size_t i = 0; i < speeds.size(); i++) {
    counter_value = freq_fpga / (speeds[i]*oversample);
    std::cout << "// " << std::setw(7) << (int)speeds[i] << "  "
                       << std::setw(9) << (10.0 / speeds[i])*1e6 << " us  "
                       << std::setw(9) << counter_value << "  "
                       << std::setw(9) << std::log2(counter_value) << "  "
                       << std::setw(7) << (int)std::ceil( std::log2(counter_value) ) << std::endl;
  }

  return 0;
}
