module AesTop (
	clk,
	rst_n,
	r_dec,
	r_level,
	i_valid,
	i_ready,
	i_data,
	o_valid,
	o_ready,
	o_data
);
	input clk;
	input rst_n;
	input r_dec;
	input [1:0] r_level;
	input i_valid;
	output wire i_ready;
	input wire signed [7:0] i_data;
	output wire o_valid;
	input o_ready;
	output wire signed [7:0] o_data;
	wire c_stateen;
	wire c_srow0;
	wire c_srow1;
	wire c_srow2;
	wire c_isrow0;
	wire c_isrow1;
	wire c_mixcol;
	wire c_loadkey;
	wire c_keyen;
	wire c_ke0;
	wire c_ke1;
	wire c_ke2;
	wire c_kxor;
	wire [4:0] c_ikxor;
	wire [1:0] c_dec192_keysel;
	wire c_add;
	wire c_sbox;
	wire c_keyexpansion;
	wire signed [7:0] core_data;
	assign c_keyexpansion = (c_ke0 | c_ke1) | c_ke2;
	ControlFsm i_control_fsm(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec),
		.r_level(r_level),
		.i_valid(i_valid),
		.i_ready(i_ready),
		.o_ready(o_ready),
		.o_valid(o_valid),
		.c_srow0(c_srow0),
		.c_srow1(c_srow1),
		.c_srow2(c_srow2),
		.c_isrow0(c_isrow0),
		.c_isrow1(c_isrow1),
		.c_mixcol(c_mixcol),
		.c_stateen(c_stateen),
		.c_loadkey(c_loadkey),
		.c_keyen(c_keyen),
		.c_ke0(c_ke0),
		.c_ke1(c_ke1),
		.c_ke2(c_ke2),
		.c_kxor(c_kxor),
		.c_ikxor(c_ikxor),
		.c_dec192_keysel(c_dec192_keysel),
		.c_add(c_add),
		.c_sbox(c_sbox)
	);
	AesCore i_aes_core(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec),
		.r_level(r_level),
		.c_stateen(c_stateen),
		.c_srow0(c_srow0),
		.c_srow1(c_srow1),
		.c_srow2(c_srow2),
		.c_isrow0(c_isrow0),
		.c_isrow1(c_isrow1),
		.c_mixcol(c_mixcol),
		.c_loadkey(c_loadkey),
		.c_keyen(c_keyen),
		.c_ke0(c_ke0),
		.c_ke1(c_ke1),
		.c_ke2(c_ke2),
		.c_kxor(c_kxor),
		.c_ikxor(c_ikxor),
		.c_dec192_keysel(c_dec192_keysel),
		.c_add(c_add),
		.c_sbox(c_sbox),
		.c_keyexpansion(c_keyexpansion),
		.i_data(i_data),
		.o_data(o_data)
	);
endmodule