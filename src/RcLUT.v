module RcLUT (
	i_data,
	o_data
);
	reg _sv2v_0;
	input [4:0] i_data;
	output reg [7:0] o_data;
	always @(*) begin
		if (_sv2v_0)
			;
		case (i_data)
			5'h00: o_data = 8'h01;
			5'h01: o_data = 8'h02;
			5'h02: o_data = 8'h04;
			5'h03: o_data = 8'h08;
			5'h04: o_data = 8'h10;
			5'h05: o_data = 8'h20;
			5'h06: o_data = 8'h40;
			5'h07: o_data = 8'h80;
			5'h08: o_data = 8'h1b;
			5'h17: o_data = 8'h1b;
			5'h18: o_data = 8'h80;
			5'h19: o_data = 8'h40;
			5'h1a: o_data = 8'h20;
			5'h1b: o_data = 8'h10;
			5'h1c: o_data = 8'h08;
			5'h1d: o_data = 8'h04;
			5'h1e: o_data = 8'h02;
			5'h1f: o_data = 8'h01;
			default: o_data = 8'h36;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule