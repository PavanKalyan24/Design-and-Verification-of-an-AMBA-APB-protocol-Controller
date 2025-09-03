module AMBA_APB(
    input clock,
    input reset,
    input [31:0] address,
    input select,
    input enable,
    input write_en,
    input [31:0] write_data,
    output reg ready,
    output reg slave_error,
    output reg [31:0] read_data
);
    
    // State encoding
    localparam [1:0] IDLE_ST  = 2'b00;
    localparam [1:0] SETUP_ST = 2'b01;
    localparam [1:0] ACCESS_ST = 2'b10;
    
    // Internal state registers
    reg [1:0] current_state, next_state;
    
    // Memory array (32 words of 32 bits each)
    reg [31:0] memory_block [0:31];
    
    // State transition logic
    always @(posedge clock) begin
        if (reset) begin
            current_state <= IDLE_ST;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state and output logic
    always @(*) begin
        // Default outputs
        ready = 1'b0;
        slave_error = 1'b0;
        read_data = 32'b0;
        next_state = current_state;
        
        case (current_state)
            IDLE_ST: begin
                if (select && !enable) begin
                    next_state = SETUP_ST;
                end
            end
            
            SETUP_ST: begin
                if (!select || !enable) begin
                    next_state = IDLE_ST;
                end else begin
                    next_state = ACCESS_ST;
                    
                    // Perform read or write operation
                    if (write_en) begin
                        memory_block[address] <= write_data;
                        ready = 1'b1;
                    end else begin
                        read_data = memory_block[address];
                        ready = 1'b1;
                    end
                end
            end
            
            ACCESS_ST: begin
                if (!select || !enable) begin
                    next_state = IDLE_ST;
                end
            end
        endcase
    end
    
endmodule
