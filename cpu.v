`timescale 1ns/1ns
`include "opcodes.v"
`include "control.v"
`include "datapath.v"


//`define WORD_SIZE 16    // data and address word size

module cpu(Clk, Reset_N, readC1, address1, cacheData1, readC2, writeC2, address2, cacheData2, num_inst, output_port, is_halted, cacheHit1,cacheHit2, writeCacheData,writeToData);
	input Clk;
	wire Clk;
	input Reset_N;
	wire Reset_N;

	output readC1;
	wire readC1;
	output [`WORD_SIZE-1:0] address1;
	wire [`WORD_SIZE-1:0] address1;
	output readC2;
	wire readC2;
	output writeC2;
	wire writeC2;
	output [`WORD_SIZE-1:0] address2;
	wire [`WORD_SIZE-1:0] address2;

	input [`WORD_SIZE-1:0] cacheData1;
	wire [`WORD_SIZE-1:0] cacheData1;
	input [`WORD_SIZE-1:0] cacheData2;
	wire [`WORD_SIZE-1:0] cacheData2;
	output wire [15:0] writeCacheData;

	output [`WORD_SIZE-1:0] num_inst;
	wire [`WORD_SIZE-1:0] num_inst;
	output [`WORD_SIZE-1:0] output_port;
	wire [`WORD_SIZE-1:0] output_port;
	output is_halted;
	wire is_halted;
	// TODO : Implement your pipelined CPU!

	//added
	input cacheHit1;
	input cacheHit2;
	input writeToData;

	reg [15:0] Instruction;
	reg [15:0] realData;
	wire [15:0] num_inst_reg;
	wire [15:0] PC_PRED;
	reg [15:0] PC;
	reg [15:0] PC_EX;
	reg [15:0] PC_ID;
	reg [15:0] PC_PRED_EX;
	reg [15:0] PC_PRED_ID;
	wire [3:0]Opcode;
	wire RegDst;
	wire Jump;
	wire Branch;
	wire MemRead;
	wire MemtoReg;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	wire [15:0] forwardBMEM;
	wire [5:0]FuncCode;
	wire isStall;
	wire [1:0] isFlush;
	wire [15:0]PC_NEXT;
	wire MemReadMEM;
	wire MemWriteMEM;
	wire [15:0] ALUresultMEM;
	wire [15:0] forwardA;
	wire is_halted_reg;
	wire [15:0]output_port_reg;
	reg [15:0] address1_reg;
	wire [1:0] isFlushID;
	wire isHalted;
	wire BranchEX;
	wire BcondEX;
	wire JumpEX;
	

	
	PCPred pcpred(PC,PC_PRED,Reset_N,PC_EX,PC_NEXT,BcondEX,JumpEX,BranchEX,Clk);
	datapath datapathA (Instruction, Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Reset_N,PC,PC_EX,Clk,forwardBMEM,realData,FuncCode,
	isStall,isFlush,PC_NEXT,MemReadMEM,MemWriteMEM,ALUresultMEM,output_port_reg,PC_PRED_EX,num_inst_reg,isFlushID,is_halted_reg,isHalted,BranchEX,BcondEX,JumpEX,cacheHit1,cacheHit2,writeToData);
	control controlA (Instruction, Reset_N, Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, FuncCode, isStall,isFlush,isFlushID,isHalted,Branch,cacheHit1,cacheHit2,writeToData);


	assign num_inst = num_inst_reg;
	assign readC1 = (!isStall&&cacheHit1!=0&&cacheHit2!=0&&writeToData==0);
	assign readC2 = (MemReadMEM);
	assign writeC2 = (MemWriteMEM);
	assign address2 = ALUresultMEM;
	assign writeCacheData = MemWriteMEM? forwardBMEM:0;
	assign address1 = address1_reg;
	assign is_halted = is_halted_reg;
	assign output_port = output_port_reg;

	

	always @(posedge Clk) begin
		if(Reset_N==0) begin
			Instruction <=0;
			realData <=0;
			PC<=0;
			PC_EX<=0;
			PC_PRED_EX<=0;
			address1_reg<=0;
		end
		else begin
	
			if(isStall==0 && cacheHit1!=0&&cacheHit2!=0&&writeToData==0) begin		
				Instruction <= cacheData1;
				if(isFlush!=1) begin
					address1_reg <= PC_PRED;
					PC <= PC_PRED;
				end
				else begin
					address1_reg<=PC_NEXT;
					PC <= PC_NEXT;
				end
				PC_ID<=PC;
				PC_EX<=PC_ID;
				PC_PRED_ID<=PC_PRED;
				PC_PRED_EX<=PC_PRED_ID;
			end
			if(MemReadMEM==1&&cacheHit1!=0&&cacheHit2!=0&&writeToData==0) realData <= cacheData2;

			
		end
	end

endmodule

module PCPred(PC,out,Reset_N,UpdatePC,UpdatePred,Bcond,Jump,Branch,clk);
	input [15:0] PC;
	input Reset_N;
	input [15:0] UpdatePC;
	input [15:0] UpdatePred;
	input Bcond;
	input Jump;
	input Branch;
	input clk;
	output reg [15:0] out;

	reg [2:0] State;
	reg [15:0] PCentry[0:7];
	reg [15:0] Predentry[0:7];
	reg valid[0:7];
	integer i;


	always @(*) begin
		if(!Reset_N) begin
			out = 0;
			for(i=0;i<8;i=i+1) begin
				PCentry[i] = 0;
				Predentry[i] = 0;
				valid[i]=0;
			end
			State=3;

		end
		else begin
		if(PCentry[PC[2:0]]==PC && valid[PC[2:0]] && (State==2 || State==3)) out = Predentry[PC[2:0]];
		else out = PC+1;
		end
	end

	always @(posedge clk) begin
		if(Jump||Branch) begin
			if(Branch) begin
			case (State)//2bit hysteresis Counter
				0: begin
					if(Bcond) State = 1;
					else State= 0; 
				end
				1: begin
					if(Bcond) State= 3;
					else State = 0; 	
				end
				2: begin
					if(Bcond) State = 3;
					else State = 0; 
				end
				3: begin
					if(Bcond) State = 3;
					else State = 2; 
				end				
			endcase
			end
			PCentry[UpdatePC[2:0]] = UpdatePC;
			Predentry[UpdatePC[2:0]] = UpdatePred;
			valid[UpdatePC[2:0]] = 1;
		end	
	end

endmodule


