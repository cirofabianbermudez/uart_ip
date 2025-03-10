///////////////////////////////////////////////////////////////////////////////////
// [Filename]       reg_file.sv
// [Project]        fifo_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    Generic register file
// [Notes]          Syncronous write operation
//                  Asyncronous read operaton
//                  Depth: 2^AddrBits
//                  Width: WordLength
// [Status]         Stable
// [Revisions]      -
///////////////////////////////////////////////////////////////////////////////////

module reg_file #(
    parameter int WordLength = 8,
    parameter int AddrBits   = 3
) (
    input  logic                  clk_i,
    input  logic                  wr_en_i,
    input  logic [  AddrBits-1:0] w_addr_i,
    input  logic [  AddrBits-1:0] r_addr_i,
    input  logic [WordLength-1:0] w_data_i,
    output logic [WordLength-1:0] r_data_o
);

  // Memory declaration
  logic [WordLength-1:0] reg_array [0:2**AddrBits-1];

  // Write operation
  always_ff @(posedge clk_i) begin
    if (wr_en_i) begin
      reg_array[w_addr_i] <= w_data_i;
    end
  end

  // Read operation
  assign r_data_o = reg_array[r_addr_i];

endmodule : reg_file

