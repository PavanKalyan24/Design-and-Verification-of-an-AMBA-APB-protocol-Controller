module APB_Testbench;
    // Inputs
    reg clock;
    reg reset;
    reg [31:0] addr;
    reg sel;
    reg en;
    reg wr;
    reg [31:0] data_in;
    
    // Outputs
    wire ready;
    wire slv_err;
    wire [31:0] data_out;
    
    // Instantiate the design
    AMBA_APB apb_dut (
        .clock(clock),
        .reset(reset),
        .address(addr),
        .select(sel),
        .enable(en),
        .write_en(wr),
        .write_data(data_in),
        .ready(ready),
        .slave_error(slv_err),
        .read_data(data_out)
    );
    
    // Clock generation
    always #5 clock = ~clock;
    
    // Test sequences
    task initialize_test;
        begin
            clock = 0;
            reset = 0;
            addr = 0;
            sel = 0;
            en = 0;
            wr = 0;
            data_in = 0;
        end
    endtask
    
    task system_reset;
        begin
            reset = 1;
            #20 reset = 0;
        end
    endtask
    
    task perform_write;
        input [31:0] target_addr;
        input [31:0] value;
        begin
            @(posedge clock);
            sel = 1;
            wr = 1;
            data_in = value;
            addr = target_addr;
            
            @(posedge clock);
            en = 1;
            
            @(posedge clock);
            en = 0;
            sel = 0;
            
            $display("Write Operation: Address=%0d, Data=%0d", target_addr, value);
        end
    endtask
    
    task perform_read;
        input [31:0] target_addr;
        begin
            @(posedge clock);
            sel = 1;
            wr = 0;
            addr = target_addr;
            
            @(posedge clock);
            en = 1;
            
            @(posedge clock);
            en = 0;
            sel = 0;
            
            @(posedge clock);
            $display("Read Operation: Address=%0d, Data=%0d", target_addr, data_out);
        end
    endtask
    
    // Main test procedure
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, APB_Testbench);
        
        initialize_test;
        system_reset;
        
        // Write to multiple addresses
        perform_write(0, 32'hA5A5A5A5);
        perform_write(1, 32'h12345678);
        perform_write(2, 32'hDEADBEEF);
        
        // Read from the same addresses
        perform_read(0);
        perform_read(1);
        perform_read(2);
        
        // Additional write and read
        perform_write(3, 32'h5555AAAA);
        perform_read(3);
        
        #50 $finish;
    end
    
    // Monitor to track signals
    initial begin
        $monitor("Time=%0t: State=%b, Ready=%b, ReadData=%h", 
                 $time, apb_dut.current_state, ready, data_out);
    end
    
endmodule
