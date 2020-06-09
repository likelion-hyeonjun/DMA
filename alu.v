`include "opcodes.v"

module alu (Opcode, read1, ALUinput, FuncCode, Bcond, ALUresult, Reset_N);
	input [`WORD_SIZE-1:0] read1;
	input [`WORD_SIZE-1:0] ALUinput;
	input [5:0] FuncCode;
    input [3:0] Opcode;
    input Reset_N;

	output [`WORD_SIZE-1:0] ALUresult;
    output Bcond;


	reg [`WORD_SIZE-1:0] ALUresult;
    reg Bcond;
    reg [`WORD_SIZE-1:0] zeroextended;

    
	always @(*) begin

        if(!Reset_N) begin
            ALUresult = 0;
            Bcond = 0;
            zeroextended=0;

        end
      
        Bcond = 0;
        case(Opcode)
            `ALU_OP:
            begin
                case (FuncCode)
                    `FUNC_ADD: ALUresult = read1+ALUinput;
                    `FUNC_SUB: ALUresult = read1-ALUinput;                      	
                    `FUNC_NOT: ALUresult = ~read1; //NOT
                    `FUNC_AND: ALUresult = (read1&ALUinput); //and
                    `FUNC_ORR: ALUresult = read1|ALUinput; //or		 
                    `FUNC_SHL: ALUresult = read1<<1; //logical left shift		 
                    `FUNC_SHR: ALUresult = $signed(read1)>>>1; //arithmetic right
                    `FUNC_TCP: ALUresult = ~read1+1; //two's complement
                    default: ALUresult=-1;
                endcase
            end
            `ADI_OP: begin
                ALUresult = read1+ALUinput;
            end
            `ORI_OP: begin
                zeroextended[7:0] = ALUinput[7:0];
                ALUresult = read1|zeroextended;
            end
            `LHI_OP: ALUresult = ALUinput<<8;
            `LWD_OP: ALUresult = read1+ALUinput;		  
            `SWD_OP: ALUresult = read1+ALUinput;		
            `BNE_OP: Bcond = (read1 != ALUinput)? 1 : 0;
            `BEQ_OP: Bcond = (read1 == ALUinput)? 1 : 0;
            `BGZ_OP: Bcond = ($signed(read1) > 0)? 1: 0;
            `BLZ_OP: Bcond = ($signed(read1) < 0)? 1: 0;
        endcase
    
    
    end



endmodule

