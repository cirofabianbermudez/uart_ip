`timescale 1ns / 100ps

// baud_gen generates a clock signal 16 times faster than the selected baud rate

// Equation
// f_fpga

// Paramaters: 

// Baud parameter to be use in the tx and rx
//    Baud        TxTime   CntValue       log2     ceil
//    9600  1041.6667 us   651.0417     9.3466       10
//   19200   520.8333 us   325.5208     8.3466        9
//   28800   347.2222 us   217.0139     7.7616        8
//   38400   260.4167 us   162.7604     7.3466        8
//   57600   173.6111 us   108.5069     6.7616        7
//   76800   130.2083 us    81.3802     6.3466        7
//  115200    86.8056 us    54.2535     5.7616        6
//  230400    43.4028 us    27.1267     4.7616        5
//  460800    21.7014 us    13.5634     3.7616        4
//  576000    17.3611 us    10.8507     3.4397        4
//  921600    10.8507 us     6.7817     2.7616        3

module baud_gen (
  input         clk_i,
  input         rst_i,
  input  [10:0] dvsr,
  output        tick_o
);
_d, _q	signal name	Input and output of register
  logic [10:0] baud_counter_q;
  logic [10:0] baud_counter_d;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      baud_counter_q <= '0;
    end else begin
      baud_counter_q <= baud_counter_d;
    end
  end

  assign baud_counter_d = (baud_counter == BaudCounterMax-1) ? 1'b1 : 1'b0;
  
  assign tick_o = baud_done;

endmodule
