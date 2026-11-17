module ControlShiftrow (
	clk,
	rst_n,
	r_dec,
	start,
	done,
	c_srow
);
	input wire clk;
	input wire rst_n;
	input wire r_dec;
	input wire start;
	output reg done;
	output reg [2:0] c_srow;
	reg [1:0] step;
	reg busy;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			step <= 2'd0;
			busy <= 1'b0;
			done <= 1'b0;
			c_srow <= 3'b000;
		end
		else if (start && !busy) begin
			step <= 2'd1;
			busy <= 1'b1;
			done <= 1'b0;
			c_srow <= 3'b111;
		end
		else if (busy && (step == 2'd1)) begin
			step <= 2'd2;
			busy <= 1'b1;
			done <= 1'b0;
			c_srow <= (r_dec ? c_srow >> 1 : c_srow << 1);
		end
		else if (busy && (step == 2'd2)) begin
			step <= 2'd0;
			busy <= 1'b1;
			done <= 1'b1;
			c_srow <= (r_dec ? c_srow >> 1 : c_srow << 1);
		end
		else begin
			busy <= 1'b0;
			done <= 1'b0;
			c_srow <= 3'b000;
		end
endmodule