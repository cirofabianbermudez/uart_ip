`timescale 1ns / 100ps

// Oversamplig = 16
//      F_fpga = 100_000_000
//    BaudRate = 115200

module uart_tx #(
  parameter WordLength = 8,
  parameter StopBitTicks = 16
) ( 
  input  logic       clk,
  input  logic       rst,
  input  logic       start_tx_i,
  input  logic       tick_i,
  input  logic [7:0] din_i,
  output logic       tx_o,
  output logic       eotx_o
);

  typedef enum {idle , start, data , stop} state_type;

  state_type  state_reg, state_next;  // State register
  logic [3:0] s_reg    , s_next;      // Sample ticks counter
  logic [2:0] n_reg    , n_next;      // Data bit counter
  logic [7:0] b_reg    , b_next;      // Data buffer shift register
  logic       tx_reg   , tx_next;     // Sequential output
  
  always_ff @(posedge clk, posedge rst) begin
    if (rst_i) begin 
      state_reg <= idle;
          s_reg <= 0;
          n_reg <= 0;
          b_reg <= 0;
         tx_reg <= 1'b1;
    end else begin
      state_reg <= state_next;
          s_reg <= s_next;
          n_reg <= n_next;
          b_reg <= b_next;
         tx_reg <= tx_next;
    end
  end
  
  always_comb begin
    state_next = state_reg;
    eotx_o   = 1'b0;
    s_next  = s_reg;
    n_next  = n_reg;
    b_next  = b_reg;
    tx_next = tx_reg;
    case (state_reg)
      idle: begin
              tx_next = 1'b1;
              if (start_tx_i) begin
                state_next = start;
                s_next = 0;
                b_next = din_i;
              end
            end
     start: begin
              tx_next = 1'b0;
              if (tick_i) begin
                if (s_reg == 15) begin
                  state_next = data;
                  s_next = 0;
                  n_next = 0;
                end else begin
                  s_next = s_reg + 1;
                end
              end
            end
      data: begin
              tx_next = b_reg[0];
              if (tick_i) begin
                if (s_reg == 15) begin
                  s_next = 0;
                  b_next = b_reg >> 1;
                  if (n_reg == (WordLength-1)) begin
                    state_next = stop;
                  end else begin
                    n_next = n_reg + 1;
                  end
                end else begin
                  s_next = s_reg + 1;
                end
              end
            end
      stop: begin
              tx_next = 1'b1;
              if (tick_i) begin
                if (s_reg == (StopBitTicks-1)) begin
                  state_next = idle;
                  eotx_o = 1'b1;
                end else begin
                  s_next = s_reg + 1;
                end
              end
            end
    endcase
  end
  
  assign tx_o = tx_reg;
  
endmodule