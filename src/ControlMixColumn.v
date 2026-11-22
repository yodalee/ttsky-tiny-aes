module ControlMixColumn (
	clk,
	rst_n,
	r_dec,
	start,
	c_mixcol
);
	input wire clk;
	input wire rst_n;
	input wire r_dec;
	input wire start;
	output wire c_mixcol;
	localparam [3:0] ENC_CYCLES = 4'd4;
	localparam [3:0] DEC_CYCLES = 4'd12;
	reg [3:0] cycles_left;
	reg busy;
	wire direct_start;
	assign direct_start = (rst_n && start) && !busy;
	assign c_mixcol = busy | direct_start;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			cycles_left <= 4'd0;
			busy <= 1'b0;
		end
		else if (direct_start) begin
			cycles_left <= (r_dec ? DEC_CYCLES : ENC_CYCLES) - 4'd1;
			busy <= 1'b1;
		end
		else if (busy && (cycles_left > 4'd1))
			cycles_left <= cycles_left - 4'd1;
		else if (busy) begin
			cycles_left <= 4'd0;
			busy <= 1'b0;
		end
		else
			cycles_left <= 4'd0;
endmodule