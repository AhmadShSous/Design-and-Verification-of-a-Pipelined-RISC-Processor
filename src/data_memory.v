// data_memory
module data_memory (
    input  clk,
    input  [31:0] address,
    input  [31:0] write_data,
    input  mem_write,
    input  mem_read,
    output reg [31:0] read_data
);
 
    reg [31:0] DataMem [0:1023];  // 4KB RAM
 	integer  i;
    // Read data (combinational)
    always @(*) begin
        if (mem_read) begin
            read_data = DataMem[address[31:0]];	 
			$monitor("Time=%0t | mem_read | Address=0x%h | Data=0x%h", $time, address, read_data) ; 
			$display("----------- Data Memory Snapshot -----------");
            for (i = 0; i < 16; i = i + 1) begin
                $display("DataMem[%0d] = 0x%h", i, DataMem[i]);
            end
            $display("--------------------------------------------"); 
			
		end	
        
    end
 
    // Write data (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            DataMem[address[31:0]] <= write_data; 
			$monitor("Time=%0t | MEMWRITE | Address=0x%h | Data=0x%h", $time, address, write_data) ; 
			$display("----------- Data Memory Snapshot -----------");
            for (i = 0; i < 16; i = i + 1) begin
                $display("DataMem[%0d] = 0x%h", i, DataMem[i]);
            end
            $display("--------------------------------------------");	
		end
    end
   
endmodule  
 
 
// data_memory_tb.v
module data_memory_tb;
 
    reg clk;
    reg [31:0] address, write_data;
    reg mem_write, mem_read;
    wire [31:0] read_data;
 
    data_memory uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );
 
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
 
    // Test sequence
    initial begin
        $monitor("Time=%0t | Addr=%h | WData=%h | MemW=%b | MemR=%b | RData=%h",
                  $time, address, write_data, mem_write, mem_read, read_data);
 
        // Write to address 8
        #10 address = 32'd8; write_data = 32'hCAFEBABE;
            mem_write = 1; mem_read = 0;
 
        // Stop write
        #10 mem_write = 0;
 
        // Read from address 8
        #10 mem_read = 1;
 
        // Read from address 10
        #10 address = 32'd40;  
        #10 $finish;
    end
 
endmodule 