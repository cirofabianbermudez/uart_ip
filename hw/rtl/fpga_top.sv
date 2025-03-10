///////////////////////////////////////////////////////////////////////////////////
// [Filename]       fpga_top.sv
// [Project]        uart_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    Nexys A7 UART IP testing code.
// [Notes]          This code uses an oversamplig of 16.
// [Status]         Stable
// [Revisions]      -
///////////////////////////////////////////////////////////////////////////////////

module top #(
    parameter int WordLength   = 8,
    parameter int StopBitTicks = 16,
    parameter int FifoAddrBits = 2
) (
    input         clk_i,
    input         rst_i,
    input         wr_btn_i,
    input         rd_btn_i,
    input  [7:0]  din_i,
    input         rx_i,
    output [7:0]  dout_o,
    output        tx_o,
    output        tx_full_o,
    output        rx_full_o
);

  // Signal Declaration
  wire tick_rx, tick_tx;
  wire [10:0] dvsr = 11'd54;           // 115200 baudrate
  localparam fpga_freq = 100_000_000;  // 100 MHz
  localparam db_baud = 1_000;          // 10 ms debounce time

  // Instantiation
  uart_ip #(
    .WordLength  (WordLength),
    .StopBitTicks(StopBitTicks),
    .FifoAddrBits(FifoAddrBits)
  ) uart_ip_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rd_uart_i(tick_rx),
    .wr_uart_i(tick_tx),
    .rx_i(rx_i),
    .w_data_i(din_i),
    .r_data_o(dout_o),
    .dvsr_i(dvsr),
    .tx_o(tx_o),
    .tx_full_o(tx_full_o),
    .rx_empty_o(rx_full_o)
  );
  
  debouncer_ip #(
    .ClkRate(fpga_freq),
    .Baud(db_baud)
  ) debouncer_rx_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .sw_i(rd_btn_i),
    .db_level_o(),
    .db_tick_o(tick_rx)
  );

  debouncer_ip #(
    .ClkRate(fpga_freq),
    .Baud(db_baud)
  ) debouncer_tx_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .sw_i(wr_btn_i),
    .db_level_o(),
    .db_tick_o(tick_tx)
  );
  
endmodule : top
