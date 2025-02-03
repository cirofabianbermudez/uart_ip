Use the following command to check what is the name of the serial port

```bash
ls -l /dev/tty*
sudo dmesg | grep -i serial
```

`minicom` is a classic, full‐featured terminal program for serial communication:

Install (For Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install minicom
```

Configure

```bash
sudo minicom -s
```
- Serial Device to `/dev/ttyUSB1` (or whichever device you have)
- Bps/Par/Bits to `115200 8N1` (for example)
- Hardware Flow Control to `No` (often for FPGA boards)


Exit the setup (select Save setup as dfl if you want to keep these settings).

Launch minicom normally
It will now use your saved settings and connect to the FPGA’s UART.
To exit `minicom`, press `Ctrl+A`, then `X`, and confirm.


PuTTY is also available on Linux and supports serial connections:

Install (for Debian/Ubuntu):

```bash
sudo apt-get update
sudo apt-get install putty
```

Run putty and in the PuTTY Configuration window:

- Select Connection type: Serial
- Under Serial line: /dev/ttyUSB1
- Under Speed (baud): 115200
- Click Open to start the session.


If you prefer a graphical user interface, CuteCom is available on many distros:

```bash
sudo apt-get update
sudoapt-get install cutecom
```

Launch it, select your device (`/dev/ttyUSB1`), set the baud rate (115200, etc.),
configure flow control, then click Open Device.

Common Settings for FPGA UART

- Baud rate: Often 115200
- Data bits: 8
- Parity: None (N)
- Stop bits: 1
- Flow control: Usually None
- Make sure these match whatever is configured on your FPGA’s UART interface.
