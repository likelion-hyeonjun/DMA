`timescale 1ns/1ns

`include "cache.v"

`define PERIOD1 100
`define MEMORY_SIZE 256	//	size of memory is 2^8 words (reduced size)
`define WORD_SIZE 16	//	instead of 2^16 words to reduce memory
			//	requirements in the Active-HDL simulator 

module Memory(clk, reset_n, address1, address2, readC1, readC2, writeC2, writeCacheData,
cacheHit1, cacheHit2, cacheData1, cacheData2, writeToData, NumHit, NumMiss);

	input clk;
	wire clk;
	input reset_n;
	wire reset_n;
	
	wire readM1;
	input [`WORD_SIZE-1:0] address1;
	wire [`WORD_SIZE-1:0] address1;

	wire readM2;
	wire writeM2;
	input [`WORD_SIZE-1:0] address2;
	wire [`WORD_SIZE-1:0] address2;

	reg [`WORD_SIZE-1:0] memory [0:`MEMORY_SIZE-1];
	reg [`WORD_SIZE-1:0] outputData2;
	
	//added
	input readC1;
	wire readC1;
	input readC2;
	wire readC2;
	input writeC2;
	wire writeC2;
	input [15:0] writeCacheData;
	wire [15:0] writeCacheData;

	output wire cacheHit1;
	output wire cacheHit2;
	output wire [15:0] cacheData1;
	output wire [15:0] cacheData2;
	output wire [`WORD_SIZE-1:0] NumHit;
	output wire [`WORD_SIZE-1:0] NumMiss;

	output wire writeToData;

	reg[1:0] instReady;
	reg[1:0] memReadReady;
	reg[1:0] memWriteReady;
	reg[15:0] instData00;
	reg[15:0] instData01;
	reg[15:0] instData10;
	reg[15:0] instData11;
	reg[15:0] memData00;
	reg[15:0] memData01;
	reg[15:0] memData10;
	reg[15:0] memData11;

	wire [15:0] evicted1_00;
	wire [15:0] evicted1_01;
	wire [15:0] evicted1_10;
	wire [15:0] evicted1_11;
	wire [15:0] evicted2_00;
	wire [15:0] evicted2_01;
	wire [15:0] evicted2_10;
	wire [15:0] evicted2_11;
	wire evict1;
	wire evict2;
	wire [15:0] evicted1_address;
	wire [15:0] evicted2_address;

	integer inst_cnt;
	integer memRead_cnt;
	integer memWrite_cnt;

	reg [15:0] address1_00;
	reg [15:0] address2_00;

	cache cacheA  (clk,reset_n,readC1,readC2,writeC2, address1, address2, writeCacheData,
	instData00, instData01, instData10, instData11, memData00, memData01, memData10, memData11, instReady, memReadReady, memWriteReady,
	cacheHit1, cacheHit2, cacheData1, cacheData2, readM1, readM2, writeM2, writeToData,
	evicted1_00, evicted1_01, evicted1_10, evicted1_11, evicted2_00, evicted2_01, evicted2_10, evicted2_11,evict1,evict2,evicted1_address,evicted2_address,NumHit, NumMiss);
	
	always@(posedge clk)
		if(!reset_n)
			begin
				memory[16'h0] <= 16'h9023;
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
				memory[16'h23] <= 16'h6000;
				memory[16'h24] <= 16'hf01c;
				memory[16'h25] <= 16'h6100;
				memory[16'h26] <= 16'hf41c;
				memory[16'h27] <= 16'h6200;
				memory[16'h28] <= 16'hf81c;
				memory[16'h29] <= 16'h6300;
				memory[16'h2a] <= 16'hfc1c;
				memory[16'h2b] <= 16'h4401;
				memory[16'h2c] <= 16'hf01c;
				memory[16'h2d] <= 16'h4001;
				memory[16'h2e] <= 16'hf01c;
				memory[16'h2f] <= 16'h5901;
				memory[16'h30] <= 16'hf41c;
				memory[16'h31] <= 16'h5502;
				memory[16'h32] <= 16'hf41c;
				memory[16'h33] <= 16'h5503;
				memory[16'h34] <= 16'hf41c;
				memory[16'h35] <= 16'hf2c0;
				memory[16'h36] <= 16'hfc1c;
				memory[16'h37] <= 16'hf6c0;
				memory[16'h38] <= 16'hfc1c;
				memory[16'h39] <= 16'hf1c0;
				memory[16'h3a] <= 16'hfc1c;
				memory[16'h3b] <= 16'hf2c1;
				memory[16'h3c] <= 16'hfc1c;
				memory[16'h3d] <= 16'hf8c1;
				memory[16'h3e] <= 16'hfc1c;
				memory[16'h3f] <= 16'hf6c1;
				memory[16'h40] <= 16'hfc1c;
				memory[16'h41] <= 16'hf9c1;
				memory[16'h42] <= 16'hfc1c;
				memory[16'h43] <= 16'hf1c1;
				memory[16'h44] <= 16'hfc1c;
				memory[16'h45] <= 16'hf4c1;
				memory[16'h46] <= 16'hfc1c;
				memory[16'h47] <= 16'hf2c2;
				memory[16'h48] <= 16'hfc1c;
				memory[16'h49] <= 16'hf6c2;
				memory[16'h4a] <= 16'hfc1c;
				memory[16'h4b] <= 16'hf1c2;
				memory[16'h4c] <= 16'hfc1c;
				memory[16'h4d] <= 16'hf2c3;
				memory[16'h4e] <= 16'hfc1c;
				memory[16'h4f] <= 16'hf6c3;
				memory[16'h50] <= 16'hfc1c;
				memory[16'h51] <= 16'hf1c3;
				memory[16'h52] <= 16'hfc1c;
				memory[16'h53] <= 16'hf0c4;
				memory[16'h54] <= 16'hfc1c;
				memory[16'h55] <= 16'hf4c4;
				memory[16'h56] <= 16'hfc1c;
				memory[16'h57] <= 16'hf8c4;
				memory[16'h58] <= 16'hfc1c;
				memory[16'h59] <= 16'hf0c5;
				memory[16'h5a] <= 16'hfc1c;
				memory[16'h5b] <= 16'hf4c5;
				memory[16'h5c] <= 16'hfc1c;
				memory[16'h5d] <= 16'hf8c5;
				memory[16'h5e] <= 16'hfc1c;
				memory[16'h5f] <= 16'hf0c6;
				memory[16'h60] <= 16'hfc1c;
				memory[16'h61] <= 16'hf4c6;
				memory[16'h62] <= 16'hfc1c;
				memory[16'h63] <= 16'hf8c6;
				memory[16'h64] <= 16'hfc1c;
				memory[16'h65] <= 16'hf0c7;
				memory[16'h66] <= 16'hfc1c;
				memory[16'h67] <= 16'hf4c7;
				memory[16'h68] <= 16'hfc1c;
				memory[16'h69] <= 16'hf8c7;
				memory[16'h6a] <= 16'hfc1c;
				memory[16'h6b] <= 16'h7801;
				memory[16'h6c] <= 16'hf01c;
				memory[16'h6d] <= 16'h7902;
				memory[16'h6e] <= 16'hf41c;
				memory[16'h6f] <= 16'h8901;
				memory[16'h70] <= 16'h8802;
				memory[16'h71] <= 16'h7801;
				memory[16'h72] <= 16'hf01c;
				memory[16'h73] <= 16'h7902;
				memory[16'h74] <= 16'hf41c;
				memory[16'h75] <= 16'h9076;
				memory[16'h76] <= 16'hf01c;
				memory[16'h77] <= 16'h9079;
				memory[16'h78] <= 16'hf01d;
				memory[16'h79] <= 16'hf41c;
				memory[16'h7a] <= 16'hb01;
				memory[16'h7b] <= 16'h907d;
				memory[16'h7c] <= 16'hf01d;
				memory[16'h7d] <= 16'hf01c;
				memory[16'h7e] <= 16'h601;
				memory[16'h7f] <= 16'hf01d;
				memory[16'h80] <= 16'hf41c;
				memory[16'h81] <= 16'h1601;
				memory[16'h82] <= 16'h9084;
				memory[16'h83] <= 16'hf01d;
				memory[16'h84] <= 16'hf01c;
				memory[16'h85] <= 16'h1b01;
				memory[16'h86] <= 16'hf01d;
				memory[16'h87] <= 16'hf41c;
				memory[16'h88] <= 16'h2001;
				memory[16'h89] <= 16'h908b;
				memory[16'h8a] <= 16'hf01d;
				memory[16'h8b] <= 16'hf01c;
				memory[16'h8c] <= 16'h2401;
				memory[16'h8d] <= 16'hf01d;
				memory[16'h8e] <= 16'hf41c;
				memory[16'h8f] <= 16'h2801;
				memory[16'h90] <= 16'h9092;
				memory[16'h91] <= 16'hf01d;
				memory[16'h92] <= 16'hf01c;
				memory[16'h93] <= 16'h3001;
				memory[16'h94] <= 16'hf01d;
				memory[16'h95] <= 16'hf41c;
				memory[16'h96] <= 16'h3401;
				memory[16'h97] <= 16'h9099;
				memory[16'h98] <= 16'hf01d;
				memory[16'h99] <= 16'hf01c;
				memory[16'h9a] <= 16'h3801;
				memory[16'h9b] <= 16'h909d;
				memory[16'h9c] <= 16'hf01d;
				memory[16'h9d] <= 16'hf41c;
				memory[16'h9e] <= 16'ha0af;
				memory[16'h9f] <= 16'hf01c;
				memory[16'ha0] <= 16'ha0ae;
				memory[16'ha1] <= 16'hf01d;
				memory[16'ha2] <= 16'hf41c;
				memory[16'ha3] <= 16'h6300;
				memory[16'ha4] <= 16'h5f03;
				memory[16'ha5] <= 16'h6000;
				memory[16'ha6] <= 16'h4005;
				memory[16'ha7] <= 16'ha0b2;
				memory[16'ha8] <= 16'hf01c;
				memory[16'ha9] <= 16'h90b1;
				memory[16'haa] <= 16'h4900;
				memory[16'hab] <= 16'hf41a;
				memory[16'hac] <= 16'hf01c;
				memory[16'had] <= 16'hf01d;
				memory[16'hae] <= 16'h4a01;
				memory[16'haf] <= 16'hf819;
				memory[16'hb0] <= 16'hf01d;
				memory[16'hb1] <= 16'ha0aa;
				memory[16'hb2] <= 16'h41ff;
				memory[16'hb3] <= 16'h2404;
				memory[16'hb4] <= 16'h6000;
				memory[16'hb5] <= 16'h5001;
				memory[16'hb6] <= 16'hf819;
				memory[16'hb7] <= 16'hf01d;
				memory[16'hb8] <= 16'h8e00;
				memory[16'hb9] <= 16'h8c01;
				memory[16'hba] <= 16'h4f02;
				memory[16'hbb] <= 16'h40fe;
				memory[16'hbc] <= 16'ha0b2;
				memory[16'hbd] <= 16'h7dff;
				memory[16'hbe] <= 16'h8cff;
				memory[16'hbf] <= 16'h44ff;
				memory[16'hc0] <= 16'ha0b2;
				memory[16'hc1] <= 16'h7dff;
				memory[16'hc2] <= 16'h7efe;
				memory[16'hc3] <= 16'hf100;
				memory[16'hc4] <= 16'h4ffe;
				memory[16'hc5] <= 16'hf819;
				memory[16'hc6] <= 16'hf01d;
				instReady<=2;
				memReadReady<=2;
				memWriteReady<=2;
				inst_cnt=1;
				memRead_cnt=1;
				memWrite_cnt=1;

				instData00<=0;
				instData01<=0;
				instData10<=0;
				instData11<=0;
				memData00<=0;
				memData01<=0;
				memData10<=0;
				memData11<=0;

				address1_00 <=0;
				address2_00 <=0;
			end
		else
			begin
				if(readM1) begin
				instReady<=0;
				address1_00[15:2] <= address1[15:2];
				end
				else instReady<=2;
				if(instReady==0) begin
					if(inst_cnt<4) inst_cnt<=inst_cnt+1;
					else begin
					instData00 <= memory[address1_00];
					instData01 <= memory[address1_00+1];
					instData10 <= memory[address1_00+2];
					instData11 <= memory[address1_00+3];
					instReady<=1;
					inst_cnt<=1;
					end
				end

				if(readM2) begin
				memReadReady<=0;
				address2_00[15:2] <= address2[15:2];
				end
				else memReadReady<=2;
				if(memReadReady==0)begin
					if(memRead_cnt<4) memRead_cnt<=memRead_cnt+1;
					else begin
					memData00 <= memory[address2_00];
					memData01 <= memory[address2_00+1];
					memData10 <= memory[address2_00+2];
					memData11 <= memory[address2_00+3];
					memReadReady<=1;
					memRead_cnt<=1;
					end
				end

				if(writeM2) memWriteReady<=0;
				else memWriteReady<=2;
				if(memWriteReady==0) begin
					if(memWrite_cnt<4) memWrite_cnt <=memWrite_cnt+1;
					else begin
					if(evict1) begin
						memory[evicted1_address] <= evicted1_00;
						memory[evicted1_address+1] <= evicted1_01;
						memory[evicted1_address+2] <= evicted1_10;
						memory[evicted1_address+3] <= evicted1_11;
					end
					if(evict2) begin
						memory[evicted2_address] <= evicted2_00;
						memory[evicted2_address+1] <= evicted2_01;
						memory[evicted2_address+2] <= evicted2_10;
						memory[evicted2_address+3] <= evicted2_11;						
					end
					memWriteReady<=1;
					memWrite_cnt<=1;
					end
				end															  
			end
endmodule
