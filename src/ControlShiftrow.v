module ControlShiftrow (
	clk,
	rst_n,
	r_dec,
	start,
	c_srow
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire r_dec;
	input wire start;
	output reg [2:0] c_srow;
	reg [1:0] step;
	reg busy;
	wire direct_start;
	assign direct_start = (rst_n && start) && !busy;
	always @(*) begin
		if (_sv2v_0)
			;
		if (direct_start)
			c_srow = 3'b111;
		else if (busy)
			case (step)
				2'd1: c_srow = (r_dec ? 3'b011 : 3'b110);
				2'd2: c_srow = (r_dec ? 3'b001 : 3'b100);
				default: c_srow = 3'b000;
			endcase
		else
			c_srow = 3'b000;
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			step <= 2'd0;
			busy <= 1'b0;
		end
		else if (direct_start) begin
			step <= 2'd1;
			busy <= 1'b1;
		end
		else if (busy && (step == 2'd2)) begin
			step <= 2'd0;
			busy <= 1'b0;
		end
		else if (busy && (step == 2'd1))
			step <= 2'd2;
	initial _sv2v_0 = 0;
endmodule