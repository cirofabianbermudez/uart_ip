`timescale 1ns / 100ps

// Oversamplig = 16
//      F_fpga = 100_000_000
//    BaudRate = 115200

module uart_rx #(
  parameter WordLength = 8,
  parameter StopBitTicks = 16
) ( 
  input  logic       clk_i,
  input  logic       rst_i,
  input  logic       rx_i,
  input  logic       tick_i,
  output logic       eorx_o,
  output logic [7:0] dout_o
);

  typedef enum {idle , start, data, stop} state_type;

  state_type  state_reg, state_next; // State register
  logic [3:0]     s_reg, s_next;     // Sample ticks counter
  logic [2:0]     n_reg, n_next;     // Data bit counter
  logic [7:0]     b_reg, b_next;     // Data buffer shift register
  
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin 
      state_reg <= idle;
          s_reg <= 0;
          n_reg <= 0;
          b_reg <= 0;
    end else begin
      state_reg <= state_next;
          s_reg <= s_next;
          n_reg <= n_next;
          b_reg <= b_next;
    end
  end
  
  always_comb begin
    state_next = state_reg;
    eorx_o = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    case (state_reg)
      idle: begin
              if (~rx_i) begin
                state_next = start;
                s_next = 0;
              end
            end
     start: begin
              if (tick_i) begin
                if (s_reg == 7) begin
                  state_next = data;
                  s_next = 0;
                  n_next = 0;
                end else begin
                  s_next = s_reg + 1;
                end
              end
            end
      data: begin
              if (tick_i) begin
                if (s_reg == 15) begin
                  s_next = 0;
                  b_next = {rx_i, b_reg[7:1]};
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
              if (tick_i) begin
                if (s_reg == (StopBitsTicks-1)) begin
                  state_next = idle;
                  eorx_o = 1'b1;
                end else begin
                  s_next = s_reg + 1;
                end
              end
            end
    endcase
  end
  
  assign dout_o = b_reg;
  
endmodule