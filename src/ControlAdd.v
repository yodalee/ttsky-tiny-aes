module ControlAdd (
	clk,
	rst_n,
	start,
	r_dec,
	i_add,
	i_sbox,
	i_xor,
	i_ikxor,
	c_keyen,
	c_add,
	c_stateen,
	c_sbox,
	c_kxor,
	c_ikxor
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire start;
	input wire r_dec;
	input wire i_add;
	input wire i_sbox;
	input wire [1:0] i_xor;
	input wire [4:0] i_ikxor;
	output wire c_keyen;
	output reg c_add;
	output wire c_stateen;
	output reg c_sbox;
	output reg c_kxor;
	output reg [4:0] c_ikxor;
	reg add_q;
	reg sbox_q;
	reg [1:0] xor_q;
	reg [4:0] ikxor_q;
	reg busy;
	reg [2:0] cycle;
	wire direct_start;
	function automatic xor_enabled;
		input reg [1:0] xor_select;
		input reg [2:0] cycle_index;
		case (xor_select)
			2'b10: xor_enabled = cycle_index < 3'd4;
			2'b01: xor_enabled = cycle_index >= 3'd4;
			2'b11: xor_enabled = 1'b1;
			default: xor_enabled = 1'b0;
		endcase
	endfunction
	assign direct_start = (rst_n && start) && !busy;
	always @(*) begin
		if (_sv2v_0)
			;
		c_add = 1'b0;
		c_sbox = 1'b0;
		c_kxor = 1'b0;
		c_ikxor = 5'b00000;
		if (direct_start) begin
			c_add = i_add;
			c_sbox = i_sbox;
			c_kxor = !r_dec && xor_enabled(i_xor, 3'd0);
			c_ikxor = (r_dec && xor_enabled(i_xor, 3'd0) ? i_ikxor : 5'b00000);
		end
		else if (busy) begin
			c_add = add_q;
			c_sbox = sbox_q;
			c_kxor = !r_dec && xor_enabled(xor_q, cycle);
			c_ikxor = (r_dec && xor_enabled(xor_q, cycle) ? ikxor_q : 5'b00000);
		end
	end
	assign c_stateen = c_add | c_sbox;
	assign c_keyen = busy | direct_start;
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			add_q <= 1'b0;
			sbox_q <= 1'b0;
			xor_q <= 2'b00;
			ikxor_q <= 5'b00000;
			cycle <= 3'd0;
			busy <= 1'b0;
		end
		else if (direct_start) begin
			add_q <= i_add;
			sbox_q <= i_sbox;
			xor_q <= i_xor;
			ikxor_q <= i_ikxor;
			cycle <= 3'd1;
			busy <= 1'b1;
		end
		else if (busy && (cycle == 3'd7)) begin
			cycle <= 3'd0;
			busy <= 1'b0;
		end
		else if (busy)
			cycle <= cycle + 3'd1;
		else
			cycle <= 3'd0;
	initial _sv2v_0 = 0;
endmodule