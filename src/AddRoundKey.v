module AddRoundKey (
	r_dec,
	c_add,
	c_sbox,
	c_keyexpansion,
	i_roundkey,
	i_state,
	i_sboxkey,
	o_key,
	o_state
);
	input r_dec;
	input c_add;
	input c_sbox;
	input c_keyexpansion;
	input wire signed [7:0] i_roundkey;
	input wire signed [7:0] i_state;
	input wire signed [7:0] i_sboxkey;
	output wire signed [7:0] o_key;
	output wire signed [7:0] o_state;
	wire signed [7:0] add_before;
	wire signed [7:0] add_after;
	assign add_before = (c_add && !r_dec ? i_roundkey : 8'b00000000);
	assign add_after = (c_add && r_dec ? i_roundkey : 8'b00000000);
	wire signed [7:0] sbox_in;
	wire signed [7:0] sbox_out;
	assign sbox_in = (c_keyexpansion ? i_sboxkey : i_state ^ add_before);
	SboxArish i_sbox(
		.c_inv(r_dec && c_sbox),
		.i_data(sbox_in),
		.o_data(sbox_out)
	);
	assign o_key = sbox_out;
	assign o_state = add_after ^ (c_sbox ? sbox_out : sbox_in);
endmodule