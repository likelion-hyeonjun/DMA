`include "opcodes.v"

module control (Instruction, Reset_N, Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, FuncCode, isStall,isFlush,isFlushID,isHalted,Branch,cacheHit1,cacheHit2,writeToData);
	
    input [`WORD_SIZE-1:0] Instruction;
    input Reset_N;
    input isStall;
    input [1:0]isFlush;
	output [3:0] Opcode;
    output RegDst;
    output Jump;
    output Branch;
    output MemRead;
    output MemtoReg;
    output MemWrite;
    output ALUSrc;
    output RegWrite;
    output [5:0] FuncCode;
    input [1:0] isFlushID;
    output reg isHalted;
    output reg Branch;
    
    input cacheHit1;
    input cacheHit2;
    input writeToData;
	
    wire [3:0] Opcode;
    reg RegDst;
    reg Jump;
    reg MemRead;
    reg MemtoReg;
    reg MemWrite; 
    reg ALUSrc;
    reg RegWrite;
    wire [5:0] FuncCode;



    
    assign Opcode = Instruction[15:12];
    assign FuncCode = Instruction[5:0];

    always @(*) begin

        RegDst=0;
        Jump=0;
        Branch=0;
        MemRead=0;
        MemtoReg=0;
        MemWrite=0;
        ALUSrc=0;
        RegWrite=0;
        isHalted=0;


        if(Reset_N && !isFlushID && cacheHit1!=0 && cacheHit2!=0&&writeToData==0) begin

            if(Opcode == `ALU_OP) begin
                if(FuncCode==`INST_FUNC_HLT) isHalted=1;
                if((FuncCode != `INST_FUNC_WWD) &&(FuncCode != `INST_FUNC_HLT) && (FuncCode != `INST_FUNC_JPR)) begin
                RegDst = 1;
                if(isStall==0) RegWrite = 1;
                end
            end
            if((Opcode == `ADI_OP)||(Opcode == `ORI_OP)||(Opcode == `LHI_OP)) begin
                ALUSrc = 1;
                if(isStall==0) RegWrite = 1;
            end
            if(Opcode ==`LWD_OP) begin
                MemRead = 1;
                ALUSrc = 1;
                if(isStall==0) RegWrite = 1;
                MemtoReg = 1;
            end
            if(Opcode ==`SWD_OP) begin
                if(isStall==0) MemWrite = 1;
                ALUSrc = 1;
            end
            if((Opcode == `BNE_OP)||(Opcode == `BEQ_OP)||(Opcode == `BGZ_OP)||(Opcode == `BLZ_OP)) begin
                Branch = 1;
            end
            if(Opcode == `JMP_OP) begin
                Jump = 1;
            end
            if(Opcode == `JAL_OP) begin
                Jump = 1;
                if(isStall==0) RegWrite = 1;
            end
        end

    end    
    
    
endmodule