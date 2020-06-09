module cache (Clk,Reset_N,readC1,readC2,writeC2, address1, address2, writeCacheData,
instData00, instData01, instData10, instData11, memData00, memData01, memData10, memData11, instReady, memReadReady, memWriteReady,
cacheHit1, cacheHit2, cacheData1, cacheData2, readM1, readM2, writeM2, writeToData,
evicted1_00, evicted1_01, evicted1_10, evicted1_11, evicted2_00, evicted2_01, evicted2_10, evicted2_11,evict1,evict2,evicted1_address,evicted2_address,
NumHit, NumMiss);

//from cpu
input Clk;
input Reset_N;
input readC1;
input readC2;
input writeC2;
input [15:0] address1;
input [15:0] address2;
input [15:0] writeCacheData;


//from Memory
input [15:0] instData00;
input [15:0] instData01;
input [15:0] instData10;
input [15:0] instData11;

input [15:0] memData00;
input [15:0] memData01;
input [15:0] memData10;
input [15:0] memData11;

input [1:0] instReady;
input [1:0] memReadReady;
input [1:0] memWriteReady;

//to cpu
output reg cacheHit1;
output reg cacheHit2;
output reg [15:0] cacheData1;
output reg [15:0] cacheData2;
output reg writeToData;

//added 
output reg [15:0] NumHit;
output reg [15:0] NumMiss;

//to Memory
output reg readM1;
output reg readM2;
output reg writeM2;
output reg[15:0] evicted1_00;
output reg[15:0] evicted1_01;
output reg[15:0] evicted1_10;
output reg[15:0] evicted1_11;
output reg[15:0] evicted2_00;
output reg[15:0] evicted2_01;
output reg[15:0] evicted2_10;
output reg[15:0] evicted2_11;
output reg evict1;
output reg evict2;
output reg [15:0] evicted1_address;
output reg [15:0] evicted2_address;


reg [15:0] Iway0_data[0:1][0:3];
reg [15:0] Iway1_data[0:1][0:3];
reg [15:0] Dway0_data[0:1][0:3];
reg [15:0] Dway1_data[0:1][0:3];
reg [12:0] Iway0_tag[0:1];
reg [12:0] Iway1_tag[0:1];
reg [12:0] Dway0_tag[0:1];
reg [12:0] Dway1_tag[0:1];
reg Iway0_valid[0:1];
reg Iway1_valid[0:1];
reg Iway0_dirty[0:1];
reg Iway1_dirty[0:1];
reg ILRU[0:1];
reg Dway0_valid[0:1];
reg Dway1_valid[0:1];
reg Dway0_dirty[0:1];
reg Dway1_dirty[0:1];
reg DLRU[0:1];
reg evict1_way;//evict block
reg evict2_way;//evict block


integer i,j;

always @(posedge Clk) begin
    if(!Reset_N) begin
        for(i=0;i<2;i=i+1) begin
            for(j=0;j<4;j=j+1)begin
                Iway0_data[i][j] = 0;
                Iway1_data[i][j] = 0;
                
                Dway0_data[i][j] = 0;
                Dway1_data[i][j] = 0;
            end
            Iway0_tag[i] = 0;
            Iway1_tag[i] = 0;
            Iway0_valid[i] = 0;
            Iway1_valid[i] = 0;
            Iway0_dirty[i]=0;
            Iway1_dirty[i]=0;
            ILRU[i] = 0;

            Dway0_tag[i] = 0;
            Dway1_tag[i] = 0;
            Dway0_valid[i] = 0;
            Dway1_valid[i] = 0;
            Dway0_dirty[i]=0;
            Dway1_dirty[i]=0;
            DLRU[i] = 0;
        end
        cacheData1<=0;
        cacheData2<=0;
        evicted1_address<=0;
        evicted2_address<=0;
        cacheHit1<=1;
        cacheHit2<=1;
        readM1<=0;
        readM2<=0;
        writeM2<=0;
        evicted1_00<=0;
        evicted1_01<=0;
        evicted1_10<=0;
        evicted1_11<=0;
        evicted2_00<=0;
        evicted2_01<=0;
        evicted2_10<=0;
        evicted2_11<=0;
        evict1<=0;
        evict2<=0;
        writeToData<=0;
        evict1_way<=0;
        evict2_way<=0;
       

        NumHit <=0;
        NumMiss <=0;



    end
    else begin
        if(readC1) begin
            if(Iway0_tag[address1[2]] == address1[15:3] && Iway0_valid[address1[2]]) begin
                cacheHit1 <=1;
                NumHit <= NumHit +1;
                cacheData1 <= Iway0_data[address1[2]][address1[1:0]];
                ILRU[address1[2]] <= 1;
                evict1<=0;
            end
            else if(Iway1_tag[address1[2]] == address1[15:3] && Iway1_valid[address1[2]])begin
                cacheHit1 <=1;
                NumHit <= NumHit +1;
                cacheData1 <= Iway1_data[address1[2]][address1[1:0]];
                ILRU[address1[2]] <= 0;
                evict1<=0;

            end
            else begin //cache miss
                cacheHit1<=0;
                NumMiss <= NumMiss +1;

                if(ILRU[address1[2]]==0 && Iway0_dirty[address1[2]]&& Iway0_valid[address1[2]]) begin //have to write to memory
                   evicted1_00 = Iway0_data[address1[2]][0];
                   evicted1_01 = Iway0_data[address1[2]][1];
                   evicted1_10 = Iway0_data[address1[2]][2];
                   evicted1_11 = Iway0_data[address1[2]][3];
                   evict1<=1;
                   writeM2<=1;
                   evicted1_address[15:3] = Iway0_tag[address1[2]];
                   writeToData<=1; 
                   evict1_way<=0;
                   ILRU[address1[2]] <= 1;                  
                end
                else if(ILRU[address1[2]]==1 && Iway1_dirty[address1[2]]&& Iway1_valid[address1[2]]) begin //have to write to memory
                   evicted1_00 = Iway1_data[address1[2]][0];
                   evicted1_01 = Iway1_data[address1[2]][1];
                   evicted1_10 = Iway1_data[address1[2]][2];
                   evicted1_11 = Iway1_data[address1[2]][3];
                   writeM2<=1;
                   evict1<=1;
                   evicted1_address[15:3] = Iway1_tag[address1[2]];
                   writeToData<=1;
                   evict1_way<=1;
                   ILRU[address1[2]] <=0;                   
                end
                else evict1<=0;

                readM1<=1;
            end
        
        end

        if(readC2) begin
            if(Dway0_tag[address2[2]] == address2[15:3] && Dway0_valid[address2[2]]) begin
                cacheHit2 <= 1;
                NumHit <= NumHit +1;
                cacheData2 <= Dway0_data[address2[2]][address2[1:0]];
                DLRU[address2[2]] <= 1;
                evict2<=0;
            end
            else if(Dway1_tag[address2[2]] == address2[15:3] && Dway1_valid[address2[2]])begin
                cacheHit2 <=1;
                NumHit <= NumHit +1;
                cacheData2 <= Dway1_data[address2[2]][address2[1:0]];
                DLRU[address2[2]] <= 0;
                evict2<=0;
            end
            else begin // cache miss
                cacheHit2<=0;
                NumMiss <= NumMiss+1;
                if(DLRU[address2[2]]==0 && Dway0_dirty[address2[2]] && Dway0_valid[address2[2]]) begin //have to write to memory
                   evicted2_00 = Dway0_data[address2[2]][0];
                   evicted2_01 = Dway0_data[address2[2]][1];
                   evicted2_10 = Dway0_data[address2[2]][2];
                   evicted2_11 = Dway0_data[address2[2]][3];
                   writeM2<=1;
                   evict2<=1;
                   evicted2_address[15:3] = Dway0_tag[address2[2]];
                   writeToData<=1;
                   evict2_way<=0;
                   DLRU[address2[2]] <=1;                   
                
                end
                else if(DLRU[address2[2]]==1 && Dway1_dirty[address2[2]] && Dway1_valid[address2[2]]) begin //have to write to memory
                   evicted2_00 = Dway1_data[address2[2]][0];
                   evicted2_01 = Dway1_data[address2[2]][1];
                   evicted2_10 = Dway1_data[address2[2]][2];
                   evicted2_11 = Dway1_data[address2[2]][3];
                   writeM2<=1;
                   evict2<=1;
                   evicted2_address[15:3] = Dway1_tag[address2[2]];
                   writeToData<=1;
                   evict2_way<=0;
                   DLRU[address2[2]] <=0;                       
                end
                else evict2<=0;
                readM2 <= 1;
            end    
        end

        else if (writeC2) begin
            if(Dway0_tag[address2[2]] == address2[15:3] && Dway0_valid[address2[2]]) begin
                cacheHit2 <= 1;
                NumHit <= NumHit+1;
                Dway0_data[address2[2]][address2[1:0]] <= writeCacheData;
                DLRU[address2[2]] <= 1;
                Dway0_dirty[address2[2]]<=1;
                evict2<=0;
            end
            else if(Dway1_tag[address2[2]] == address2[15:3] && Dway1_valid[address2[2]])begin
                cacheHit2 <=1;
                NumHit <= NumHit +1;
                Dway1_data[address2[2]][address2[1:0]] <= writeCacheData;
                DLRU[address2[2]] <= 0;
                Dway1_dirty[address2[2]]<=1;
                evict2<=0;
            end
            else begin
                cacheHit2<=0;
                NumMiss <= NumMiss +1;
                if(DLRU[address2[2]]==0 && Dway0_dirty[address2[2]] && Dway0_valid[address2[2]]) begin //have to write to memory
                   evicted2_00 = Dway0_data[address2[2]][0];
                   evicted2_01 = Dway0_data[address2[2]][1];
                   evicted2_10 = Dway0_data[address2[2]][2];
                   evicted2_11 = Dway0_data[address2[2]][3];
                   evicted2_address[15:3] = Dway0_tag[address2[2]];                   
                   writeM2<=1;
                   evict2<=1;
                   writeToData<=1;
                   evict2_way<=0;
                   DLRU[address2[2]]<=1;                   
                end
                else if(DLRU[address2[2]]==1 && Dway1_dirty[address2[2]] && Dway1_valid[address2[2]]) begin //have to write to memory
                   evicted2_00 = Dway1_data[address2[2]][0];
                   evicted2_01 = Dway1_data[address2[2]][1];
                   evicted2_10 = Dway1_data[address2[2]][2];
                   evicted2_11 = Dway1_data[address2[2]][3];
                   evicted2_address[15:3] = Dway1_tag[address2[2]];                   
                   writeM2<=1;
                   evict2<=1;
                   writeToData<=1;
                   evict2_way<=1;
                   DLRU[address2[2]]<=0;                   
                end
                else evict2<=0;

                readM2<=1;

            end

        end

        //Memory fetch

        if(instReady==1) begin

            if((evict1&&evict1_way==0)||(!evict1 && Iway0_valid[address1[2]]==0)) begin
                Iway0_data[address1[2]][0] <= instData00;
                Iway0_data[address1[2]][1] <= instData01;
                Iway0_data[address1[2]][2] <= instData10;
                Iway0_data[address1[2]][3] <= instData11;
                Iway0_tag[address1[2]] <= address1[15:3];
                Iway0_valid[address1[2]] <=1;
                Iway0_dirty[address1[2]] <=0;
            end
            else begin
                Iway1_data[address1[2]][0] <= instData00;
                Iway1_data[address1[2]][1] <= instData01;
                Iway1_data[address1[2]][2] <= instData10;
                Iway1_data[address1[2]][3] <= instData11;
                Iway1_tag[address1[2]] <= address1[15:3];
                Iway1_valid[address1[2]] <=1;
                Iway1_dirty[address1[2]] <=0;
            end

            case (address1[1:0])
                0:cacheData1<=instData00; 
                1:cacheData1<=instData01;
                2:cacheData1<=instData10;
                3:cacheData1<=instData11;
            endcase
            cacheHit1<=1;
            //NumHit <= NumHit+1;
            readM1<=0;


        end

        if(memReadReady==1) begin

            if((evict2&&evict2_way==0)||(!evict2 && Dway0_valid[address2[2]]==0)) begin
                Dway0_data[address2[2]][0] <= memData00;
                Dway0_data[address2[2]][1] <= memData01;
                Dway0_data[address2[2]][2] <= memData10;
                Dway0_data[address2[2]][3] <= memData11;
                Dway0_tag[address2[2]] <= address2[15:3];
                Dway0_valid[address2[2]] <=1;
                Dway0_dirty[address2[2]] <=0;
            end
            else begin
                Dway1_data[address2[2]][0] <= memData00;
                Dway1_data[address2[2]][1] <= memData01;
                Dway1_data[address2[2]][2] <= memData10;
                Dway1_data[address2[2]][3] <= memData11;
                Dway1_tag[address2[2]] <= address2[15:3];
                Dway1_valid[address2[2]] <=1;
                Dway1_dirty[address2[2]] <=0;
            end
            
            if(readC2) begin
                case (address2[1:0])
                    0:cacheData2<=memData00; 
                    1:cacheData2<=memData01;
                    2:cacheData2<=memData10;
                    3:cacheData2<=memData11;
                endcase
            end

            else if(writeC2) begin
                if((evict2&&evict2_way==0)||(!evict2 && Dway0_valid[address2[2]]==0)) begin
                    Dway0_data[address2[2]][address2[1:0]] <= writeCacheData;
                    Dway0_dirty[address2[2]] <= 1;
                end
                else begin
                    Dway1_data[address2[2]][address2[1:0]] <= writeCacheData;
                    Dway1_dirty[address2[2]] <= 1;
                end
            end
            
            cacheHit2<=1;
            //NumHit <= NumHit +1;
            readM2<=0;

        end

        if(memWriteReady==1) begin
            writeM2<=0;
            writeToData<=0;
        end


    end

end


endmodule
