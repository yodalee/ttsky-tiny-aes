module ControlFsm (
	clk,
	rst_n,
	r_dec,
	r_level,
	i_valid,
	i_ready,
	o_ready,
	o_valid,
	d_state,
	c_stateen,
	c_srow,
	c_mixcol,
	c_loadkey,
	c_keyen,
	c_ke0,
	c_ke1,
	c_ke2,
	c_kxor,
	c_resetrc,
	c_ikxor,
	c_dec192_keysel,
	c_add,
	c_sbox
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire [1:0] r_dec;
	input wire [1:0] r_level;
	input wire i_valid;
	output wire i_ready;
	input wire o_ready;
	output wire o_valid;
	output wire [4:0] d_state;
	output wire c_stateen;
	output wire [2:0] c_srow;
	output wire c_mixcol;
	output wire c_loadkey;
	output wire c_keyen;
	output wire c_ke0;
	output wire c_ke1;
	output wire c_ke2;
	output wire c_kxor;
	output wire c_resetrc;
	output wire [4:0] c_ikxor;
	output wire [1:0] c_dec192_keysel;
	output wire c_add;
	output wire c_sbox;
	reg [4:0] state;
	reg [4:0] state_n;
	reg [5:0] cycle_q;
	reg [3:0] round_q;
	reg state_end;
	reg start_add;
	reg start_shiftrow;
	reg start_mixcolumn;
	reg start_keyexpand;
	reg [2:0] add_index;
	reg [2:0] add_last_index;
	reg add_i_add;
	reg add_i_sbox;
	reg [1:0] add_i_xor;
	reg [4:0] add_i_ikxor;
	reg keyexpand_is_ke2;
	wire add_stateen;
	wire add_keyen;
	wire [4:0] add_ikxor;
	function automatic [5:0] key_cycles;
		input reg [1:0] level;
		case (level)
			2'b00: key_cycles = 6'd16;
			2'b01: key_cycles = 6'd24;
			default: key_cycles = 6'd32;
		endcase
	endfunction
	function automatic processing;
		input reg [4:0] s;
		processing = ((s != 5'd0) && (s != 5'd1)) && (s != 5'd14);
	endfunction
	function automatic [4:0] sv2v_cast_5;
		input reg [4:0] inp;
		sv2v_cast_5 = inp;
	endfunction
	function automatic key_state;
		input reg [4:0] s;
		key_state = (((s == 5'd7) || (s == 5'd11)) || (s == 5'd15)) || (s == sv2v_cast_5((5'd16 + 1) + 13));
	endfunction
	function automatic [5:0] cycles;
		input reg [4:0] s;
		input reg [3:0] key_round;
		case (s)
			5'd2, 5'd5, 5'd9, 5'd13: cycles = 6'd16;
			5'd3, 5'd4, sv2v_cast_5((5'd16 + 1) + 1): cycles = 6'd20;
			5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10), 5'd6: cycles = 6'd23;
			sv2v_cast_5((5'd16 + 1) + 4), 5'd8: cycles = 6'd27;
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): cycles = 6'd31;
			sv2v_cast_5((5'd16 + 1) + 5), 5'd12: cycles = 6'd35;
			5'd10: cycles = 6'd52;
			5'd7, 5'd15, sv2v_cast_5((5'd16 + 1) + 13): cycles = 6'd20;
			5'd11: cycles = (key_round == 4'd7 ? 6'd20 : 6'd28);
			default: cycles = 6'd1;
		endcase
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		start_add = 1'b0;
		add_index = 3'd0;
		case (state)
			5'd2, 5'd4, sv2v_cast_5(5'd16 + 1), 5'd6, 5'd5, 5'd9, 5'd13, sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): begin
				start_add = (cycle_q == 6'd0) || (cycle_q == 6'd8);
				add_index = (cycle_q == 6'd8 ? 3'd1 : 3'd0);
			end
			5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): begin
				start_add = (cycle_q == 6'd7) || (cycle_q == 6'd15);
				add_index = (cycle_q == 6'd15 ? 3'd1 : 3'd0);
			end
			5'd3: begin
				start_add = (cycle_q == 6'd4) || (cycle_q == 6'd12);
				add_index = (cycle_q == 6'd12 ? 3'd1 : 3'd0);
			end
			5'd7, 5'd15, sv2v_cast_5((5'd16 + 1) + 13): begin
				start_add = (cycle_q == 6'd4) || (cycle_q == 6'd12);
				add_index = (cycle_q == 6'd12 ? 3'd1 : 3'd0);
			end
			5'd11: begin
				start_add = ((cycle_q == 6'd4) || (cycle_q == 6'd12)) || ((round_q != 4'd7) && (cycle_q == 6'd20));
				case (cycle_q)
					6'd12: add_index = 3'd1;
					6'd20: add_index = 3'd2;
					default: add_index = 3'd0;
				endcase
			end
			sv2v_cast_5((5'd16 + 1) + 1), sv2v_cast_5((5'd16 + 1) + 5): begin
				start_add = (cycle_q == 6'd0) || (cycle_q == 6'd12);
				add_index = (cycle_q == 6'd12 ? 3'd1 : 3'd0);
			end
			sv2v_cast_5((5'd16 + 1) + 4): begin
				start_add = (cycle_q == 6'd7) || (cycle_q == 6'd19);
				add_index = (cycle_q == 6'd19 ? 3'd1 : 3'd0);
			end
			5'd8: begin
				start_add = ((cycle_q == 6'd0) || (cycle_q == 6'd8)) || (cycle_q == 6'd16);
				add_index = {1'b0, cycle_q[4:3]};
			end
			5'd12: begin
				start_add = (((cycle_q == 6'd0) || (cycle_q == 6'd8)) || (cycle_q == 6'd16)) || (cycle_q == 6'd24);
				add_index = {1'b0, cycle_q[4:3]};
			end
			5'd10: begin
				start_add = (((((cycle_q == 6'd0) || (cycle_q == 6'd8)) || (cycle_q == 6'd16)) || (cycle_q == 6'd24)) || (cycle_q == 6'd36)) || (cycle_q == 6'd44);
				if (cycle_q <= 6'd24)
					add_index = {1'b0, cycle_q[4:3]};
				else
					add_index = (cycle_q == 6'd36 ? 3'd4 : 3'd5);
			end
			default:
				;
		endcase
		add_i_add = 1'b1;
		add_i_sbox = 1'b1;
		add_i_xor = 2'b00;
		add_i_ikxor = 5'b00000;
		add_last_index = 3'd1;
		if (key_state(state)) begin
			add_i_add = 1'b0;
			add_i_sbox = 1'b0;
			if ((state == 5'd11) && (round_q != 4'd7))
				add_last_index = 3'd2;
			add_i_xor = (add_index == add_last_index ? 2'b10 : 2'b11);
		end
		else
			case (state)
				5'd5, 5'd9, 5'd13: add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
				5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): add_i_xor = (add_index == 3'd0 ? 2'b11 : 2'b10);
				5'd3: begin
					add_i_sbox = 1'b0;
					add_i_xor = 2'b11;
				end
				5'd4: begin
					add_i_sbox = 1'b0;
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b10011;
				end
				sv2v_cast_5(5'd16 + 1): begin
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b10011;
				end
				sv2v_cast_5((5'd16 + 1) + 1): add_i_xor = (add_index == 3'd1 ? 2'b11 : 2'b00);
				sv2v_cast_5((5'd16 + 1) + 3): add_i_xor = 2'b11;
				sv2v_cast_5((5'd16 + 1) + 4): add_i_xor = (add_index == 3'd0 ? 2'b10 : 2'b11);
				5'd8: begin
					add_i_add = add_index != 3'd0;
					add_i_sbox = 1'b0;
					add_i_xor = (add_index == 3'd2 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b00111;
				end
				sv2v_cast_5((5'd16 + 1) + 5): begin
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b11100;
				end
				sv2v_cast_5((5'd16 + 1) + 6): begin
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b11000;
				end
				sv2v_cast_5((5'd16 + 1) + 7): begin
					add_i_xor = (add_index == 3'd0 ? 2'b10 : (add_index == 3'd1 ? 2'b01 : 2'b00));
					add_i_ikxor = (add_index == 3'd0 ? 5'b00110 : 5'b00111);
				end
				5'd12: begin
					add_i_add = add_index >= 3'd2;
					add_i_sbox = 1'b0;
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
				end
				sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): begin
					add_i_xor = (add_index == 3'd1 ? 2'b01 : 2'b00);
					add_i_ikxor = 5'b11100;
				end
				5'd10: begin
					if (add_index >= 3'd2) begin
						add_i_add = 1'b0;
						add_i_sbox = 1'b0;
					end
					add_i_xor = (add_index == 3'd4 ? 2'b11 : (add_index == 3'd5 ? 2'b10 : 2'b00));
				end
				default:
					;
			endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		start_shiftrow = 1'b0;
		case (state)
			5'd16, 5'd3, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 4), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): start_shiftrow = cycle_q == 6'd0;
			5'd4, 5'd6: start_shiftrow = cycle_q == 6'd16;
			5'd8: start_shiftrow = cycle_q == 6'd24;
			5'd12: start_shiftrow = cycle_q == 6'd32;
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_shiftrow = cycle_q == 6'd28;
			sv2v_cast_5((5'd16 + 1) + 5): start_shiftrow = cycle_q == 6'd32;
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		start_mixcolumn = 1'b0;
		case (state)
			5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 4), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): start_mixcolumn = cycle_q == 6'd3;
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_mixcolumn = cycle_q == 6'd16;
			sv2v_cast_5((5'd16 + 1) + 5): start_mixcolumn = cycle_q == 6'd20;
			5'd6: start_mixcolumn = cycle_q == 6'd19;
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		start_keyexpand = 1'b0;
		case (state)
			5'd16, 5'd3, sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10), 5'd7, 5'd11, 5'd15, sv2v_cast_5((5'd16 + 1) + 13): start_keyexpand = cycle_q == 6'd0;
			5'd4, sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_keyexpand = cycle_q == 6'd16;
			sv2v_cast_5((5'd16 + 1) + 1), sv2v_cast_5((5'd16 + 1) + 5): start_keyexpand = cycle_q == 6'd8;
			sv2v_cast_5((5'd16 + 1) + 4): start_keyexpand = cycle_q == 6'd15;
			5'd10: start_keyexpand = cycle_q == 6'd32;
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		keyexpand_is_ke2 = ((state == sv2v_cast_5((5'd16 + 1) + 9)) || (state == sv2v_cast_5((5'd16 + 1) + 12))) || (state == sv2v_cast_5((5'd16 + 1) + 13));
	end
	ControlAdd i_control_add(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_add),
		.r_dec(r_dec[1] && !key_state(state)),
		.i_add(add_i_add),
		.i_sbox(add_i_sbox),
		.i_xor(add_i_xor),
		.i_ikxor(add_i_ikxor),
		.c_keyen(add_keyen),
		.c_add(c_add),
		.c_stateen(add_stateen),
		.c_sbox(c_sbox),
		.c_kxor(c_kxor),
		.c_ikxor(add_ikxor)
	);
	ControlShiftrow i_control_shiftrow(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec[1]),
		.start(start_shiftrow),
		.c_srow(c_srow)
	);
	ControlMixColumn i_control_mixcolumn(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec[1]),
		.start(start_mixcolumn),
		.c_mixcol(c_mixcol)
	);
	ControlKeyExpand i_control_keyexpand(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_keyexpand),
		.is_ke2(keyexpand_is_ke2),
		.c_ke0(c_ke0),
		.c_ke1(c_ke1),
		.c_ke2(c_ke2)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		state_end = 1'b0;
		case (state)
			5'd0: state_end = i_valid && (cycle_q == 6'd15);
			5'd1: state_end = i_valid && (cycle_q == (key_cycles(r_level) - 6'd1));
			5'd14: state_end = o_ready && (cycle_q == 6'd15);
			default:
				if (processing(state))
					state_end = cycle_q == (cycles(state, round_q) - 6'd1);
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		state_n = state;
		case (state)
			5'd0:
				if (state_end)
					state_n = 5'd1;
			5'd1:
				if (state_end) begin
					if (!r_dec[1])
						case (r_level)
							2'b00: state_n = 5'd2;
							2'b01: state_n = 5'd6;
							default: state_n = 5'd10;
						endcase
					else if (r_dec[0])
						case (r_level)
							2'b00: state_n = 5'd7;
							2'b01: state_n = 5'd11;
							default: state_n = 5'd15;
						endcase
					else
						case (r_level)
							2'b00: state_n = 5'd4;
							2'b01: state_n = 5'd8;
							default: state_n = 5'd12;
						endcase
				end
			5'd2: state_n = 5'd16;
			5'd16:
				if (round_q == 4'd8)
					state_n = 5'd3;
			5'd3: state_n = 5'd14;
			5'd7:
				if (round_q == 4'd9)
					state_n = 5'd4;
			5'd4: state_n = sv2v_cast_5(5'd16 + 1);
			sv2v_cast_5(5'd16 + 1):
				if (round_q == 4'd8)
					state_n = 5'd5;
			5'd5: state_n = 5'd14;
			5'd6: state_n = sv2v_cast_5((5'd16 + 1) + 1);
			sv2v_cast_5((5'd16 + 1) + 1): state_n = sv2v_cast_5((5'd16 + 1) + 2);
			sv2v_cast_5((5'd16 + 1) + 2): state_n = (round_q == 4'd10 ? 5'd3 : sv2v_cast_5((5'd16 + 1) + 3));
			sv2v_cast_5((5'd16 + 1) + 3): state_n = sv2v_cast_5((5'd16 + 1) + 4);
			sv2v_cast_5((5'd16 + 1) + 4): state_n = sv2v_cast_5((5'd16 + 1) + 2);
			5'd11:
				if (round_q == 4'd7)
					state_n = 5'd8;
			5'd8: state_n = sv2v_cast_5((5'd16 + 1) + 5);
			sv2v_cast_5((5'd16 + 1) + 5): state_n = sv2v_cast_5((5'd16 + 1) + 6);
			sv2v_cast_5((5'd16 + 1) + 6): state_n = (round_q == 4'd10 ? 5'd9 : sv2v_cast_5((5'd16 + 1) + 7));
			sv2v_cast_5((5'd16 + 1) + 7): state_n = sv2v_cast_5((5'd16 + 1) + 5);
			5'd9: state_n = 5'd14;
			5'd10: state_n = sv2v_cast_5((5'd16 + 1) + 8);
			sv2v_cast_5((5'd16 + 1) + 8):
				if (round_q == 4'd1)
					state_n = sv2v_cast_5((5'd16 + 1) + 9);
			sv2v_cast_5((5'd16 + 1) + 9): state_n = (round_q == 4'd12 ? 5'd3 : sv2v_cast_5((5'd16 + 1) + 10));
			sv2v_cast_5((5'd16 + 1) + 10): state_n = sv2v_cast_5((5'd16 + 1) + 9);
			5'd15: state_n = (round_q == 4'd12 ? 5'd12 : sv2v_cast_5((5'd16 + 1) + 13));
			sv2v_cast_5((5'd16 + 1) + 13): state_n = 5'd15;
			5'd12: state_n = sv2v_cast_5((5'd16 + 1) + 11);
			sv2v_cast_5((5'd16 + 1) + 11): state_n = (round_q == 4'd12 ? 5'd13 : sv2v_cast_5((5'd16 + 1) + 12));
			sv2v_cast_5((5'd16 + 1) + 12): state_n = sv2v_cast_5((5'd16 + 1) + 11);
			5'd13: state_n = 5'd14;
			5'd14:
				if (state_end)
					state_n = 5'd0;
			default: state_n = 5'd0;
		endcase
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			state <= 5'd0;
			cycle_q <= 6'd0;
			round_q <= 4'd0;
		end
		else if (((state == 5'd0) || (state == 5'd1)) && !i_valid)
			;
		else if ((state == 5'd14) && !o_ready)
			;
		else if (state_end) begin
			state <= state_n;
			cycle_q <= 6'd0;
			if (key_state(state)) begin
				if (!key_state(state_n))
					round_q <= 4'd0;
				else
					round_q <= round_q + 4'd1;
			end
			else if (state[4])
				round_q <= round_q + 4'd1;
			else if (state == 5'd1)
				round_q <= 4'd0;
		end
		else
			cycle_q <= cycle_q + 6'd1;
	assign c_stateen = (state == 5'd0 ? i_valid : (state == 5'd14 ? o_ready : add_stateen));
	assign c_loadkey = (state == 5'd1) && i_valid;
	assign c_keyen = (state == 5'd1 ? i_valid : add_keyen);
	assign c_ikxor = add_ikxor;
	assign c_resetrc = (state_end && key_state(state)) && !key_state(state_n);
	assign c_dec192_keysel = ((state == sv2v_cast_5((5'd16 + 1) + 5)) && add_keyen ? 2'b01 : ((state == sv2v_cast_5((5'd16 + 1) + 6)) && add_keyen ? 2'b10 : 2'b00));
	assign i_ready = (state == 5'd0) || (state == 5'd1);
	assign o_valid = state == 5'd14;
	assign d_state = state;
	initial _sv2v_0 = 0;
endmodule