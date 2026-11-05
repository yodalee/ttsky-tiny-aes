module AesState (
	clk,
	rst_n,
	c_en,
	c_srow0,
	c_srow1,
	c_srow2,
	c_isrow0,
	c_isrow1,
	c_mixcol,
	i_state,
	o_state
);
	input clk;
	input rst_n;
	input c_en;
	input c_srow0;
	input c_srow1;
	input c_srow2;
	input c_isrow0;
	input c_isrow1;
	input c_mixcol;
	input wire signed [7:0] i_state;
	output wire signed [7:0] o_state;
	wire signed [7:0] state00;
	wire signed [7:0] state01;
	wire signed [7:0] state02;
	wire signed [7:0] state03;
	wire signed [7:0] state10;
	wire signed [7:0] state11;
	wire signed [7:0] state12;
	wire signed [7:0] state13;
	wire signed [7:0] state20;
	wire signed [7:0] state21;
	wire signed [7:0] state22;
	wire signed [7:0] state23;
	wire signed [7:0] state30;
	wire signed [7:0] state31;
	wire signed [7:0] state32;
	wire signed [7:0] state33;
	wire signed [7:0] state40;
	wire signed [7:0] state41;
	wire signed [7:0] state42;
	wire signed [7:0] state43;
	wire enrow0;
	wire enrow1;
	wire enrow2;
	wire enrow3;
	assign enrow0 = c_en | c_mixcol;
	assign enrow1 = (((c_en | c_mixcol) | c_srow0) | c_isrow0) | c_isrow1;
	assign enrow2 = (((c_en | c_mixcol) | c_srow0) | c_srow1) | c_isrow1;
	assign enrow3 = (((c_en | c_mixcol) | c_srow0) | c_srow1) | c_srow2;
	wire sel_row;
	assign sel_row = ((((c_srow0 | c_srow1) | c_srow2) | c_isrow0) | c_isrow1) | c_mixcol;
	MuxEnableFF i_state00(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow0),
		.sel(sel_row),
		.d0(state01),
		.d1(state10),
		.q(state00)
	);
	MuxEnableFF i_state01(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow1),
		.sel(sel_row),
		.d0(state02),
		.d1(state11),
		.q(state01)
	);
	MuxEnableFF i_state02(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow2),
		.sel(sel_row),
		.d0(state03),
		.d1(state12),
		.q(state02)
	);
	MuxEnableFF i_state03(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow3),
		.sel(sel_row),
		.d0(state10),
		.d1(state13),
		.q(state03)
	);
	MuxEnableFF i_state10(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow0),
		.sel(sel_row),
		.d0(state11),
		.d1(state20),
		.q(state10)
	);
	MuxEnableFF i_state11(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow1),
		.sel(sel_row),
		.d0(state12),
		.d1(state21),
		.q(state11)
	);
	MuxEnableFF i_state12(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow2),
		.sel(sel_row),
		.d0(state13),
		.d1(state22),
		.q(state12)
	);
	MuxEnableFF i_state13(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow3),
		.sel(sel_row),
		.d0(state20),
		.d1(state23),
		.q(state13)
	);
	MuxEnableFF i_state20(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow0),
		.sel(sel_row),
		.d0(state21),
		.d1(state30),
		.q(state20)
	);
	MuxEnableFF i_state21(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow1),
		.sel(sel_row),
		.d0(state22),
		.d1(state31),
		.q(state21)
	);
	MuxEnableFF i_state22(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow2),
		.sel(sel_row),
		.d0(state23),
		.d1(state32),
		.q(state22)
	);
	MuxEnableFF i_state23(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow3),
		.sel(sel_row),
		.d0(state30),
		.d1(state33),
		.q(state23)
	);
	MuxEnableFF i_state30(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow0),
		.sel(sel_row),
		.d0(state31),
		.d1(state40),
		.q(state30)
	);
	MuxEnableFF i_state31(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow1),
		.sel(sel_row),
		.d0(state32),
		.d1(state41),
		.q(state31)
	);
	MuxEnableFF i_state32(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow2),
		.sel(sel_row),
		.d0(state33),
		.d1(state42),
		.q(state32)
	);
	MuxEnableFF i_state33(
		.clk(clk),
		.rst_n(rst_n),
		.en(enrow3),
		.sel(sel_row),
		.d0(i_state),
		.d1(state43),
		.q(state33)
	);
	wire signed [31:0] i_mixcol;
	wire signed [31:0] o_mixcol;
	MixColumn i_mixcolumn(
		.i_data(i_mixcol),
		.o_data(o_mixcol)
	);
	assign i_mixcol = {state03, state02, state01, state00};
	assign state40 = (c_mixcol ? o_mixcol[0+:8] : state00);
	assign state41 = (c_mixcol ? o_mixcol[8+:8] : state01);
	assign state42 = (c_mixcol ? o_mixcol[16+:8] : state02);
	assign state43 = (c_mixcol ? o_mixcol[24+:8] : state03);
	assign o_state = state00;
endmodule