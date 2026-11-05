module EnableFF (
	clk,
	rst_n,
	en,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			q <= 1'sb0;
		else if (en)
			q <= d;
endmodule