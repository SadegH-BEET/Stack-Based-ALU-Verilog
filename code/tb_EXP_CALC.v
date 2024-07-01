module tb_EXP_CALC;

    reg [399:0] expression;
    reg clk, rst;
    wire signed [49:0] output_value;
    EXP_CALC calculator (expression,output_value,rst,clk);

    initial 
    begin
        rst = 0; #10;
        rst = 1; #10;  
        rst = 0; #10;   //reset the modules.
        
        expression = "(((7+3)*5)+8)*2";  
        $display("TB expression is: %s", expression);  

        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "2*3+(10+4+3)*-20+(6+5)";  
        $display("TB expression is: %s", expression);    

        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "1+2*3+8+9";  
        $display("TB expression is: %s", expression);   

        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "2*3+(10+4+3)*-20+((6+5)*(8+1)*(9+1))+2";  
        $display("TB expression is: %s", expression);   

        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        expression = "1+(-2+0)";  
        $display("TB expression is: %s", expression);   

        clk = 0; #1000;
        clk = 1; #1000;
        $display("output_value is: %0d", output_value);

        $stop;
    end
endmodule
