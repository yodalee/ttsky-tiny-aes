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
	c_ikxor,
	c_dec192_keysel,
	c_add,
	c_sbox
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire r_dec;
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
	output wire [4:0] c_ikxor;
	output wire [1:0] c_dec192_keysel;
	output wire c_add;
	output wire c_sbox;
	reg [4:0] state;
	reg [4:0] state_n;
	reg [5:0] count;
	reg [3:0] round;
	reg [3:0] phase;
	reg state_start;
	reg start_add;
	wire done_add;
	reg start_shiftrow;
	wire done_shiftrow;
	reg start_mixcolumn;
	wire done_mixcolumn;
	reg start_keyexpand;
	wire done_keyexpand;
	reg state_done;
	reg add_i_add;
	reg add_i_sbox;
	reg [1:0] add_i_xor;
	reg [4:0] add_i_ikxor;
	reg keyexpand_is_ke2;
	wire add_stateen;
	wire add_keyen;
	wire [4:0] add_ikxor;
	function automatic [5:0] key_cycles;
		input reg [1:0] l;
		case (l)
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
	function automatic [5:0] add_requests;
		input reg [4:0] s;
		case (s)
			5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd16, sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 1), sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 4), sv2v_cast_5((5'd16 + 1) + 5), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12):
				if (s == sv2v_cast_5((5'd16 + 1) + 4))
					add_requests = 6'd2;
				else if (s == 5'd8)
					add_requests = 6'd3;
				else if (s == 5'd12)
					add_requests = 6'd4;
				else if (s == 5'd10)
					add_requests = 6'd6;
				else
					add_requests = 6'd2;
			default: add_requests = 6'd0;
		endcase
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		state_done = 1'b0;
		case (state)
			5'd2, 5'd5, 5'd9, 5'd13: state_done = (count == 2) && done_add;
			5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): state_done = (count == 2) && done_add;
			5'd3, 5'd7, 5'd11: state_done = (count == 2) && done_add;
			5'd4: state_done = done_keyexpand;
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 5), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): state_done = done_shiftrow;
			5'd6: state_done = done_mixcolumn;
			sv2v_cast_5((5'd16 + 1) + 1): state_done = (count == 2) && done_add;
			sv2v_cast_5((5'd16 + 1) + 4): state_done = (count == 2) && done_add;
			5'd8, 5'd12: state_done = done_shiftrow;
			5'd10: state_done = (count == 6) && done_add;
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		start_add = 1'b0;
		add_i_add = 1'b1;
		add_i_sbox = 1'b1;
		add_i_xor = 2'b00;
		add_i_ikxor = 5'b00000;
		case (state)
			5'd2: start_add = state_start || (done_add && (count == 1));
			5'd5, 5'd9, 5'd13: begin
				start_add = state_start || (done_add && (count == 1));
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
			end
			5'd16: begin
				start_add = done_mixcolumn || (done_add && (count == 1));
				add_i_xor = (count == 0 ? 2'b11 : 2'b10);
			end
			5'd3, 5'd7, 5'd11: begin
				start_add = done_keyexpand || (done_add && (count == 1));
				add_i_sbox = 1'b0;
				add_i_xor = 2'b11;
			end
			5'd4: begin
				start_add = state_start || (done_add && (count == 1));
				add_i_sbox = 1'b0;
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b10011;
			end
			sv2v_cast_5(5'd16 + 1): begin
				start_add = state_start || (done_add && (count == 1));
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b10011;
			end
			5'd6: start_add = state_start || (done_add && (count == 1));
			sv2v_cast_5((5'd16 + 1) + 1): begin
				start_add = state_start || done_keyexpand;
				add_i_xor = (count == 1 ? 2'b11 : 2'b00);
			end
			sv2v_cast_5((5'd16 + 1) + 2): begin
				start_add = done_mixcolumn || (done_add && (count == 1));
				add_i_xor = (count == 0 ? 2'b11 : 2'b10);
			end
			sv2v_cast_5((5'd16 + 1) + 3): begin
				start_add = done_mixcolumn || (done_add && (count == 1));
				add_i_xor = 2'b11;
			end
			sv2v_cast_5((5'd16 + 1) + 4): begin
				start_add = done_mixcolumn || done_keyexpand;
				add_i_xor = (count == 0 ? 2'b10 : (count == 1 ? 2'b11 : 2'b00));
			end
			5'd8: begin
				start_add = state_start || (done_add && (count < 3));
				add_i_add = count != 0;
				add_i_sbox = 1'b0;
				add_i_xor = (count == 2 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b00111;
			end
			sv2v_cast_5((5'd16 + 1) + 5): begin
				start_add = state_start || done_keyexpand;
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b11100;
			end
			sv2v_cast_5((5'd16 + 1) + 6): begin
				start_add = state_start || (done_add && (count == 1));
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b11000;
			end
			sv2v_cast_5((5'd16 + 1) + 7): begin
				start_add = state_start || (done_add && (count == 1));
				add_i_xor = (count == 0 ? 2'b10 : (count == 1 ? 2'b01 : 2'b00));
				add_i_ikxor = (count == 0 ? 5'b00110 : 5'b00111);
			end
			5'd12: begin
				start_add = state_start || (done_add && (count < 4));
				add_i_add = count >= 2;
				add_i_sbox = 1'b0;
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
			end
			sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): begin
				start_add = state_start || (done_add && (count == 1));
				add_i_xor = (count == 1 ? 2'b01 : 2'b00);
				add_i_ikxor = 5'b11100;
			end
			5'd10: begin
				start_add = (state_start || (done_add && ((count < 4) || (count == 5)))) || done_keyexpand;
				if (count >= 2) begin
					add_i_add = 1'b0;
					add_i_sbox = 1'b0;
				end
				add_i_xor = (count == 4 ? 2'b11 : (count == 5 ? 2'b10 : 2'b00));
			end
			sv2v_cast_5((5'd16 + 1) + 8): start_add = done_mixcolumn || (done_add && (count == 1));
			sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): begin
				start_add = done_mixcolumn || (done_add && (count == 1));
				add_i_xor = (count == 0 ? 2'b11 : 2'b10);
			end
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (state)
			5'd16, 5'd3, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 4), 5'd7, sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10), 5'd11: start_shiftrow = state_start;
			5'd4: start_shiftrow = done_add && (count == 2);
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 5), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 7), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_shiftrow = done_mixcolumn;
			5'd6: start_shiftrow = done_add && (count == 2);
			5'd8: start_shiftrow = done_add && (count == 3);
			5'd12: start_shiftrow = done_add && (count == 4);
			default: start_shiftrow = 1'b0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (state)
			5'd16, sv2v_cast_5((5'd16 + 1) + 2), sv2v_cast_5((5'd16 + 1) + 3), sv2v_cast_5((5'd16 + 1) + 4), sv2v_cast_5((5'd16 + 1) + 8), sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10): start_mixcolumn = done_shiftrow;
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_mixcolumn = done_add && (count == 2);
			sv2v_cast_5((5'd16 + 1) + 5): start_mixcolumn = done_add && (count == 2);
			sv2v_cast_5((5'd16 + 1) + 7): start_mixcolumn = done_add && (count == 2);
			5'd6: start_mixcolumn = done_shiftrow;
			default: start_mixcolumn = 1'b0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (state)
			5'd16, 5'd3, sv2v_cast_5((5'd16 + 1) + 3), 5'd7, sv2v_cast_5((5'd16 + 1) + 9), sv2v_cast_5((5'd16 + 1) + 10), 5'd11: start_keyexpand = state_start;
			5'd4: start_keyexpand = done_add && (count == 2);
			sv2v_cast_5(5'd16 + 1), sv2v_cast_5((5'd16 + 1) + 6), sv2v_cast_5((5'd16 + 1) + 11), sv2v_cast_5((5'd16 + 1) + 12): start_keyexpand = done_add && (count == 2);
			sv2v_cast_5((5'd16 + 1) + 1), sv2v_cast_5((5'd16 + 1) + 5): start_keyexpand = done_add && (count == 1);
			sv2v_cast_5((5'd16 + 1) + 4): start_keyexpand = done_add && (count == 1);
			5'd10: start_keyexpand = done_add && (count == 4);
			default: start_keyexpand = 1'b0;
		endcase
		keyexpand_is_ke2 = (state == sv2v_cast_5((5'd16 + 1) + 9)) || (state == sv2v_cast_5((5'd16 + 1) + 12));
	end
	ControlAdd i_control_add(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_add),
		.r_dec(r_dec),
		.i_add(add_i_add),
		.i_sbox(add_i_sbox),
		.i_xor(add_i_xor),
		.i_ikxor(add_i_ikxor),
		.done(done_add),
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
		.r_dec(r_dec),
		.start(start_shiftrow),
		.done(done_shiftrow),
		.c_srow(c_srow)
	);
	ControlMixColumn i_control_mixcolumn(
		.clk(clk),
		.rst_n(rst_n),
		.r_dec(r_dec),
		.start(start_mixcolumn),
		.done(done_mixcolumn),
		.c_mixcol(c_mixcol)
	);
	ControlKeyExpand i_control_keyexpand(
		.clk(clk),
		.rst_n(rst_n),
		.start(start_keyexpand),
		.is_ke2(keyexpand_is_ke2),
		.done(done_keyexpand),
		.c_ke0(c_ke0),
		.c_ke1(c_ke1),
		.c_ke2(c_ke2)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		state_n = state;
		case (state)
			5'd0:
				if (i_valid && (count == 6'd15))
					state_n = 5'd1;
			5'd1:
				if (i_valid && (count == (key_cycles(r_level) - 1'b1)))
					case ({r_dec, r_level})
						3'b000: state_n = 5'd2;
						3'b001: state_n = 5'd6;
						3'b010, 3'b011: state_n = 5'd10;
						3'b100: state_n = 5'd4;
						3'b101: state_n = 5'd8;
						default: state_n = 5'd12;
					endcase
			5'd2:
				if (state_done)
					state_n = 5'd16;
			5'd16:
				if (state_done && (round == 8))
					state_n = 5'd3;
			5'd3:
				if (state_done)
					state_n = 5'd14;
			5'd4:
				if (state_done)
					state_n = sv2v_cast_5(5'd16 + 1);
			sv2v_cast_5(5'd16 + 1):
				if (state_done && (round == 8))
					state_n = 5'd5;
			5'd5:
				if (state_done)
					state_n = 5'd14;
			5'd6:
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 1);
			sv2v_cast_5((5'd16 + 1) + 1):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 2);
			sv2v_cast_5((5'd16 + 1) + 2):
				if (state_done) begin
					if (round == 10)
						state_n = 5'd7;
					else
						state_n = sv2v_cast_5((5'd16 + 1) + 3);
				end
			sv2v_cast_5((5'd16 + 1) + 3):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 4);
			sv2v_cast_5((5'd16 + 1) + 4):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 2);
			5'd7:
				if (state_done)
					state_n = 5'd14;
			5'd8:
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 5);
			sv2v_cast_5((5'd16 + 1) + 5):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 6);
			sv2v_cast_5((5'd16 + 1) + 6):
				if (state_done) begin
					if (round == 10)
						state_n = 5'd9;
					else
						state_n = sv2v_cast_5((5'd16 + 1) + 7);
				end
			sv2v_cast_5((5'd16 + 1) + 7):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 5);
			5'd9:
				if (state_done)
					state_n = 5'd14;
			5'd10:
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 8);
			sv2v_cast_5((5'd16 + 1) + 8):
				if (state_done && (round == 1))
					state_n = sv2v_cast_5((5'd16 + 1) + 9);
			sv2v_cast_5((5'd16 + 1) + 9):
				if (state_done) begin
					if (round == 12)
						state_n = 5'd11;
					else
						state_n = sv2v_cast_5((5'd16 + 1) + 10);
				end
			sv2v_cast_5((5'd16 + 1) + 10):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 9);
			5'd11:
				if (state_done)
					state_n = 5'd14;
			5'd12:
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 11);
			sv2v_cast_5((5'd16 + 1) + 11):
				if (state_done) begin
					if (round == 12)
						state_n = 5'd13;
					else
						state_n = sv2v_cast_5((5'd16 + 1) + 12);
				end
			sv2v_cast_5((5'd16 + 1) + 12):
				if (state_done)
					state_n = sv2v_cast_5((5'd16 + 1) + 11);
			5'd13:
				if (state_done)
					state_n = 5'd14;
			5'd14:
				if (o_ready && (count == 6'd15))
					state_n = 5'd0;
			default: state_n = 5'd0;
		endcase
	end
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			state <= 5'd0;
			count <= 1'sb0;
			round <= 1'sb0;
			phase <= 0;
			state_start <= 0;
		end
		else if (((state == 5'd0) || (state == 5'd1)) && !i_valid)
			;
		else if ((state == 5'd14) && !o_ready)
			;
		else begin
			state_start <= 0;
			if (((state == 5'd0) || (state == 5'd1)) || (state == 5'd14)) begin
				if (state_n != state)
					count <= 1'sb0;
				else
					count <= count + 1'b1;
			end
			if (processing(state) && start_add)
				count <= count + 1'b1;
			if (processing(state)) begin
				if (state_done) begin
					phase <= 0;
					count <= 1'sb0;
					state <= state_n;
					if (processing(state_n))
						state_start <= 1;
					if (state[4])
						round <= round + 1'b1;
				end
			end
			else if (state_n != state) begin
				state <= state_n;
				phase <= 0;
				if (processing(state_n))
					state_start <= 1;
				if (state == 5'd1)
					round <= 0;
			end
		end
	assign c_stateen = (state == 5'd0 ? i_valid : (state == 5'd14 ? o_ready : add_stateen));
	assign c_loadkey = (state == 5'd1) && i_valid;
	assign c_keyen = (state == 5'd1 ? i_valid : add_keyen);
	assign c_ikxor = add_ikxor;
	assign c_dec192_keysel = ((state == sv2v_cast_5((5'd16 + 1) + 5)) && add_keyen ? 2'b01 : ((state == sv2v_cast_5((5'd16 + 1) + 6)) && add_keyen ? 2'b10 : 2'b00));
	assign i_ready = (state == 5'd0) || (state == 5'd1);
	assign o_valid = state == 5'd14;
	assign d_state = state;
	initial _sv2v_0 = 0;
endmodule