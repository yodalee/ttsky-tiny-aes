module ControlMixColumn (
	clk,
	rst_n,
	r_dec,
	start,
	done,
	c_mixcol
);
	input wire clk;
	input wire rst_n;
	input wire r_dec;
	input wire start;
	output reg done;
	output reg c_mixcol;
	localparam [3:0] ENC_CYCLES = 4'd4;
	localparam [3:0] DEC_CYCLES = 4'd12;
	reg [3:0] cycles_left;
	reg busy;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			cycles_left <= 4'd0;
			busy <= 1'b0;
			done <= 1'b0;
			c_mixcol <= 1'b0;
		end
		else if (start && !busy) begin
			cycles_left <= (r_dec ? DEC_CYCLES : ENC_CYCLES) - 4'd1;
			busy <= 1'b1;
			done <= 1'b0;
			c_mixcol <= 1'b1;
		end
		else if (busy && (cycles_left != 4'd0)) begin
			cycles_left <= cycles_left - 4'd1;
			busy <= 1'b1;
			done <= cycles_left == 4'd1;
			c_mixcol <= 1'b1;
		end
		else begin
			busy <= 1'b0;
			done <= 1'b0;
			c_mixcol <= 1'b0;
		end
endmodule