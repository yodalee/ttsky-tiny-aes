/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_yodalee_tinyaes (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire i_ready;
  wire o_valid;
  wire [7:0] o_data;
  logic [1:0] i_valid_sync;
  logic [1:0] o_ready_sync;
  logic i_valid_sync_d;
  logic o_ready_sync_d;
  wire i_valid_pulse = i_valid_sync[1] & ~i_valid_sync_d;
  wire o_ready_pulse = o_ready_sync[1] & ~o_ready_sync_d;

  always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        i_valid_sync <= 2'b00;
        o_ready_sync <= 2'b00;
        i_valid_sync_d <= 1'b0;
        o_ready_sync_d <= 1'b0;
      end else begin
        i_valid_sync <= {i_valid_sync[0], ui_in[0]};
        o_ready_sync <= {o_ready_sync[0], ui_in[1]};
        i_valid_sync_d <= i_valid_sync[1];
        o_ready_sync_d <= o_ready_sync[1];
      end
    end

  AesTop i_aes_top (
      .clk(clk),
      .rst_n(rst_n),
      .r_dec(ui_in[6]),
      .r_level(ui_in[5:4]),
      .i_valid(i_valid_pulse),
      .i_ready(i_ready),
      .i_data(uio_in),
      .o_valid(o_valid),
      .o_ready(o_ready_pulse),
      .o_data(o_data)
  );

  assign uo_out = {6'b0, o_valid, i_ready};
  assign uio_out = o_data;
  assign uio_oe = {8{o_valid}};

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7], ui_in[3:2]};

endmodule
