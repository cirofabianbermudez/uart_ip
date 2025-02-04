#!/usr/bin/env python3

##=============================================================================
## [Filename]       uart.py
## [Project]        uart_ip
## [Author]         Ciro Bermudez - cirofabian.bermudez@gmail.com
## [Language]       Python 3.10.12
## [Created]        Jan 2025
## [Modified]
## [Description]    Python script to perform UART communication
## [Notes]
## [Status]         stable
## [Revisions]
##=============================================================================

import serial
import time

# =================================== MAIN ====================================

def main():
    """Main method"""

    # Open serial port
    print("[INFO]: Serial port open")
    serial_port = serial.Serial(
        port="/dev/ttyUSB1",
        baudrate=115200,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=None
    )


    # Write to serial port
    print("[INFO]: Writing data")
    info = "ciro fabian bermudez marquez"
    data = bytes(info, "utf-8")
    res = serial_port.write(data)

    for char in info:
        data = bytes(char, "utf-8")
        res = serial_port.write(data)
        time.sleep(0.1)

    # Read from serial port
    print("[INFO]: Reading data")
    serial_port.reset_input_buffer()
    data_read = serial_port.read(size=4)
    print(data_read)

    # Send values
    while(True):
        info = input("Enter a character: ")

        if (info == "exit"):
            break

        data = bytes(info, "utf-8")
        res = serial_port.write(data)


    # Close serial port
    serial_port.close()

if __name__ == "__main__":
    main()

