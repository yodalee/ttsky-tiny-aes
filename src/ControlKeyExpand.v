module ControlKeyExpand (
	clk,
	rst_n,
	start,
	is_ke2,
	c_ke0,
	c_ke1,
	c_ke2
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire start;
	input wire is_ke2;
	output reg c_ke0;
	output reg c_ke1;
	output reg c_ke2;
	reg is_ke2_q;
	reg [1:0] step;
	reg busy;
	wire direct_start;
	assign direct_start = (rst_n && start) && !busy;
	always @(*) begin
		if (_sv2v_0)
			;
		if (direct_start) begin
			c_ke0 = !is_ke2;
			c_ke1 = 1'b0;
			c_ke2 = is_ke2;
		end
		else if (busy) begin
			c_ke0 = 1'b0;
			c_ke1 = !is_ke2_q;
			c_ke2 = is_ke2_q;
		end
		else begin
			c_ke0 = 1'b0;
			c_ke1 = 1'b0;
			c_ke2 = 1'b0;
		end
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			is_ke2_q <= 1'b0;
			step <= 2'd0;
			busy <= 1'b0;
		end
		else if (direct_start) begin
			is_ke2_q <= is_ke2;
			step <= 2'd1;
			busy <= 1'b1;
		end
		else if (busy && (step == 2'd3)) begin
			step <= 2'd0;
			busy <= 1'b0;
		end
		else if (busy)
			step <= step + 2'd1;
	initial _sv2v_0 = 0;
endmodule