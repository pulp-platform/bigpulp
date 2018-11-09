module uart_rx #(
  parameter unsigned CLK_FREQ_HZ,
  parameter unsigned BAUD_RATE
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        rx_i,
  output logic        oup_valid_o,
  output logic [7:0]  oup_data_o
);

  localparam unsigned CYCLES_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;
  localparam unsigned CNT_WIDTH = $clog2(CYCLES_PER_BIT);

  typedef enum logic [2:0] { Idle, Start, Data, Stop, Output } state_t;

  logic [2:0]           bit_idx_d,  bit_idx_q;

  logic [CNT_WIDTH-1:0] cnt_d,      cnt_q;

  state_t               state_d,    state_q;

  logic [7:0]           data_d,     data_q;

  always_comb begin
    bit_idx_d   = bit_idx_q;
    cnt_d       = cnt_q;
    data_d      = data_q;
    oup_valid_o = 1'b0;
    state_d     = state_q;

    case (state_q)
      Idle: begin
        // Reset counters.
        bit_idx_d = '0;
        cnt_d     = '0;
        // Check if Start Bit received.
        if (rx_i == 1'b0) begin
          state_d = Start;
        end
      end

      Start: begin
        // Increment counter.
        cnt_d = cnt_q + 1;
        // At half the cycles per bit, check the input to see if the Start Bit is still applied.
        if (cnt_q == (CYCLES_PER_BIT - 1) / 2) begin
          if (rx_i == 1'b0) begin
            // If so, reset counter and start receiving.
            cnt_d = '0;
            state_d = Data;
          end else begin
            // Otherwise go back to idle.
            state_d = Idle;
          end
        end
      end

      Data: begin
        // Increment counter.
        cnt_d = cnt_q + 1;
        // When the number of cycles per bit is reached, reset the counter and sample the input.
        if (cnt_q >= CYCLES_PER_BIT - 1) begin
          cnt_d = '0;
          data_d[bit_idx_q] = rx_i;
          if (bit_idx_q == 3'd7) begin
            // If this is the last bit of the byte, go to the Stop Bit state.
            bit_idx_d = '0;
            state_d = Stop;
          end else begin
            // Otherwise increment the bit index and continue receiving data.
            bit_idx_d = bit_idx_q + 1;
          end
        end
      end

      Stop: begin
        // Increment counter.
        cnt_d = cnt_q + 1;
        // When the number of cycles per bit is reached, reset the counter, mark the output as
        // valid for this cycle, and go back to Idle.
        if (cnt_q >= CYCLES_PER_BIT - 1) begin
          cnt_d       = '0;
          oup_valid_o = 1'b1;
          state_d     = Idle;
        end
      end

      default: state_d = Idle;
    endcase
  end

  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (!rst_ni) begin
      bit_idx_q <= '0;
      cnt_q     <= '0;
      data_q    <= '0;
      state_q   <= Idle;
    end else begin
      bit_idx_q <= bit_idx_d;
      cnt_q     <= cnt_d;
      data_q    <= data_d;
      state_q   <= state_d;
    end
  end

  assign oup_data_o = data_q;

endmodule
