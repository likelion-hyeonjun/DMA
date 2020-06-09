`timescale 1ns/1ns
`define PERIOD1 100
`define MEMORY_SIZE 256	//	size of memory is 2^8 words (reduced size)
`define WORD_SIZE 16	//	instead of 2^16 words to reduce memory
			//	requirements in the Active-HDL simulator 

module Memory(clk, reset_n, readM, writeM, address, data);
	input clk;
	wire clk;
	input reset_n;
	wire reset_n;
	
	input readM;
	wire readM;
	input writeM;
	wire writeM;
	input [`WORD_SIZE-1:0] address;
	wire [`WORD_SIZE-1:0] address;
	inout data;
	wire [`WORD_SIZE-1:0] data;
	
	reg [`WORD_SIZE-1:0] memory [0:`MEMORY_SIZE-1];
	reg [`WORD_SIZE-1:0] outputData;
	
	assign data = readM?outputData:`WORD_SIZE'bz;
	
	always@(posedge clk)
		if(!reset_n)
			begin
				memory[16'h0] <= 16'h9023;     // JMP Addr: 16`h23
				memory[16'h1] <= 16'h1;
				memory[16'h2] <= 16'hffff;
				memory[16'h3] <= 16'h0;
				memory[16'h4] <= 16'h0;
				memory[16'h5] <= 16'h0;
				memory[16'h6] <= 16'h0;
				memory[16'h7] <= 16'h0;
				memory[16'h8] <= 16'h0;
				memory[16'h9] <= 16'h0;
				memory[16'ha] <= 16'h0;
				memory[16'hb] <= 16'h0;
				memory[16'hc] <= 16'h0;
				memory[16'hd] <= 16'h0;
				memory[16'he] <= 16'h0;
				memory[16'hf] <= 16'h0;
				memory[16'h10] <= 16'h0;
				memory[16'h11] <= 16'h0;
				memory[16'h12] <= 16'h0;
				memory[16'h13] <= 16'h0;
				memory[16'h14] <= 16'h0;
				memory[16'h15] <= 16'h0;
				memory[16'h16] <= 16'h0;
				memory[16'h17] <= 16'h0;
				memory[16'h18] <= 16'h0;
				memory[16'h19] <= 16'h0;
				memory[16'h1a] <= 16'h0;
				memory[16'h1b] <= 16'h0;
				memory[16'h1c] <= 16'h0;
				memory[16'h1d] <= 16'h0;
				memory[16'h1e] <= 16'h0;
				memory[16'h1f] <= 16'h0;
				memory[16'h20] <= 16'h0;
				memory[16'h21] <= 16'h0;
				memory[16'h22] <= 16'h0;     
				memory[16'h23] <= 16'h6000;     // LHI rs:0 rt:0 immediate/offest: 16`h0 -> 0 0 0 0
				memory[16'h24] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:3 -> 0 0 0 0 outputport 0
				memory[16'h25] <= 16'h6100;     // LHI rs:0 rt:1 immediate/offest: 16`h0 -> 0 0 0 0 
				memory[16'h26] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:5 -> 0 0 0 0 outputport 0
				memory[16'h27] <= 16'h6200;     // LHI rs:0 rt:2 immediate/offest: 16`h0 -> 0 0 0 0 
				memory[16'h28] <= 16'hf81c;     // WWD rs:2 rt:0 //inst_cnt:7 -> 0 0 0 0 outputport 0
				memory[16'h29] <= 16'h6300;     // LHI rs:0 rt:3 immediate/offest: 16`h0 -> 0 0 0 0
				memory[16'h2a] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:9 ->0 0 0 0 outputport 0
				memory[16'h2b] <= 16'h4401;     // ADI rs:1 rt:0 immediate/offest: 16`h1 -> 1 0 0 0
				memory[16'h2c] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:11 -> 1 0 0 0 outputport 1
				memory[16'h2d] <= 16'h4001;     // ADI rs:0 rt:0 immediate/offest: 16`h1 -> 2 0 0 0
				memory[16'h2e] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:13 -> 2 0 0 0 outputport 2
				memory[16'h2f] <= 16'h5901;     // ORI rs:2 rt:1 immediate/offest: 16`h1 -> 2 1 0 0
				memory[16'h30] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:15 -> 2 1 0 0 ouputport 1 
				memory[16'h31] <= 16'h5502;     // ORI rs:1 rt:1 immediate/offest: 16`h2 ->2 3 0 0
				memory[16'h32] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:17 -> 2 3 0 0 outputport 3
				memory[16'h33] <= 16'h5503;     // ORI rs:1 rt:1 immediate/offest: 16`h3 -> 2 3 0 0
				memory[16'h34] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:19 -> 2 3 0 0 outputport 3
				memory[16'h35] <= 16'hf2c0;     // ADD rs:0 rt:2 rd:3 -> 2 3 0 2
				memory[16'h36] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:21 -> 2 3 0 2 outputport 2
				memory[16'h37] <= 16'hf6c0;     // ADD rs:1 rt:2 rd:3 -> 2 3 0 3
				memory[16'h38] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:23 ->2 3 0 3 outputport 3
				memory[16'h39] <= 16'hf1c0;     // ADD rs:0 rt:1
				memory[16'h3a] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:25
				memory[16'h3b] <= 16'hf2c1;     // SUB rs:0 rt:2
				memory[16'h3c] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:27
				memory[16'h3d] <= 16'hf8c1;     // SUB rs:2 rt:0
				memory[16'h3e] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:29
				memory[16'h3f] <= 16'hf6c1;     // SUB rs:1 rt:2
				memory[16'h40] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:31
				memory[16'h41] <= 16'hf9c1;     // SUB rs:2 rt:1
				memory[16'h42] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:33
				memory[16'h43] <= 16'hf1c1;     // SUB rs:0 rt:1 
				memory[16'h44] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:35
				memory[16'h45] <= 16'hf4c1;     // SUB rs:1 rt:0
				memory[16'h46] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:37
				memory[16'h47] <= 16'hf2c2;     // AND rs:0 rt:2
				memory[16'h48] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:39
				memory[16'h49] <= 16'hf6c2;     // AND rs:1 rt:2
				memory[16'h4a] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:41
				memory[16'h4b] <= 16'hf1c2;     // AND rs:0 rt:1
				memory[16'h4c] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:43
				memory[16'h4d] <= 16'hf2c3;     // ORR rs:0 rt:2
				memory[16'h4e] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:45
				memory[16'h4f] <= 16'hf6c3;     // ORR rs:1 rt:2
				memory[16'h50] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:47
				memory[16'h51] <= 16'hf1c3;     // ORR rs:0 rt:1
				memory[16'h52] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:49
				memory[16'h53] <= 16'hf0c4;     // NOT rs:0 rt:0
				memory[16'h54] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:51
				memory[16'h55] <= 16'hf4c4;     // NOT rs:1 rt:0
				memory[16'h56] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:53
				memory[16'h57] <= 16'hf8c4;     // NOT rs:2 rt:0
				memory[16'h58] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:55
				memory[16'h59] <= 16'hf0c5;     // TCP rs:0 rt:0
				memory[16'h5a] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:57
				memory[16'h5b] <= 16'hf4c5;     // TCP rs:1 rt:0
				memory[16'h5c] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:59
				memory[16'h5d] <= 16'hf8c5;     // TCP rs:2 rt:0
				memory[16'h5e] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:61
				memory[16'h5f] <= 16'hf0c6;     // SHL rs:0 rt:0
				memory[16'h60] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:63
				memory[16'h61] <= 16'hf4c6;     // SHL rs:1 rt:0
				memory[16'h62] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:65
				memory[16'h63] <= 16'hf8c6;     // SHL rs:2 rt:0
				memory[16'h64] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:67
				memory[16'h65] <= 16'hf0c7;     // SHR rs:0 rt:0
				memory[16'h66] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:69
				memory[16'h67] <= 16'hf4c7;     // SHR rs:1 rt:0
				memory[16'h68] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:71
				memory[16'h69] <= 16'hf8c7;     // SHR rs:2 rt:0
				memory[16'h6a] <= 16'hfc1c;     // WWD rs:3 rt:0 //inst_cnt:73
				memory[16'h6b] <= 16'h7801;     // LWD rs:2 rt:0 immediate/offest: 16`h1
				memory[16'h6c] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:75 //problem
				memory[16'h6d] <= 16'h7902;     // LWD rs:2 rt:1 immediate/offest: 16`h2
				memory[16'h6e] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:77
				memory[16'h6f] <= 16'h8901;     // SWD rs:2 rt:1 immediate/offest: 16`h1
				memory[16'h70] <= 16'h8802;     // SWD rs:2 rt:0 immediate/offest: 16`h2
				memory[16'h71] <= 16'h7801;     // LWD rs:2 rt:0 immediate/offest: 16`h1
				memory[16'h72] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:81
				memory[16'h73] <= 16'h7902;     // LWD rs:2 rt:1 immediate/offest: 16`h2
				memory[16'h74] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt::83
				memory[16'h75] <= 16'h9076;     // JMP Addr: 16`h76
				memory[16'h76] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:85
				memory[16'h77] <= 16'h9079;     // JMP Addr: 16`h79
				memory[16'h78] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h79] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:87
				memory[16'h7a] <= 16'hb01;     // BNE rs:2 rt:3 immediate/offest: 16`h1
				memory[16'h7b] <= 16'h907d;     // JMP Addr: 16`h7d
				memory[16'h7c] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h7d] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:90
				memory[16'h7e] <= 16'h601;     // BNE rs:1 rt:2 immediate/offest: 16`h1
				memory[16'h7f] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h80] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:92
				memory[16'h81] <= 16'h1601;     // BEQ rs:1 rt:2 immediate/offest: 16`h1
				memory[16'h82] <= 16'h9084;     // JMP Addr: 16`h84
				memory[16'h83] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h84] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:95
				memory[16'h85] <= 16'h1b01;     // BEQ rs:2 rt:3 immediate/offest: 16`h1
				memory[16'h86] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h87] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:97
				memory[16'h88] <= 16'h2001;     // BGZ rs:0 rt:0 immediate/offest: 16`h1
				memory[16'h89] <= 16'h908b;     // JMP Addr: 16`h8b
				memory[16'h8a] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h8b] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:100
				memory[16'h8c] <= 16'h2401;     // BGZ rs:1 rt:0 immediate/offest: 16`h1
				memory[16'h8d] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h8e] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:102
				memory[16'h8f] <= 16'h2801;     // BGZ rs:2 rt:0 immediate/offest: 16`h1
				memory[16'h90] <= 16'h9092;     // JMP Addr: 16`h92
				memory[16'h91] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h92] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:105
				memory[16'h93] <= 16'h3001;     // BLZ rs:0 rt:0 immediate/offest: 16`h1
				memory[16'h94] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h95] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:107
				memory[16'h96] <= 16'h3401;     // BLZ rs:1 rt:0 immediate/offest: 16`h1
				memory[16'h97] <= 16'h9099;     // JMP Addr: 16`h99
				memory[16'h98] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h99] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:110
				memory[16'h9a] <= 16'h3801;     // BLZ rs:2 rt:0 immediate/offest: 16`h1
				memory[16'h9b] <= 16'h909d;     // JMP Addr: 16`h9d
				memory[16'h9c] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'h9d] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:113
				memory[16'h9e] <= 16'ha0af;     // JAL Addr: 16`haf //inst_cnt:114
				memory[16'h9f] <= 16'hf01c;     // WWD rs:0 rt:0 //inst_cnt:116
				memory[16'ha0] <= 16'ha0ae;     // JAL Addr: 16`hae //inst_cnt:117
				memory[16'ha1] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'ha2] <= 16'hf41c;     // WWD rs:1 rt:0 //inst_cnt:120
				memory[16'ha3] <= 16'h6300;     // LHI rs:0 rt:3 immediate/offest: 16`h0 //inst_cnt:121
				memory[16'ha4] <= 16'h5f03;     // ORI rs:3 rt:3 immediate/offest: 16`h3 //inst_cnt:122
				memory[16'ha5] <= 16'h6000;     // LHI rs:0 rt:0 immediate/offest: 16`h0 //inst_cnt:123
				memory[16'ha6] <= 16'h4005;     // ADI rs:0 rt:0 immediate/offest: 16`h5 //inst_cnt:124
				memory[16'ha7] <= 16'ha0b2;     // JAL Addr: 16`hb2 //inst_cnt:125
				memory[16'ha8] <= 16'hf01c;     // WWD rs:0 rt:0
				memory[16'ha9] <= 16'h90b1;     // JMP Addr: 16`hb1
				memory[16'haa] <= 16'h4900;     // ADI rs:2 rt:1 immediate/offest: 16`h0
				memory[16'hab] <= 16'hf41a;     // JRL rs:1 rt:0
				memory[16'hac] <= 16'hf01c;     // WWD rs:0 rt:0
				memory[16'had] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'hae] <= 16'h4a01;     // ADI rs:2 rt:2 immediate/offest: 16`h1 //inst_cnt:118
				memory[16'haf] <= 16'hf819;     // JPR rs:2 rt:0 //inst_cnt:115 //inst_cnt:119 // problem
				memory[16'hb0] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'hb1] <= 16'ha0aa;     // JAL Addr: 16`haa
				memory[16'hb2] <= 16'h41ff;     // ADI rs:0 rt:1 immediate/offest: 16`hff //inst_cnt:126
				memory[16'hb3] <= 16'h2404;     // BGZ rs:1 rt:0 immediate/offest: 16`h4 //inst_cnt:127
				memory[16'hb4] <= 16'h6000;     // LHI rs:0 rt:0 immediate/offest: 16`h0 
				memory[16'hb5] <= 16'h5001;     // ORI rs:0 rt:0 immediate/offest: 16`h1
				memory[16'hb6] <= 16'hf819;     // JPR rs:2 rt:0
				memory[16'hb7] <= 16'hf01d;     // HLT rs:0 rt:0
				memory[16'hb8] <= 16'h8e00;     // SWD rs:3 rt:2 immediate/offest: 16`h0 //inst_cnt:128
				memory[16'hb9] <= 16'h8c01;     // SWD rs:3 rt:0 immediate/offest: 16`h1 //inst_cnt:129
				memory[16'hba] <= 16'h4f02;     // ADI rs:3 rt:3 immediate/offest: 16`h2 //inst_cnt:130
				memory[16'hbb] <= 16'h40fe;     // ADI rs:0 rt:0 immediate/offest: 16`hfe //inst_cnt:131
				memory[16'hbc] <= 16'ha0b2;     // JAL Addr: 16`hb2 //inst_cnt:132
				memory[16'hbd] <= 16'h7dff;     // LWD rs:3 rt:1 immediate/offest: 16`hff
				memory[16'hbe] <= 16'h8cff;     // SWD rs:3 rt:0 immediate/offest: 16`hff
				memory[16'hbf] <= 16'h44ff;     // ADI rs:1 rt:0 immediate/offest: 16`hff
				memory[16'hc0] <= 16'ha0b2;     // JAL Addr: 16`hb2
				memory[16'hc1] <= 16'h7dff;     // LWD rs:3 rt:1 immediate/offest: 16`hff
				memory[16'hc2] <= 16'h7efe;     // LWD rs:3 rt:2 immediate/offest: 16`hfe
				memory[16'hc3] <= 16'hf100;     // ADD rs:0 rt:1
				memory[16'hc4] <= 16'h4ffe;     // ADI rs:3 rt:3 immediate/offest: 16`hfe
				memory[16'hc5] <= 16'hf819;     // JPR rs:2 rt:0
				memory[16'hc6] <= 16'hf01d;     // HLT rs:0 rt:0
			end
		else
			begin
				if(readM)outputData <= memory[address];
				if(writeM)memory[address] <= data;
			end
endmodule