module tb_ALU8;

    reg signed [7:0] input_data;
    wire signed [7:0] output_data;
    reg [2:0] opcode;
    wire overflow;
    reg clk, rst;
    parameter n = 8;
    wire [4:0] sp;

    STACK_BASED_ALU #(n) ALU (input_data[n-1:0],clk,rst,opcode,output_data[n-1:0],overflow,sp);
    
    initial 
    begin
        clk = 0;
    end

    always #5 clk = ~clk;

    initial 
    begin
        rst = 1; #10;
        rst = 0; #10;
        input_data = 32'd10; opcode = 3'b110; #10;
        // show stack pointer
        $display("SP = %d", sp);
        input_data = -32'd20; opcode = 3'b110; #10;
        // show stack pointer
        $display("SP = %d", sp);
        // testing add operation
        opcode = 3'b100; #10;
        $display("SUM: %d, Overflow: %b", output_data, overflow);
        input_data = 32'd30; opcode = 3'b110; #10;
        // show stack pointer
        $display("SP = %d", sp);
        // testing mul operation
        opcode = 3'b101; #10;
        $display("MUL: %d, Overflow: %b", output_data, overflow);
        // Pop
        opcode = 3'b111; #10;
        // Check result
        $display("%d, SP = %d", output_data, sp);
        $stop;
    end
endmodule

