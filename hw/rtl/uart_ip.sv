///////////////////////////////////////////////////////////////////////////////////
// [Filename]       uart_tx.sv
// [Project]        uart_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    UART IP module.
// [Notes]          This code uses an oversamplig of 16.
//                  Asynchronous active high reset signal
//                  The number of stop bits can be set to 1, 1.5, or 2.
//                  This code does not consider the parity bit.
//                  FIFO Depth: 2^FifoAddrBits
// [Status]         Stable
// [Revisions]      -
///////////////////////////////////////////////////////////////////////////////////

module uart_ip #(
    parameter int WordLength   = 8,
    parameter int StopBitTicks = 16,
    parameter int FifoAddrBits = 3
) (
    input         clk_i,
    input         rst_i,
    input         rd_uart_i,
    input         wr_uart_i,
    input         rx_i,
    input  [7:0]  w_data_i,
    input  [10:0] dvsr_i,
    //input         start_tx_i,
    output [7:0]  r_data_o,
    output        tx_o,
    //output        rx_done_tick_o,
    //output        tx_done_tick_o,
    output        tx_full_o,
    output        rx_empty_o
);

  // Signal declaration
  wire tick;
  wire rx_done_tick, tx_done_tick;
  wire [WordLength-1:0] tx_fifo_out, rx_data_out;
  wire tx_empty, tx_fifo_not_empty;

  // Baud rate generator 
  baud_gen baud_gen_inst(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .dvsr_i(dvsr_i),
    .tick_o(tick)
  );
  
  // UART Receiver
  uart_rx #(
    .WordLength  (WordLength),
    .StopBitTicks(StopBitTicks)
  ) uart_rx_inst(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rx_i(rx_i),
    .sample_tick_i(tick),
    .rx_done_tick_o(rx_done_tick),
    .dout_o(rx_data_out)
  );

  // UART Transmitter
  uart_tx #(
    .WordLength  (WordLength),
    .StopBitTicks(StopBitTicks)
  ) uart_tx_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .start_tx_i(tx_fifo_not_empty),
    .sample_tick_i(tick),
    .din_i(tx_fifo_out),
    .tx_o(tx_o),
    .tx_done_tick_o(tx_done_tick)
  );
  
  // FIFO for transmitter
  fifo_ip #(
    .WordLength(WordLength),
    .AddrBits  (FifoAddrBits)
  ) fifo_tx_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rd_i(tx_done_tick),
    .wr_i(wr_uart_i),
    .w_data_i(w_data_i),
    .r_data_o(tx_fifo_out),
    .empty_o(tx_empty),
    .full_o(tx_full_o)
  );
  
  assign tx_fifo_not_empty = ~tx_empty;

  // FIFO for receiver
  fifo_ip #(
    .WordLength(WordLength),
    .AddrBits  (FifoAddrBits)
  ) fifo_rx_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rd_i(rd_uart_i),
    .wr_i(rx_done_tick,),
    .w_data_i(rx_data_out),
    .r_data_o(r_data_o),
    .empty_o(rx_empty_o),
    .full_o()
  );

endmodule : uart_ip
