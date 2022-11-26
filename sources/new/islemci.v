`timescale 1ns / 1ps
//Berkay-Sari 191101035
module islemci(
    input saat, reset, [31:0] buyruk,
    output reg [31:0] ps, signed [31:0] yazmac_on
    );
    
    reg [31:0] ps_next;
    reg [31:0] R [31:0], R_next [31:0]; //x0-x31
    assign yazmac_on = R[10];

    //inst. decode
    wire [6:0] opcode = buyruk[6:0]; // 7-bit (specifies reg type)
    wire [4:0] rd = buyruk[11:7];    // 5-bit (destination reg)
    wire [2:0] func3 = buyruk[14:12];// 3-bit (specifies operation w/func7)
    wire [4:0] rs1 = buyruk[19:15];  // 5-bit (1st operand ~first source reg)
    wire [4:0] rs2 = buyruk[24:20];  // 5-bit (2nd operand ~second source reg)
    wire [6:0] func7 = buyruk[31:25];// 7-bit (specifies operation w/func3)
    //                                +________
    //                                 32-bit (instruction)
    
    //--------------------opcode--------------------
    localparam [6:0] R_TYPE = 7'b0110011, //add,sub,xor,and,srl,sra
                     I_TYPE = 7'b0010011, //addi,xori,srai,slti
                     B_TYPE = 7'b1100011, //beq,bge,blt
                     JAL    = 7'b1101111, //jal
                     JALR   = 7'b1100111; //jalr
    //------------------func7_func3-----------------
    localparam [9:0] ADD    = 9'b0000000_000,
                     SUB    = 9'b0100000_000,
                     XOR    = 9'b0000000_100,
                     AND    = 9'b0000000_111,
                     SRL    = 9'b0000000_101,
                     SRA    = 9'b0100000_101;
    //--------------------func3---------------------                
    localparam [2:0] ADDI   = 3'b000,
                     XORI   = 3'b100,
                     SLTI   = 3'b010,
                     SRAI   = 3'b101,
                     BEQ    = 3'b000,
                     BLT    = 3'b100,
                     BGE    = 3'b101;
    //-----------------------------------------------
    integer i;
    initial begin
        for(i=0; i < 32; i=i+1) begin
            R[i] = 32'b0;
            R_next[i] = 32'b0;
        end
        ps = 32'b0;
        ps_next = 32'b0;    
    end
    
    always@* begin
        ps_next = ps;
        for(i=0; i<32; i=i+1)
            R_next[i] = R[i];
        case(opcode)
            R_TYPE : begin
                if({func7, func3} == ADD)
                    R_next[rd] = R[rs1] + R[rs2];
                if({func7, func3} == SUB)
                    R_next[rd] = R[rs1] - R[rs2];
                if({func7, func3} == XOR)
                    R_next[rd] = R[rs1] ^ R[rs2];
                if({func7, func3} == AND)
                    R_next[rd] = R[rs1] & R[rs2];   
                if({func7, func3} == SRL)
                    R_next[rd] = R[rs1] >> R[rs2][4:0]; //logical   
                if({func7, func3} == SRA)
                    R_next[rd] = $signed(R[rs1]) >>> R[rs2][4:0]; //arithmetic    
                ps_next = ps + 4;            
            end
        
            I_TYPE: begin
                if (func3 == ADDI)  
                    R_next[rd] = R[rs1] + { {21{buyruk[31]}}, buyruk[30:20] }; // sign-extension on I-imm 
                if (func3 == XORI) 
                    R_next[rd] = R[rs1] ^ { {21{buyruk[31]}}, buyruk[30:20] }; // sign-extension on I-imm 
                if (func3 == SLTI) 
                    R_next[rd] = $signed(R[rs1]) < $signed({ {22{buyruk[31]}}, buyruk[30:20] }) ? 32'b1 : 32'b0;
                if (func3 == SRAI && buyruk[31:25] == 7'b0100000) 
                    R_next[rd] = $signed(R[rs1]) >>> buyruk[24:20];     
                ps_next = ps + 4; 
            end
            
            B_TYPE: begin
                ps_next = ps + 4; 
                if(func3 == BEQ) begin
                    if(R[rs1] == R[rs2]) 
                        ps_next = ps + $signed({ {20{buyruk[31]}}, buyruk[7], buyruk[30:25], buyruk[11:8], 1'b0 }); // sign-extension on B-imm
                end
                if(func3 == BLT) begin
                    if($signed(R[rs1]) < $signed(R[rs2])) 
                        ps_next = ps + $signed({ {20{buyruk[31]}}, buyruk[7], buyruk[30:25], buyruk[11:8], 1'b0 }); // sign-extension on B-imm
                end
                if(func3 == BGE) begin
                    if($signed(R[rs1]) >= $signed(R[rs2])) 
                        ps_next = ps + $signed({ {20{buyruk[31]}}, buyruk[7], buyruk[30:25], buyruk[11:8], 1'b0 }); // sign-extension on B-imm
                end
            end
            
            JAL: begin
                R_next[rd] = ps + 4;
                ps_next = ps + $signed({ {12{buyruk[31]}}, buyruk[19:12], buyruk[20], buyruk[30:21], 1'b0 }); // sign-extension on J-imm
            end
            
            JALR: begin
                //Since JALR opcode unique, no need to check if func3 is equal to 3'b0 or not.
                R_next[rd] = ps + 4;
                ps_next = $signed(R[rs1]) + $signed({ {21{buyruk[31]}}, buyruk[30:20] }); // sign-extension on I-imm
                ps_next[0] = 1'b0;
            end
        endcase        
                
        if(reset) begin
            for(i=0; i < 32; i=i+1)
                R_next[i] = 32'b0;
            ps_next = 32'b0;   
        end
        R_next[0] = 0; //x0 is hardwired to the constant 0
    end
    
    always@(posedge saat) begin
        for(i=0; i<32; i=i+1)
            R[i] <= R_next[i];   
        ps <= ps_next;
    end
endmodule
