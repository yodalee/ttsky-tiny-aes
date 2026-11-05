module RcLUT (
	i_data,
	o_data
);
	reg _sv2v_0;
	input [7:0] i_data;
	output reg [7:0] o_data;
	always @(*) begin
		if (_sv2v_0)
			;
		case (i_data)
			8'h00: o_data = 8'h01;
			8'h01: o_data = 8'h02;
			8'h02: o_data = 8'h04;
			8'h03: o_data = 8'h08;
			8'h04: o_data = 8'h10;
			8'h05: o_data = 8'h20;
			8'h06: o_data = 8'h40;
			8'h07: o_data = 8'h80;
			8'h08: o_data = 8'h1b;
			default: o_data = 8'h36;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule