// instruction_memory.v
module instruction_memory(
    input wire [31:0] address,      //PC
    output reg [31:0] instruction   //instruction
);
 
    reg [31:0] memory [0:1023]; // 4KB instruction memory (1024 word)
 
    always @(*) begin
        instruction = memory[address[31:2]]; // word-addressed
    end
 
    initial begin
        integer i;
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'hFFFFFFFF;
 			
		//inst format 	6'opcode | 4'Rd | 4'Rs | 4'Rt | 14'Imm
		
		
        // Sample program  1
		// Read & Write in same cycle ----- Forwording 
    	memory[0]  = {6'b000101, 4'd1, 4'd0, 4'd0, 14'd5};    // ADDI R1, R0, 5	    
    	memory[1]  = {6'b000101, 4'd2, 4'd0, 4'd0, 14'd10};   // ADDI R2, R0, 10
    	memory[2]  = {6'b000001, 4'd3, 4'd1, 4'd2, 14'd0};    // ADD R3, R1, R2	 
    	memory[3]  = {6'b000010, 4'd4, 4'd2, 4'd1, 14'd0};    // SUB R4, R2, R1
    	memory[4]  = {6'b000000, 4'd5, 4'd1, 4'd2, 14'd0};    // OR R5, R1, R2
    	memory[5]  = {6'b000100, 4'd6, 4'd1, 4'd0, 14'd3};    // ORI R6, R1, 3
   		memory[6]  = {6'b000011, 4'd7, 4'd1, 4'd2, 14'd0};    // CMP R7, R1, R2
    	memory[7]  = {6'b000011, 4'd8, 4'd2, 4'd2, 14'd0};    // CMP R8, R2, R2
    	memory[8]  = {6'b000011, 4'd9, 4'd2, 4'd1, 14'd0};    // CMP R9, R2, R1	
		
		
		
		// Example program with memory load/store and ALU ops
		// Sample program  2  
		// LWD & SWD AND Rd is odd 
	    /*memory[0]  = {6'b000101, 4'd1, 4'd0, 4'd0, 14'd8};     // ADDI R1, R0, 8      ; R1 = 8
	    memory[1]  = {6'b000101, 4'd2, 4'd0, 4'd0, 14'd20};    // ADDI R2, R0, 20     ; R2 = 20	  
		memory[2]  = {6'b001001, 4'd8, 4'd1, 4'd0, 14'd4};     // SDW R8, 4(R1)       ; MEM[R1 + 4] = R8    MEM[5+R1] = R9
	    memory[3]  = {6'b001001, 4'd6, 4'd0, 4'd0, 14'd0};     // SDW R6, 0(R0)       ; MEM[0] = R6			MEM[1+R0] = R7
	    memory[4]  = {6'b001000, 4'd3, 4'd0, 4'd0, 14'd0};     // LDW R3, 0(R0)       ;	Exception
	    memory[5]  = {6'b001000, 4'd4, 4'd1, 4'd0, 14'd4};     // LDW R4, 4(R1)       ; R4 = MEM[8+4]   R5 = MEM[R1+5]
	    memory[6]  = {6'b000001, 4'd5, 4'd2, 4'd3, 14'd0};     // ADD R5, R2, R3      ; R5 = R2 + R3
	    memory[7]  = {6'b000010, 4'd6, 4'd5, 4'd4, 14'd0};     // SUB R6, R5, R4      ; R6 = R5 - R4
	    memory[8]  = {6'b000000, 4'd7, 4'd3, 4'd4, 14'd0};     // OR R7, R3, R4       ; R7 = R3 | R4
	    memory[9]  = {6'b000011, 4'd8, 4'd3, 4'd4, 14'd0};     // CMP R8, R3, R4      ; R8 = R3 & R4
		*/
		
		// Example program with memory load/store and ALU ops and jump 
		// Sample program  3  
		// LWD , SWD, Jump , Branch (precict false (true predict)) , Forwording  
		/*memory[0] = {6'd14, 4'd0, 4'd0, 4'd0, 14'd3};      // J + 3                 <- unconditional jump	
		memory[1]  = {6'd5,  4'd1, 4'd0, 4'd0, 14'd20};     // ADDI R1, R0, 20
	    memory[2]  = {6'd5,  4'd2, 4'd0, 4'd0, 14'd40};     // ADDI R2, R0, 40
		memory[3]  = {6'd7,  4'd4, 4'd1, 4'd0, 14'd4};     // SW R4, [R1 + 4]     <- normal store
	    memory[4]  = {6'd6,  4'd3, 4'd1, 4'd0, 14'd4};      // LD R3, [R1 + 4]      <- load
	    memory[5]  = {6'd0,  4'd4, 4'd3, 4'd2, 14'd0};      // OR R4, R3, R2        <- causes stall (uses result of load)
		memory[6]  = {6'd10, 4'd0, 4'd6, 4'd0, 14'd3};      // BZ R6, 3          <- if R6 == 0, skip next 3
	    memory[7]  = {6'd8,  4'd6, 4'd1, 4'd0, 14'd4};      // LWD R6, [R1 + 4]     <- double load
	    memory[8]  = {6'd2,  4'd8, 4'd6, 4'd2, 14'd0};      // SUB R8, R6, R2       <- causes stall (uses double load)
	    memory[9]  = {6'd9,  4'd6, 4'd1, 4'd0, 14'd8};      // SWD R6, [R1 + 8]     <- double store
	    memory[10]  = {6'd7,  4'd4, 4'd1, 4'd0, 14'd12};     // SW R4, [R1 + 12]     <- normal store
	    memory[11]  = {6'd5,  4'd7, 4'd0, 4'd0, 14'd100};    // ADDI R7, R0, 100     <- skipped if branch taken
	    memory[12] = {6'd4,  4'd8, 4'd0, 4'd0, 14'd200};    // ORI R8, R0, 200     <- skipped by jump
	    memory[13] = {6'd5,  4'd9, 4'd8, 4'd0, 14'd255};    // ADDI R9, R8, 255     <- executed	 
		
		*/



			
		//memory[1] = {6'b000110, 4'd3, 4'd3, 4'd0, 14'd4};  // LW R3, 4(R3)
		//memory[2] = {6'b000101, 4'd4, 4'd3, 4'd0, 14'd20}; // ADDI R3, R3, 20 
		//memory[0] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd4};  // SW R6, 4(R3) 
		//memory[1] = {6'b000111, 4'd9, 4'd3, 4'd0, 14'd5};  // SW R6, 5(R3) 
		
		//memory[0] = {6'b001001, 4'd5, 4'd3, 4'd0, 14'd4}; // SDW R5, 4(R3)
		//memory[1] = {6'b001000, 4'd2, 4'd3, 4'd0, 14'd4}; // LDW R2, 4(R3)
		//memory[2] = {6'b000101, 4'd8, 4'd3, 4'd0, 14'd20}; // ADDI R8, R3, 20 
		//memory[3] = {6'b000101, 4'd7, 4'd2, 4'd0, 14'd20}; // ADDI R7, R2, 20
		
		
		//memory[0] = {6'b001001, 4'd4, 4'd3, 4'd0, 14'd4}; // SDW R4, 4(R3)  
		//memory[0] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd4};  // SW R6, 4(R3) 
		//memory[1] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd5};  // SW R6, 5(R3)
		
		//memory[1] = {6'b001000, 4'd2, 4'd3, 4'd0, 14'd4}; // LDW R2, 4(R3)
		//memory[2] = {6'b001001, 4'd2, 4'd3, 4'd0, 14'd4}; // SDW R2, 4(R3)
		//memory[3] = {6'b001000, 4'd2, 4'd3, 4'd0, 14'd4}; // LDW R2, 4(R3)
		
		//memory[2] = {6'b000101, 4'd8, 4'd3, 4'd0, 14'd20}; // ADDI R8, R3, 20 
		//memory[3] = {6'b000101, 4'd7, 4'd2, 4'd0, 14'd20}; // ADDI R7, R2, 20	
		
		
		//memory[0] = {6'b001001, 4'd8, 4'd8, 4'd0, 14'd4}; // SDW R8, 4(R8)  true  
		//memory[1] = {6'b000111, 4'd1, 4'd9, 4'd0, 14'd8}; // SW R1, 9(R9)	true
		//memory[2] = {6'b001000, 4'd4, 4'd4, 4'd0, 14'd8}; // LDW R4, 8(R4)	true   
		
		
		
		//memory[2] = {6'b000001, 4'd9, 4'd3, 4'd2, 14'd0};  // ADD R9, R3, R2 
		//memory[3] = {6'b001000, 4'd2, 4'd8, 4'd0, 14'd4}; // LDW R2, 4(R8)	true
		//memory[0] = {6'b000111, 4'd7, 4'd4, 4'd0, 14'd5}; // SDW R6, 4(R3)  true  
		//memory[1] = {6'b000111, 4'd8, 4'd4, 4'd0, 14'd6}; // LDW R6, 4(R3)  true  
		//memory[2] = {6'b000110, 4'd2, 4'd4, 4'd0, 14'd5}; // SDW R6, 4(R3)  true  
		//memory[3] = {6'b000110, 4'd3, 4'd5, 4'd0, 14'd6}; // SDW R6, 4(R3)  true  
		//memory[4] = {6'b001000, 4'd6, 4'd4, 4'd0, 14'd5}; // LDW R2, 4(R3)	true 
		//memory[3] = {6'b000001, 4'd9, 4'd3, 4'd2, 14'd0};  // ADD R9, R3, R2 
		//memory[2] = {6'b000001, 4'd9, 4'd3, 4'd2, 14'd0};  // ADD R9, R3, R2
		
		//memory[2] = {6'b001001, 4'd8, 4'd8, 4'd0, 14'd4};  // SDW R8, 4(R8)  

		 
		//memory[3] = {6'b000101, 4'd7, 4'd2, 4'd0, 14'd20}; // ADDI R7, R2, 20	
		//memory[5] = {6'b001000, 4'd8, 4'd8, 4'd0, 14'd4}; // LDW R8, 4(R8)
		
		//memory[6] = {6'b000101, 4'd8, 4'd3, 4'd0, 14'd20}; // ADDI R8, R3, 20 
		//memory[5] = {6'b000101, 4'd7, 4'd2, 4'd0, 14'd20}; // ADDI R7, R2,20
		
		// lwD R8 , 4 (R8) case 
		// lw Rd (R8) = [R8 + 4]  
		// lw Rd(R9) = [R8+1+4]	 /stall 
		// lw Rd (R9) = [R8++1]
		
		
		//memory[0] = {6'b000011, 4'd5, 4'd1, 4'd2, 14'd0};  // CMP R7, R1, R2
		//memory[1] = {6'b001100, 4'd0, 4'd5, 4'd0, 14'd32};  // JMP to instruction at address 2
		//memory[0] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd4};  // SW R6, 4(R3) 
		//memory[1] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd5};  // SW R6, 5(R3)
		//memory[1] = {6'b000110, 4'd8, 4'd3, 4'd0, 14'd4};  // LW R8, 4(R3)
		//memory[2] = {6'b000110, 4'd7, 4'd3, 4'd0, 14'd5};  // LW R8, 4(R3)
		//memory[3] = {6'b001001, 4'd6, 4'd3, 4'd0, 14'd5};  // SWD R6, 5(R3)
		//memory[1] = {6'b001000, 4'd2, 4'd3, 4'd0, 14'd4}; // LDW R2, 4(R3)
		//memory[1] = {6'b001111, 4'd0, 4'd1, 4'd1, 14'd16};  // CLL to address 16
		//memory[1] = {6'b001110, 4'd0, 4'd12, 4'd0, 14'd0};  // JMP to instruction at address 2
		//memory[1] = {6'b000110, 4'd3, 4'd3, 4'd0, 14'd4};  // LW R3, 4(R3)
		//memory[2] = {6'b000101, 4'd3, 4'd3, 4'd0, 14'd20}; // ADDI R3, R3, 20 
		//memory[3] = {6'b000010, 4'd4, 4'd3, 4'd1, 14'd0};  // SUB R4, R3, R1 
	 	//memory[4] = {6'b000001, 4'd9, 4'd3, 4'd2, 14'd0};  // ADD R9, R3, R2
        //memory[5] = {6'b000101, 4'd9, 4'd3, 4'd0, 14'd20}; // ADDI R9, R3, 20
        //memory[3] = {6'b000001, 4'd9, 4'd1, 4'd2, 14'd0};  // ADD R9, R1, R2
        //memory[4] = {6'b000010, 4'd4, 4'd2, 4'd1, 14'd0};  // SUB R4, R2, R1
		//memory[5] = {6'b000110, 4'd8, 4'd3, 4'd0, 14'd4};  // LW R8, 4(R3)
        //memory[5] = {6'b000001, 4'd5, 4'd1, 4'd2, 14'd0};  // AND R5, R1, R2
        //memory[6] = {6'b000000, 4'd6, 4'd1, 4'd2, 14'd0};  // OR  R6, R1, R2
        //memory[7] = {6'b000011, 4'd7, 4'd1, 4'd2, 14'd0};  // CMP R7, R1, R2 
 
		//memory[8] = {6'b000010, 4'd4, 4'd8, 4'd1, 14'd0};  // SUB R4, R8, R1
		//memory[9] = {6'b001100, 4'd0, 4'd4, 4'd0, 14'h3FFC};  // BLZ R4, -4 (in two's complement)
		//memory[9] = {6'b000111, 4'd6, 4'd3, 4'd0, 14'd4};  // SW R6, 4(R3)
		//memory[10] = {6'b000110, 4'd8, 4'd3, 4'd0, 14'd4};  // LW R8, 4(R3)
		//memory[12] = {6'b001110, 4'd0, 4'd9, 4'd0, 14'd2};  // JMP to instruction at address 2 
	
 
    end
 
endmodule
 
 
// instruction_memory_tb.v
module instruction_memory_tb;
 
    reg [31:0] address;
    wire [31:0] instruction;
 
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );
 
     initial begin
        $display("Time\tAddress\t\tInstruction");
        $monitor("%0t\t%h\t%h", $time, address, instruction);
 
        address = 32'd0;
        repeat (6) begin
            #10;
            address = address + 4;
        end
 
        #10 $finish;
    end
 
endmodule
 
 