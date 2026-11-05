module MuxEnableFF (
	clk,
	rst_n,
	en,
	sel,
	d0,
	d1,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire sel;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	output wire [WIDTH - 1:0] q;
	wire [WIDTH - 1:0] d;
	assign d = (sel ? d1 : d0);
	EnableFF ff(
		clk,
		rst_n,
		en,
		d,
		q
	);
endmodule