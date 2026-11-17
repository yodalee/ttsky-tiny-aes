module ControlKeyExpand (
	clk,
	rst_n,
	start,
	is_ke2,
	done,
	c_ke0,
	c_ke1,
	c_ke2
);
	input wire clk;
	input wire rst_n;
	input wire start;
	input wire is_ke2;
	output reg done;
	output reg c_ke0;
	output reg c_ke1;
	output reg c_ke2;
	reg is_ke2_q;
	reg [1:0] step;
	reg busy;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			is_ke2_q <= 1'b0;
			step <= 2'd0;
			busy <= 1'b0;
			done <= 1'b0;
			c_ke0 <= 1'b0;
			c_ke1 <= 1'b0;
			c_ke2 <= 1'b0;
		end
		else if (start && !busy) begin
			is_ke2_q <= is_ke2;
			step <= 2'd1;
			busy <= 1'b1;
			done <= 1'b0;
			c_ke0 <= !is_ke2;
			c_ke1 <= 1'b0;
			c_ke2 <= is_ke2;
		end
		else if (busy && (step != 2'd0)) begin
			step <= (step == 2'd3 ? 2'd0 : step + 2'd1);
			busy <= 1'b1;
			done <= step == 2'd3;
			c_ke0 <= 1'b0;
			c_ke1 <= !is_ke2_q;
			c_ke2 <= is_ke2_q;
		end
		else begin
			busy <= 1'b0;
			done <= 1'b0;
			c_ke0 <= 1'b0;
			c_ke1 <= 1'b0;
			c_ke2 <= 1'b0;
		end
endmodule