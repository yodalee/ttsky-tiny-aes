module RcLUT (
	i_data,
	o_data
);
	reg _sv2v_0;
	input [3:0] i_data;
	output reg [7:0] o_data;
	always @(*) begin
		if (_sv2v_0)
			;
		case (i_data)
			4'h0: o_data = 8'h01;
			4'h1: o_data = 8'h02;
			4'h2: o_data = 8'h04;
			4'h3: o_data = 8'h08;
			4'h4: o_data = 8'h10;
			4'h5: o_data = 8'h20;
			4'h6: o_data = 8'h40;
			4'h7: o_data = 8'h80;
			4'h8: o_data = 8'h1b;
			default: o_data = 8'h36;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule