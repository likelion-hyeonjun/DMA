`include "opcodes.v"
`include "alu.v"


module datapath(Instruction, Opcode, RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Reset_N,PC,PC_EX,clk,forwardBMEM,realData,FuncCode,
isStall,isFlush,PC_NEXT,MemReadMEM,MemWriteMEM,ALUresultMEM,output_port_reg,PC_PRED_EX,num_inst_reg,isFlushID,is_halted_reg,isHalted,BranchEX,BcondEX,JumpEX,cacheHit1,cacheHit2,writeToData);


input clk;
input [15:0] Instruction;
input [3:0] Opcode;
input RegDst;
input Jump;
input Branch;
input MemRead;
input MemtoReg;
input MemWrite;
input ALUSrc; //I format or R format
input RegWrite;
input Reset_N;
input [15:0] realData;
input [5:0] FuncCode;
input [15:0] PC;
input [15:0] PC_EX;
input [15:0] PC_PRED_EX;
output reg [1:0] isFlushID;
output reg [15:0] forwardBMEM;
output reg isStall;
output reg [1:0] isFlush;
output reg [15:0] PC_NEXT;
output MemReadMEM;
output MemWriteMEM;
output [15:0] ALUresultMEM;
output reg [15:0] output_port_reg;
output reg [15:0] num_inst_reg;
output reg is_halted_reg;
input isHalted;
output reg BranchEX;
output BcondEX;
output JumpEX;



//added
input cacheHit1;
input cacheHit2;
input writeToData;

wire [`WORD_SIZE-1:0] writedata;
wire [1:0] rs;
wire [1:0] rt;
wire [1:0] rd;
wire [7:0] imm;
wire [11:0] target;
wire [`WORD_SIZE-1:0] read1;
wire [`WORD_SIZE-1:0] read2;
wire [`WORD_SIZE-1:0] forwardA;
wire [`WORD_SIZE-1:0] forwardB;
wire [`WORD_SIZE-1:0] ALUresultEX;
wire [`WORD_SIZE-1:0] ALUinput2;
wire [15:0] realData;
wire [15:0] extended;
wire BcondEX;
wire isJRL;
wire isJPR;
wire isJAL;


reg [1:0] rsEX;
reg [1:0] rtEX;
reg [1:0] rdEX;
reg RegWriteEX;
reg RegDstEX;
reg MemReadEX;
reg MemWriteEX;
reg MemtoRegEX;
reg isJRLEX;
reg isJPREX;
reg isJALEX;
reg ALUSrcEX;
reg [7:0] immEX;
reg JumpEX;
reg [3:0] OpcodeEX;
reg [11:0]targetEX;
reg [5:0] FuncCodeEX;
reg [1:0] isFlushEX;
reg isHaltedEX;
reg [15:0] read1EX;
reg [15:0] read2EX;
reg wasStallEX;

reg [1:0] rsMEM;
reg [1:0] rtMEM;
reg [1:0] rdMEM;
reg RegWriteMEM;
reg RegDstMEM;
reg MemReadMEM;
reg MemWriteMEM;
reg MemtoRegMEM;
reg [15:0] ALUresultMEM;
reg isJRLMEM;
reg isJPRMEM;
reg isJALMEM;
reg [15:0] PC_MEM;
reg [1:0] isFlushMEM;
reg wasStallMEM;
reg isHaltedMEM;
reg wwdMEM;
reg [15:0]wwdDataMEM;

reg [1:0] rsWB;
reg [1:0] rtWB;
reg [1:0] rdWB;
reg RegWriteWB;
reg RegDstWB;
reg MemtoRegWB;
reg [15:0] ALUresultWB;
reg isJRLWB;
reg isJPRWB;
reg isJALWB;
reg [15:0] PC_WB;
reg [1:0] isFlushWB;

reg wwdWB;
reg wasStallWB;
reg isHaltedWB;
reg [15:0] wwdDataWB;


assign rs = Instruction[11:10];
assign rt = Instruction[9:8];
assign rd = (isJRL||isJAL)? 2: Instruction[7:6];
assign imm = Instruction[7:0];
assign extended = {{8{immEX[7]}},immEX[7:0]}; // sign extended imm (for branch)
assign target = Instruction[11:0];
assign writedata = MemtoRegWB? realData: ((isJRLWB||isJALWB)? PC_WB+1: ALUresultWB);
assign isJRL = ((Opcode==`JRL_OP)&&(FuncCode == `INST_FUNC_JRL))? 1:0;
assign isJPR = ((Opcode==`JPR_OP)&&(FuncCode == `INST_FUNC_JPR))? 1:0;
assign isJAL = (Opcode==`JAL_OP)? 1:0;
assign ALUinput2 = (ALUSrcEX==1)? extended: forwardB;

                       
Forwarding forwardunitA(rsEX, rdMEM, rdWB, read1EX, ALUresultMEM, writedata, RegWriteMEM, RegWriteWB, forwardA,isFlushMEM,isFlushWB,isJALMEM,isJRLMEM,PC_MEM);
Forwarding forwardunitB(rtEX, rdMEM, rdWB, read2EX, ALUresultMEM, writedata, RegWriteMEM, RegWriteWB, forwardB,isFlushMEM,isFlushWB,isJALMEM,isJRLMEM,PC_MEM);

register Register(rs,rt,rtWB,rdWB, writedata, RegWriteWB, read1, read2, Reset_N, RegDstWB,clk,isJPRWB,isJRLWB,isJALWB);
alu Alu(OpcodeEX, forwardA, ALUinput2, FuncCodeEX, BcondEX, ALUresultEX, Reset_N);

always @(posedge clk) begin 
    if(!Reset_N) begin
        read1EX<=0;
        read2EX<=0;

        num_inst_reg<=0;
        output_port_reg<=0;
        is_halted_reg<=0;

        isFlushID<=2;

        rsEX<=0;
        rtEX<=0;
        rdEX<=0;
        RegWriteEX<=0;
        RegDstEX<=0;
        MemReadEX<=0;
        MemWriteEX<=0;
        MemtoRegEX<=0;
        isJRLEX<=0;
        isJPREX<=0;
        isJALEX<=0;
        ALUSrcEX<=0;
        immEX<=0;
        targetEX<=0;
        FuncCodeEX<=0;
        JumpEX<=0;
        OpcodeEX<=0;
        isFlushEX<=2;
        isHaltedEX<=0;
        wasStallEX<=0;

        BranchEX<=0;

        wwdMEM<=0;
        rsMEM<=0;
        rtMEM<=0;
        rdMEM<=0;
        RegWriteMEM<=0;
        RegDstMEM<=0;
        MemReadMEM<=0;
        MemWriteMEM<=0;
        MemtoRegMEM<=0;
        ALUresultMEM<=0;
        isJRLMEM<=0;
        isJPRMEM<=0;
        isJALMEM<=0;
        PC_MEM<=0;
        forwardBMEM<=0;
        isFlushMEM<=2;
        wasStallMEM<=0;
        isHaltedMEM<=0;
        wwdDataMEM<=0;

        rsWB<=0;
        rtWB<=0;
        rdWB<=0;
        RegWriteWB<=0;
        RegDstWB<=0;
        MemtoRegWB<=0;
        ALUresultWB<=0;
        isJRLWB<=0;
        isJPRWB<=0;
        isJALWB<=0;
        PC_WB<=0;
        isFlushWB<=2;
        wwdWB<=0;
        wasStallWB<=0;
        isHaltedWB<=0;
        wwdDataWB<=0;

        PC_NEXT <=0;
    end
    else begin

    if(cacheHit1!=0&&cacheHit2!=0&&writeToData==0) begin

        if(isFlush) begin
        read1EX<=0;
        read2EX<=0;
        rsEX<=0;
        rtEX<=0;
        rdEX<=0;
        RegWriteEX<=0;
        RegDstEX<=0;
        MemReadEX<=0;
        MemWriteEX<=0;
        MemtoRegEX<=0;
        isJRLEX<=0;
        isJPREX<=0;
        isJALEX<=0;
        ALUSrcEX<=0;
        immEX<=0;
        targetEX<=0;
        FuncCodeEX<=0;
        JumpEX<=0;
        OpcodeEX<=0;
        isFlushEX<=1;
        isFlushID<=1;
        isHaltedEX<=0;
        BranchEX<=0;
        end

        else begin
        read1EX<=read1;
        read2EX<=read2;
        rsEX<=rs;
        rtEX<=rt;
        if(RegDst==1) rdEX<=rd;
        else if (isJAL||isJRL) rdEX<=2;
        else rdEX<=rt;
        if(isStall) wasStallEX<=1;
        else wasStallEX<=0;
        RegWriteEX<=RegWrite;
        RegDstEX<=RegDst;
        MemReadEX<=MemRead;
        MemWriteEX<=MemWrite;
        MemtoRegEX<=MemtoReg;
        isJRLEX<=isJRL;
        isJPREX<=isJPR;
        isJALEX<=isJAL;
        ALUSrcEX<=ALUSrc;
        immEX<=imm;
        targetEX<=target;
        FuncCodeEX<=FuncCode;
        OpcodeEX<=Opcode;
        JumpEX<=Jump;
        isFlushEX<=isFlushID;
        isFlushID<=isFlush;
        isHaltedEX<=isHalted;
        BranchEX<=Branch;
        end

        if(OpcodeEX == `ALU_OP && FuncCodeEX==`INST_FUNC_WWD)begin
            wwdMEM<=1;
            wwdDataMEM<=forwardA;
        end
        else wwdMEM<=0;

        rsMEM<=rsEX;
        rtMEM<=rtEX;
        rdMEM<=rdEX;
        RegWriteMEM<=RegWriteEX;
        RegDstMEM<=RegDstEX;
        MemReadMEM<=MemReadEX;
        MemWriteMEM<=MemWriteEX;
        MemtoRegMEM<=MemtoRegEX;
        ALUresultMEM<=ALUresultEX;
        isJRLMEM<=isJRLEX;
        isJPRMEM<=isJPREX;
        isJALMEM<=isJALEX;
        PC_MEM<=PC_EX;
        forwardBMEM<=forwardB;
        isFlushMEM<=isFlushEX;
        isHaltedMEM<=isHaltedEX;
        wasStallMEM<=wasStallEX;


        rsWB<=rsMEM;
        rtWB<=rtMEM;
        rdWB<=rdMEM;
        RegWriteWB<=RegWriteMEM;

        RegDstWB<=RegDstMEM;
        MemtoRegWB<=MemtoRegMEM;
        ALUresultWB<=ALUresultMEM;
        isJRLWB<=isJRLMEM;
        isJPRWB<=isJPRMEM;
        isJALWB<=isJALMEM;
        PC_WB<=PC_MEM;
        isFlushWB<=isFlushMEM;
        
        wwdWB<=wwdMEM;
        wasStallWB<=wasStallMEM;
        isHaltedWB<=isHaltedMEM;
        wwdDataWB<=wwdDataMEM;
  
        if(isFlushWB==0 && wasStallWB==0) begin
        num_inst_reg<=num_inst_reg+1;
        if(isHaltedWB) is_halted_reg<=1;
        if(wwdWB) output_port_reg<=wwdDataWB;
        end
    
    end

    end
    
end


always @(*) begin

    if(!Reset_N) begin
    PC_NEXT = 0;
    isFlush = 2;
    isStall = 0;
    end
    else begin
    if(JumpEX) begin
    PC_NEXT = targetEX;    
    end
    else if (BcondEX) begin
    PC_NEXT = PC_EX + (extended+1);
    end
    else if (isJRLEX||isJPREX) PC_NEXT = forwardA;
    else PC_NEXT = PC_EX+1;
    end
    if(PC_NEXT!=PC_PRED_EX && isFlushID!=2 && isFlushEX!=1) isFlush = 1;
    else isFlush = 0;

    if((wasStallMEM==0) && (isFlushEX==0))begin
        if((rs==rdEX)&&(MemReadEX==1)) isStall = 1;
        
        if(Opcode==`ALU_OP) begin
            if((FuncCode==`INST_FUNC_ADD)||(FuncCode==`INST_FUNC_SUB)||(FuncCode==`INST_FUNC_AND)||(FuncCode==`INST_FUNC_ORR))begin
                if((rt==rdEX)&&(MemReadEX==1)) isStall = 1;    
            end
        end
        else if((Opcode!=`BGZ_OP) && (Opcode!=`BLZ_OP) && (Opcode!=`JMP_OP) && (Opcode!=`JAL_OP)) begin
                if((rt==rdEX)&&(MemReadEX==1)) isStall = 1;  
        end
        else isStall = 0;
    end
    else isStall = 0;

end


endmodule

module Forwarding (rs, rdMEM, rdWB, read, ALUresultMEM, writedata,RegWriteMEM,RegWriteWB,out,isFlushMEM,isFlushWB,isJALMEM,isJRLMEM,PC_MEM);
    input [1:0] rs;
    input [1:0] rdMEM;
    input [1:0] rdWB;
    input [15:0] read;
    input [15:0] ALUresultMEM;
    input [15:0] writedata;
    input RegWriteMEM;
    input RegWriteWB;
    input [1:0]isFlushMEM;
    input [1:0]isFlushWB;
    input isJALMEM;
    input isJRLMEM;
    input [15:0] PC_MEM;
    output reg [15:0] out;

    always @(*) begin
        if((rs==rdMEM) && (RegWriteMEM==1) && (isFlushMEM==0))begin
           if(isJALMEM||isJRLMEM) out = PC_MEM+1;
           else out = ALUresultMEM;
        end
        else if((rs==rdWB) && (RegWriteWB==1) && (isFlushWB==0)) out = writedata;
        else out =read;
    end

endmodule






module MUX (in0, in1, in2, in3, sel, out);
    input [`WORD_SIZE-1:0] in0;
    input [`WORD_SIZE-1:0] in1;
    input [`WORD_SIZE-1:0] in2;
    input [`WORD_SIZE-1:0] in3;
    input [1:0] sel;
    output reg [`WORD_SIZE-1:0] out;

    always @(*) begin
        case (sel)
            0: out = in0;
            1: out = in1;
            2: out = in2;
            3: out = in3;
        endcase
    end

endmodule


module register(rs,rt,rtWB,rdWB, writedata, RegWrite, read1, read2, Reset_N, RegDst,clk, isJPR,isJRL,isJAL);
    input clk;
    input [1:0] rs;
    input [1:0] rt;
    input [1:0] rdWB;
    input [1:0] rtWB;
    input [`WORD_SIZE-1:0]writedata;
    input Reset_N;
    input RegWrite;
    input RegDst;
    input isJPR;
    input isJRL;
    input isJAL;


    output [`WORD_SIZE-1:0] read1;
    output [`WORD_SIZE-1:0] read2;

    reg [`WORD_SIZE-1:0] innerReg0;
    reg [`WORD_SIZE-1:0] innerReg1;
    reg [`WORD_SIZE-1:0] innerReg2;
    reg [`WORD_SIZE-1:0] innerReg3;
    wire [`WORD_SIZE-1:0] read1;
    wire [`WORD_SIZE-1:0] read2;



    always @(negedge clk) begin

        if(!Reset_N) begin
            innerReg0 <= 0;
            innerReg1 <= 0;
            innerReg2 <= 0;
            innerReg3 <= 0;
        end

        if((RegWrite==1) && (RegDst==1)) begin
            if(isJRL==1) innerReg2 <= writedata;
            else begin
            case (rdWB)
                0: innerReg0 <= writedata;
                1: innerReg1 <= writedata;
                2: innerReg2 <= writedata;
                3: innerReg3 <= writedata; 
            endcase
            end
        end
        if((RegWrite==1) && (RegDst==0)) begin
            if(isJAL==1) innerReg2 <= writedata;
            else begin
            case (rtWB)
                0: innerReg0 <= writedata;
                1: innerReg1 <= writedata;
                2: innerReg2 <= writedata;
                3: innerReg3 <= writedata; 
            endcase
            end
        end
    end


    MUX muxRS (innerReg0, innerReg1, innerReg2, innerReg3, rs, read1);
    MUX muxRT (innerReg0, innerReg1, innerReg2, innerReg3, rt, read2);


    

endmodule