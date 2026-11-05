module SboxArish (
	c_inv,
	i_data,
	o_data
);
	input wire c_inv;
	input wire [7:0] i_data;
	output wire [7:0] o_data;
	localparam [1:0] ETA = 2'b01;
	localparam [3:0] NU = 4'b0010;
	function automatic [15:0] rebase_in;
		input reg [7:0] n;
		begin
			rebase_in[0] = (n[0] ^ n[5]) ^ n[6];
			rebase_in[1] = (((n[0] ^ n[1]) ^ n[2]) ^ n[3]) ^ n[6];
			rebase_in[2] = (((n[0] ^ n[1]) ^ n[3]) ^ n[4]) ^ n[7];
			rebase_in[3] = n[0];
			rebase_in[4] = ((n[0] ^ n[1]) ^ n[5]) ^ n[6];
			rebase_in[5] = ((n[0] ^ n[5]) ^ n[6]) ^ n[7];
			rebase_in[6] = ((((n[0] ^ n[1]) ^ n[2]) ^ n[5]) ^ n[6]) ^ n[7];
			rebase_in[7] = ((n[0] ^ n[4]) ^ n[5]) ^ n[6];
			rebase_in[8] = (n[0] ^ n[3]) ^ n[4];
			rebase_in[9] = (((n[0] ^ n[1]) ^ n[4]) ^ n[5]) ^ n[6];
			rebase_in[10] = (n[4] ^ n[6]) ^ n[7];
			rebase_in[11] = (n[2] ^ n[5]) ^ n[7];
			rebase_in[12] = n[4] ^ n[6];
			rebase_in[13] = ((n[0] ^ n[1]) ^ n[3]) ^ n[6];
			rebase_in[14] = n[4] ^ n[7];
			rebase_in[15] = ((n[0] ^ n[1]) ^ n[4]) ^ n[6];
		end
	endfunction
	function automatic [15:0] rebase_out;
		input reg [7:0] n;
		begin
			rebase_out[0] = (n[0] ^ n[5]) ^ n[7];
			rebase_out[1] = (n[0] ^ n[4]) ^ n[5];
			rebase_out[2] = (((n[1] ^ n[2]) ^ n[3]) ^ n[4]) ^ n[7];
			rebase_out[3] = (((n[2] ^ n[4]) ^ n[5]) ^ n[6]) ^ n[7];
			rebase_out[4] = (n[2] ^ n[4]) ^ n[6];
			rebase_out[5] = n[1] ^ n[7];
			rebase_out[6] = n[2] ^ n[6];
			rebase_out[7] = n[2] ^ n[4];
			rebase_out[8] = n[3];
			rebase_out[9] = n[0] ^ n[4];
			rebase_out[10] = ((n[0] ^ n[4]) ^ n[5]) ^ n[6];
			rebase_out[11] = ((((n[0] ^ n[2]) ^ n[3]) ^ n[4]) ^ n[5]) ^ n[7];
			rebase_out[12] = n[0] ^ n[7];
			rebase_out[13] = ((((n[1] ^ n[2]) ^ n[3]) ^ n[4]) ^ n[6]) ^ n[7];
			rebase_out[14] = ((((n[0] ^ n[1]) ^ n[2]) ^ n[4]) ^ n[6]) ^ n[7];
			rebase_out[15] = n[0] ^ n[5];
		end
	endfunction
	function automatic [1:0] g4_mul;
		input reg [1:0] a;
		input reg [1:0] b;
		reg a1;
		reg a0;
		reg b1;
		reg b0;
		reg ap1;
		reg ap0;
		reg bp1;
		reg bp0;
		reg cp1;
		reg cp0;
		reg x1;
		reg x0;
		begin
			a1 = a[1];
			a0 = a[0];
			b1 = b[1];
			b0 = b[0];
			ap1 = a1 ^ a0;
			ap0 = a0;
			bp1 = b1 ^ b0;
			bp0 = b0;
			cp0 = (ap0 & bp0) ^ (ap1 & bp1);
			cp1 = ((ap1 & bp0) ^ (ap0 & bp1)) ^ (ap1 & bp1);
			x0 = cp0;
			x1 = cp1 ^ cp0;
			g4_mul = {x1, x0};
		end
	endfunction
	function automatic [3:0] g16_mul;
		input reg [3:0] a;
		input reg [3:0] b;
		reg [1:0] a1;
		reg [1:0] a0;
		reg [1:0] b1;
		reg [1:0] b0;
		reg [1:0] ap;
		reg [1:0] aq;
		reg [1:0] bp;
		reg [1:0] bq;
		reg [1:0] t;
		reg [1:0] cp;
		reg [1:0] cq;
		reg [1:0] x1;
		reg [1:0] x0;
		begin
			a1 = a[3:2];
			a0 = a[1:0];
			b1 = b[3:2];
			b0 = b[1:0];
			ap = a1 ^ a0;
			aq = a0;
			bp = b1 ^ b0;
			bq = b0;
			t = g4_mul(ap, bp);
			cp = (t ^ g4_mul(ap, bq)) ^ g4_mul(aq, bp);
			cq = g4_mul(ETA, t) ^ g4_mul(aq, bq);
			x0 = cq;
			x1 = cp ^ cq;
			g16_mul = {x1, x0};
		end
	endfunction
	function automatic [3:0] g16_inv;
		input reg [3:0] a;
		(* full_case, parallel_case *)
		case (a)
			4'h0: g16_inv = 4'h0;
			4'h1: g16_inv = 4'h4;
			4'h2: g16_inv = 4'hc;
			4'h3: g16_inv = 4'h8;
			4'h4: g16_inv = 4'h1;
			4'h5: g16_inv = 4'ha;
			4'h6: g16_inv = 4'he;
			4'h7: g16_inv = 4'hd;
			4'h8: g16_inv = 4'h3;
			4'h9: g16_inv = 4'hb;
			4'ha: g16_inv = 4'h5;
			4'hb: g16_inv = 4'h9;
			4'hc: g16_inv = 4'h2;
			4'hd: g16_inv = 4'h7;
			4'he: g16_inv = 4'h6;
			4'hf: g16_inv = 4'hf;
			default: g16_inv = 4'h0;
		endcase
	endfunction
	function automatic [3:0] g17;
		input reg [3:0] a;
		input reg [3:0] b;
		reg [3:0] c;
		reg [3:0] d;
		reg [3:0] sqr;
		reg a32;
		reg b32;
		reg a31;
		reg b31;
		reg a10;
		reg b10;
		reg a20;
		reg b20;
		reg ap;
		reg bp;
		begin
			a32 = a[3] ^ a[2];
			b32 = b[3] ^ b[2];
			a31 = a[3] ^ a[1];
			b31 = b[3] ^ b[1];
			a10 = a[1] ^ a[0];
			b10 = b[1] ^ b[0];
			a20 = a[2] ^ a[0];
			b20 = b[2] ^ b[0];
			ap = a31 ^ a20;
			bp = b31 ^ b20;
			g17[3] = (((a32 & b32) ^ (a31 & b31)) ^ (a[3] & b[3])) ^ (a20 | b20);
			g17[2] = (((a32 & b32) ^ (a31 | b31)) ^ (a[2] & b[2])) ^ (ap & bp);
			g17[1] = (((a[1] | b[1]) ^ (a20 & b20)) ^ (a10 & b10)) ^ (a31 & b31);
			g17[0] = (((a[0] & b[0]) ^ (ap & bp)) ^ (a10 | b10)) ^ (a31 & b31);
		end
	endfunction
	function automatic [7:0] out_mul;
		input reg [3:0] a;
		input reg [3:0] b;
		input reg [3:0] e;
		reg [3:0] p;
		reg [3:0] q;
		reg a32;
		reg a10;
		reg a20;
		reg a31;
		reg ap;
		reg b32;
		reg b10;
		reg b20;
		reg b31;
		reg bp;
		reg e31;
		reg e20;
		reg p4;
		reg p5;
		reg q4;
		reg q5;
		begin
			a32 = a[3] ^ a[2];
			a31 = a[3] ^ a[1];
			a20 = a[2] ^ a[0];
			a10 = a[1] ^ a[0];
			ap = a32 ^ a10;
			b32 = b[3] ^ b[2];
			b31 = b[3] ^ b[1];
			b20 = b[2] ^ b[0];
			b10 = b[1] ^ b[0];
			bp = b32 ^ b10;
			e31 = e[3] ^ e[1];
			e20 = e[2] ^ e[0];
			p4 = (b20 & e20) ^ (b31 & e31);
			p5 = (bp & e20) ^ (b20 & e31);
			p[3] = ((b[2] & e[3]) ^ (b32 & e[2])) ^ p4;
			p[2] = ((b[3] & e[2]) ^ (b32 & e[3])) ^ p5;
			p[1] = ((b[0] & e[1]) ^ (b10 & e[0])) ^ p4;
			p[0] = ((b[1] & e[0]) ^ (b10 & e[1])) ^ p5;
			q4 = (a20 & e20) ^ (a31 & e31);
			q5 = (ap & e20) ^ (a20 & e31);
			q[3] = ((a[2] & e[3]) ^ (a32 & e[2])) ^ q4;
			q[2] = ((a[3] & e[2]) ^ (a32 & e[3])) ^ q5;
			q[1] = ((a[0] & e[1]) ^ (a10 & e[0])) ^ q4;
			q[0] = ((a[1] & e[0]) ^ (a10 & e[1])) ^ q5;
			out_mul = {p, q};
		end
	endfunction
	function automatic [7:0] g256_inverse;
		input reg [7:0] n;
		reg [3:0] a;
		reg [3:0] b;
		reg [3:0] d;
		reg [3:0] e;
		reg [7:0] pq;
		begin
			a = n[7:4];
			b = n[3:0];
			d = g17(a, b);
			e = g16_inv(d);
			pq = out_mul(a, b, e);
			g256_inverse = pq;
		end
	endfunction
	function automatic [7:0] arish_sbox;
		input reg [7:0] n;
		input reg inv;
		reg [7:0] shifted;
		reg [7:0] nb;
		reg [7:0] inverted;
		reg [15:0] input_rebase;
		reg [15:0] output_rebase;
		begin
			shifted = (inv ? n ^ 8'h63 : n);
			input_rebase = rebase_in(shifted);
			nb = (inv ? input_rebase[15:8] : input_rebase[7:0]);
			inverted = g256_inverse(nb);
			output_rebase = rebase_out(inverted);
			arish_sbox = (inv ? output_rebase[15:8] : output_rebase[7:0] ^ 8'h63);
		end
	endfunction
	assign o_data = arish_sbox(i_data, c_inv);
endmodule