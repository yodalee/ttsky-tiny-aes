module KeyExpansion (
	clk,
	rst_n,
	r_dec,
	r_level,
	c_en,
	c_loadkey,
	c_ke0,
	c_ke1,
	c_ke2,
	c_kxor,
	c_ikxor,
	c_dec192_keysel,
	i_key,
	i_subkey,
	o_key00,
	o_key20,
	o_key60,
	o_key70,
	o_key71
);
	input clk;
	input rst_n;
	input r_dec;
	input [1:0] r_level;
	input c_en;
	input c_loadkey;
	input c_ke0;
	input c_ke1;
	input c_ke2;
	input c_kxor;
	input [4:0] c_ikxor;
	input [1:0] c_dec192_keysel;
	input wire signed [7:0] i_key;
	input wire signed [7:0] i_subkey;
	output wire signed [7:0] o_key00;
	output wire signed [7:0] o_key20;
	output wire signed [7:0] o_key60;
	output wire signed [7:0] o_key70;
	output wire signed [7:0] o_key71;
	wire en;
	assign en = (c_en | c_kxor) | (|c_ikxor);
	reg [7:0] c_rc_idx;
	wire signed [7:0] rc_data;
	wire is128;
	wire is192;
	localparam kLevel128 = 2'b00;
	assign is128 = r_level == kLevel128;
	localparam kLevel192 = 2'b01;
	assign is192 = r_level == kLevel192;
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			c_rc_idx <= 1'sb0;
		else if (c_loadkey) begin
			if (r_dec)
				case (r_level)
					kLevel128: c_rc_idx <= 8'd9;
					kLevel192: c_rc_idx <= 8'd7;
					default: c_rc_idx <= 8'd6;
				endcase
			else
				c_rc_idx <= 1'sb0;
		end
		else if (c_ke0) begin
			if (r_dec)
				c_rc_idx <= c_rc_idx - 8'd1;
			else
				c_rc_idx <= c_rc_idx + 8'd1;
		end
	RcLUT i_rc_lut(
		.i_data(c_rc_idx),
		.o_data(rc_data)
	);
	wire mux_RC;
	assign mux_RC = c_ke0;
	wire mux_Sbox;
	assign mux_Sbox = (c_ke0 | c_ke1) | c_ke2;
	wire [1:0] mux_input;
	assign mux_input[0] = (c_ke0 | c_ke1) | c_ke2;
	assign mux_input[1] = c_dec192_keysel[0] || c_dec192_keysel[1];
	wire sel03;
	assign sel03 = ((c_kxor | c_ke0) | c_ke1) | c_ke2;
	wire signed [7:0] key00;
	wire signed [7:0] key01;
	wire signed [7:0] key02;
	wire signed [7:0] key03;
	wire signed [7:0] key10;
	wire signed [7:0] key11;
	wire signed [7:0] key12;
	wire signed [7:0] key13;
	wire signed [7:0] key20;
	wire signed [7:0] key21;
	wire signed [7:0] key22;
	wire signed [7:0] key23;
	wire signed [7:0] key30;
	wire signed [7:0] key31;
	wire signed [7:0] key32;
	wire signed [7:0] key33;
	wire signed [7:0] key40;
	wire signed [7:0] key41;
	wire signed [7:0] key42;
	wire signed [7:0] key43;
	wire signed [7:0] key50;
	wire signed [7:0] key51;
	wire signed [7:0] key52;
	wire signed [7:0] key53;
	wire signed [7:0] key60;
	wire signed [7:0] key61;
	wire signed [7:0] key62;
	wire signed [7:0] key63;
	wire signed [7:0] key70;
	wire signed [7:0] key71;
	wire signed [7:0] key72;
	wire signed [7:0] key73;
	wire signed [7:0] key04;
	wire signed [7:0] key14;
	wire signed [7:0] key24;
	wire signed [7:0] key34;
	wire signed [7:0] key64;
	wire signed [7:0] key74;
	wire en_col0;
	assign en_col0 = ((en | c_ke0) | c_ke1) | c_ke2;
	EnableFF i_key00(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col0),
		.d(key01),
		.q(key00)
	);
	EnableFF i_key01(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col0),
		.d(key02),
		.q(key01)
	);
	EnableFF i_key02(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col0),
		.d(key03),
		.q(key02)
	);
	MuxEnableFF i_key03(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col0),
		.sel(sel03),
		.d0(key10),
		.d1(key04),
		.q(key03)
	);
	EnableFF i_key10(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key11),
		.q(key10)
	);
	EnableFF i_key11(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key12),
		.q(key11)
	);
	EnableFF i_key12(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key13),
		.q(key12)
	);
	EnableFF i_key13(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key14),
		.q(key13)
	);
	EnableFF i_key20(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key21),
		.q(key20)
	);
	EnableFF i_key21(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key22),
		.q(key21)
	);
	EnableFF i_key22(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key23),
		.q(key22)
	);
	EnableFF i_key23(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key24),
		.q(key23)
	);
	EnableFF i_key30(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key31),
		.q(key30)
	);
	EnableFF i_key31(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key32),
		.q(key31)
	);
	EnableFF i_key32(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key33),
		.q(key32)
	);
	EnableFF i_key33(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key34),
		.q(key33)
	);
	EnableFF i_key40(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key41),
		.q(key40)
	);
	EnableFF i_key41(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key42),
		.q(key41)
	);
	EnableFF i_key42(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key43),
		.q(key42)
	);
	EnableFF i_key43(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key50),
		.q(key43)
	);
	EnableFF i_key50(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key51),
		.q(key50)
	);
	EnableFF i_key51(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key52),
		.q(key51)
	);
	EnableFF i_key52(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key53),
		.q(key52)
	);
	EnableFF i_key53(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key60),
		.q(key53)
	);
	EnableFF i_key60(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key61),
		.q(key60)
	);
	EnableFF i_key61(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key62),
		.q(key61)
	);
	EnableFF i_key62(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key63),
		.q(key62)
	);
	EnableFF i_key63(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.d(key64),
		.q(key63)
	);
	wire en_col7;
	assign en_col7 = ((en | c_ke0) | c_ke1) | c_ke2;
	EnableFF i_key70(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col7),
		.d(key71),
		.q(key70)
	);
	EnableFF i_key71(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col7),
		.d(key72),
		.q(key71)
	);
	EnableFF i_key72(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col7),
		.d(key73),
		.q(key72)
	);
	EnableFF i_key73(
		.clk(clk),
		.rst_n(rst_n),
		.en(en_col7),
		.d(key74),
		.q(key73)
	);
	wire signed [7:0] rc;
	assign rc = (mux_RC ? rc_data : 8'b00000000);
	wire signed [7:0] subkey;
	assign subkey = i_subkey ^ rc;
	assign key04 = key00 ^ (mux_Sbox ? subkey : key10);
	assign key14 = (c_ikxor[4] ? key10 : 8'd0) ^ (is128 ? key60 : key20);
	assign key24 = (c_ikxor[3] ? key20 : 8'd0) ^ key30;
	assign key34 = (c_ikxor[2] ? key30 : 8'd0) ^ (is192 ? key60 : key40);
	assign key64 = (c_ikxor[1] ? key60 : 8'd0) ^ key70;
	wire signed [7:0] key74_a;
	wire signed [7:0] key74_b;
	assign key74_a = (c_ikxor[0] ? key70 : 8'd0);
	assign key74_b = (mux_input[1] ? key00 : (mux_input[0] ? key70 : i_key));
	assign key74 = key74_a ^ key74_b;
	assign o_key00 = key00;
	assign o_key20 = key20;
	assign o_key60 = key60;
	assign o_key70 = key70;
	assign o_key71 = key71;
endmodule