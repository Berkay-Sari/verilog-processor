`timescale 1ns / 1ps
module tb_islemci();

reg saat = 0;
reg reset;
reg [31:0] buyruk;
wire [31:0] ps;
wire [31:0] yazmac_on;

initial begin
    
    reset = 0;
    buyruk = 32'b0000000_00111_00110_000_00010_0010011; //6 e 7 ekle -> 2 ye yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_000_10000_0010011; // 2 ye 5 ekle -> 16 ya yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00001_00010_000_01010_0110011;     //add r1, r2, ->r10
    #10;
    
    reset = 0;
    buyruk = 32'b0100000_00001_00010_000_00110_0110011;     //sub r2, r1, -> r6
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_100_00111_0110011;     //xor r5, r1, -> r7
    #10; 
    
    reset = 0;
    buyruk = 32'b0110100_00011_01011_100_01010_0010011;     //xori r11, imm, -> r10
    #10; 
    
    //reset = 0;
    //buyruk = 32'b0100000_00100_00010_000_00110_1100011;     //beq r4, r2, -> ps
    //#10; 
    
    //reset = 0;
    //buyruk = 32'b0100000_00100_00010_101_00110_1100011;     //bge r2, r1, -> ps
    //#10;  
    
    reset = 0;
    buyruk = 32'b0000000_00001_00110_101_00111_0110011;     //srl r6, r1, -> r7
    #10; 
    
    reset = 0;
    buyruk = 32'b0000000_00100_10111_111_00000_0110011;     //and
    #10;
    
    
    //reset = 0;
    //buyruk = 32'b0000000_rs2_rs1_100_11110_1100011;     //blt
    //#10;
      
    reset = 0;
    buyruk = 32'b0000000_00000_00010_010_00011_0010011;     //slti
    #10;  
    
    /*
    reset = 0;
    buyruk = 32'b0000000_00000_00010_010_00011_00100111;     //jalr
    #10; 
    */
    //reset = 0;
    //buyruk = 32'bimm20|10:1|11|19:12_rd_1101111;     //jal
    //#10; 
    
    reset = 0;
    buyruk = 32'b0100000_00111_11111_101_01001_0010011;     //srai
    #10;
    
    reset = 0;
    buyruk = 32'b0100000_00011_00111_101_01000_0110011;     //sra
    #10;
    
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_000_11001_0010011; // 2 ye 5 ekle -> 16 ya yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_000_11010_0010011; // 2 ye 5 ekle -> 16 ya yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_11010_11001_000_11000_1100011;     //beq   -> 25-26. register
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_11100_00000_000_11111_1101111;     //jal   -> (14x2)31. registara kaydet
    #10;
   
   
    reset = 0;
    buyruk = 32'b0000001_00000_11101_000_11110_1100111;     //jalr   -> rs1:29 (imm:32) rd: 30. registara kaydet
    #10;
    
    reset = 0;
    buyruk = 32'b0000001_00000_11110_000_11101_1100111;     //jalr  
    #10;
    
    reset = 0;
    buyruk = 32'b0000001_11101_00000_100_11110_1100011;     //blt imm: 11111 x2 62  
    #10;
    
    reset = 0;
    buyruk = 32'b0000001_00000_11101_100_11110_1100011;     //blt  
    #10;
 
    reset = 1;
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_000_11001_0010011; // 2 ye 5 ekle -> 16 ya yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_00101_00010_000_11010_0010011; // 2 ye 5 ekle -> 16 ya yaz
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_11010_11001_000_11000_1100011;     //beq   -> 25-26. register
    #10;
    
    reset = 0;
    buyruk = 32'b0000000_11100_00000_000_11111_1101111;     //jal   -> (14x2)31. registara kaydet
    #10;
   
   
    reset = 0;
    buyruk = 32'b0000001_00000_11101_000_11110_1100111;     //jalr   -> rs1:29 (imm:32) rd: 30. registara kaydet
    #10;
    
    reset  = 1;
end

always begin
    #5;
    saat = ~saat;
    
end
islemci uut(.saat(saat),.reset(reset),.buyruk(buyruk),.ps(ps),.yazmac_on(yazmac_on));


endmodule