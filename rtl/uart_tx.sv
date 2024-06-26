///////////////////////////////////////////////////////////////////////////////////
// [Filename]       uart_tx.sv
// [Project]        uart_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    UART Transmitter Module.
// [Notes]          This code uses an oversamplig of 16.
//                  Asynchronous active high reset signal
//                  The number of stop bits can be set to 1, 1.5, or 2.
//                  This code does not consider the parity bit.
// [Status]         Stable
///////////////////////////////////////////////////////////////////////////////////

module uart_tx #(
    parameter int WordLength   = 8,
    parameter int StopBitTicks = 16
) (
    input  logic       clk_i,
    input  logic       rst_i,
    input  logic       start_tx_i,
    input  logic       sample_tick_i,
    input  logic [7:0] din_i,
    output logic       tx_o,
    output logic       tx_done_tick_o
);

  typedef enum {
    IDLE,
    START,
    DATA,
    STOP
  } state_type_e;

  state_type_e state_reg, state_next;
  logic [3:0] sample_tick_counter_d, sample_tick_counter_q;
  logic [2:0] data_bit_counter_d, data_bit_counter_q;
  logic [7:0] data_shift_buffer_d, data_shift_buffer_d;
  logic tx_d, tx_q;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg             <= IDLE;
      sample_tick_counter_d <= 'd0;
      data_bit_counter_d    <= 'd0;
      data_shift_buffer_d   <= 'd0;
      tx_d                  <= 1'b1;
    end else begin
      state_reg             <= state_next;
      sample_tick_counter_d <= sample_tick_counter_q;
      data_bit_counter_d    <= data_bit_counter_q;
      data_shift_buffer_d   <= data_shift_buffer_d;
      tx_d                  <= tx_q;
    end
  end

  always_comb begin
    state_next            = state_reg;
    tx_done_tick_o        = 1'b0;
    sample_tick_counter_q = sample_tick_counter_d;
    data_bit_counter_q    = data_bit_counter_d;
    data_shift_buffer_d   = data_shift_buffer_d;
    tx_q                  = tx_d;
    case (state_reg)
      IDLE: begin
        tx_q = 1'b1;
        if (start_tx_i) begin
          state_next            = START;
          sample_tick_counter_q = 'd0;
          data_shift_buffer_d   = din_i;
        end
      end
      START: begin
        tx_q = 1'b0;
        if (sample_tick_i) begin
          if (sample_tick_counter_d == 'd15) begin
            state_next            = DATA;
            sample_tick_counter_q = 'd0;
            data_bit_counter_q    = 'd0;
          end else begin
            sample_tick_counter_q = sample_tick_counter_d + 'd1;
          end
        end
      end
      DATA: begin
        tx_q = data_shift_buffer_d[0];
        if (sample_tick_i) begin
          if (sample_tick_counter_d == 'd15) begin
            sample_tick_counter_q = 'd0;
            data_shift_buffer_d   = data_shift_buffer_d >> 1;
            if (data_bit_counter_d == (WordLength - 1)) begin
              state_next = STOP;
            end else begin
              data_bit_counter_q = data_bit_counter_d + 'd1;
            end
          end else begin
            sample_tick_counter_q = sample_tick_counter_d + 'd1;
          end
        end
      end
      STOP: begin
        tx_q = 1'b1;
        if (sample_tick_i) begin
          if (sample_tick_counter_d == (StopBitTicks - 1)) begin
            state_next     = IDLE;
            tx_done_tick_o = 1'b1;
          end else begin
            sample_tick_counter_q = sample_tick_counter_d + 'd1;
          end
        end
      end
    endcase
  end

  assign tx_o = tx_d;

endmodule : uart_tx

