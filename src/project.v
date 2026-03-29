/*
 * Copyright (c) 2026 Nicklaus Thompson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_simple_spacewar (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Set inout pins to outputs
  assign uio_oe  = 8'hFF;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};
  
  // Ship details
  reg [7:0] ship_x [1:0];
  reg [6:0] ship_y [1:0];
  reg [2:0] ship_rot [1:0];
  
  // XY position table. Format: X, Y, Connect to next
  reg [15:0] xy_points [15:0];
  
  // Assign XY positions
  always @ (posedge clk) begin
    // Bounding box
    if (~rst_n) begin
      xy_points[0] <= 16'h0;
      xy_points[1] <= 16'h0;
      xy_points[2] <= 16'h0;
      xy_points[3] <= 16'h0;
      xy_points[4] <= 16'h0;
    end else begin
      xy_points[0] <= {8'h00, 7'h00, 1'b1};
      xy_points[1] <= {8'hFF, 7'h00, 1'b1};
      xy_points[2] <= {8'hFF, 7'h3F, 1'b1};
      xy_points[3] <= {8'h00, 7'h3F, 1'b1};
      xy_points[4] <= {8'h00, 7'h00, 1'b0};
    end // if
    
    // Ships, Lasers
    
    // Unused
    xy_points[05] <= 16'h0;
    xy_points[06] <= 16'h0;
    xy_points[07] <= 16'h0;
    xy_points[08] <= 16'h0;
    xy_points[09] <= 16'h0;
    xy_points[10] <= 16'h0;
    xy_points[11] <= 16'h0;
    xy_points[12] <= 16'h0;
    xy_points[13] <= 16'h0;
    xy_points[14] <= 16'h0;
    xy_points[15] <= 16'h0;
  end // always @ (posedge clk)
  
  // Display positions
  reg [31:0] counter_value;
  always @ (posedge clk) begin
    if (~rst_n) begin
      counter_value <= 0;
    end else begin
      counter_value <= counter_value + 32'b1;
    end // if
  end // always @ (posedge clk)
  
  assign {uio_out, uo_out} = xy_points[counter_value[22:19]];

endmodule
