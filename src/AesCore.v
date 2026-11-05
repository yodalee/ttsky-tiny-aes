module AesCore (
	clk,
	rst_n,
	r_dec,
	r_level,
	c_stateen,
	c_srow0,
	c_srow1,
	c_srow2,
	c_isrow0,
	c_isrow1,
	c_mixcol,
	c_loadkey,
	c_keyen,
	c_ke0,
	c_ke1,
	c_ke2,
	c_kxor,
	c_ikxor,
	c_dec192_keysel,
	c_add,
	c_sbox,
	c_keyexpansion,
	i_data,
	o_data
);
	reg _sv2v_0;
	input clk;
	input rst_n;
	input r_dec;
	input [1:0] r_level;
	input c_stateen;
	input c_srow0;
	input c_srow1;
	input c_srow2;
	input c_isrow0;
	input c_isrow1;
	input c_mixcol;
	input c_loadkey;
	input c_keyen;
	input c_ke0;
	input c_ke1;
	input c_ke2;
	input c_kxor;
	input [4:0] c_ikxor;
	input [1:0] c_dec192_keysel;
	input c_add;
	input c_sbox;
	input c_keyexpansion;
	input wire signed [7:0] i_data;
	output wire signed [7:0] o_data;
	wire signed [7:0] state_data;
	wire signed [7:0] key00;
	wire signed [7:0] key20;
	wire signed [7:0] key60;
	wire signed [7:0] key70;
	wire signed [7:0] key71;
	wire signed [7:0] subkey_data;
	wire signed [7:0] added_data;
	wire signed [7:0] i_state;
	assign i_state = (c_add ? added_data : i_data);
	AesState i_aes_state(
		.clk(clk),
		.rst_n(rst_n),
		.c_en(c_stateen),
		.c_srow0(c_srow0),
		.c_srow1(c_srow1),
		.c_srow2(c_srow2),
		.c_isrow0(c_isrow0),
		.c_isrow1(c_isrow1),
		.c_mixcol(c_mixcol),
		.i_state(i_state),
		.o_state(state_data)
	);
	reg signed [7:0] i_roundkey;
	always @(*) begin : mux_roundkey
		if (_sv2v_0)
			;
		i_roundkey = key00;
		if (c_loadkey)
			i_roundkey = i_data;
		else if (c_dec192_keysel[1])
			i_roundkey = key20;
		else if (c_dec192_keysel[0])
			i_roundkey = key60;
	end
	KeyExpansion i_key_expansion(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec),
		.r_level(r_level),
		.c_en(c_keyen),
		.c_loadkey(c_loadkey),
		.c_ke0(c_ke0),
		.c_ke1(c_ke1),
		.c_ke2(c_ke2),
		.c_kxor(c_kxor),
		.c_ikxor(c_ikxor),
		.c_dec192_keysel(c_dec192_keysel),
		.i_key(i_roundkey),
		.i_subkey(subkey_data),
		.o_key00(key00),
		.o_key20(key20),
		.o_key60(key60),
		.o_key70(key70),
		.o_key71(key71)
	);
	wire signed [7:0] i_sboxkey;
	assign i_sboxkey = (c_ke2 ? key70 : key71);
	AddRoundKey i_add_round_key(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec),
		.c_add(c_add),
		.c_sbox(c_sbox),
		.c_keyexpansion(c_keyexpansion),
		.i_roundkey(i_roundkey),
		.i_state(state_data),
		.i_sboxkey(i_sboxkey),
		.o_key(subkey_data),
		.o_state(added_data)
	);
	assign o_data = state_data;
	initial _sv2v_0 = 0;
endmodule