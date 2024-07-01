module EXP_CALC (
    input wire [399:0] expression,
    output reg [49:0] output_value,
    input wire rst,
    input wire clk
);

    reg [32*50+7:0] postfixExpression;
    reg [7:0] stackInput;
    wire [7:0] stackOutput;
    reg [2:0] stackOp;
    reg [2:0] calculatorOp;
    wire stackOf;
    wire [5-1:0] sp; 
    wire calculatorOf;
    wire [5-1:0] calculatorSp;
    parameter n = 8;
    reg isNeg;
    reg stackClk;
    reg calculatorClk;
    integer i;
    integer idx;
    integer j;
    reg signed [50-1:0] inputCalculator;
    wire [50-1:0] outputCalculator;
    reg [50-1:0] tmp;

    STACK_BASED_ALU #(n) stack (
        .input_data(stackInput[n-1:0]),
        .output_data(stackOutput[n-1:0]),
        .opcode(stackOp),
        .overflow(stackOf),
        .sp(sp),
        .clk(stackClk),
        .rst(rst)
    );

    STACK_BASED_ALU #(50) calculator (
        .input_data(inputCalculator[50-1:0]),
        .output_data(outputCalculator[50-1:0]),
        .opcode(calculatorOp),
        .overflow(calculatorOf),
        .sp(calculatorSp),
        .clk(calculatorClk),
        .rst(rst)
    );

    always @(posedge clk or posedge rst) 
    begin
        if (rst) 
        begin
            postfixExpression = {(8*50){0}};
            stackClk = 0;
            calculatorClk = 0;
        end
        else 
        begin
            postfixExpression = {(8*50){0}};
            stackClk = 0;
            calculatorClk = 0;
            idx = 1;
            for (i = 50; i > 0; i = i - 1) 
            begin
                if ((expression[8*i-1 -: 8] >= "0" && expression[8*i-1 -: 8] <= "9") || expression[8*i-1 -: 8] == "-") 
                begin
                    postfixExpression[8*idx-1 -: 8] = expression[8*i-1 -: 8];
                    idx = idx + 1;
                end
                else 
                begin
                    case (expression[8*i-1 -: 8]) 

                        "*": begin
                            postfixExpression[8*idx-1 -: 8] = "W";
                            idx = idx + 1; // Append W to postfix expression as a splitter between different numbers
                            for (j = 1 - (|sp) + 1; j < 1; j = j + 1) 
                            begin
                                stackOp = 3'b111; #1; stackClk = 1;  #1; stackClk = 0;
                                if (stackOutput[7:0] == "(" || stackOutput[7:0] == "+") 
                                begin
                                    stackOp = 3'b110; // opcode for pushing popped data
                                    stackInput[7:0] = stackOutput[7:0]; #1; stackClk = 1;  #1; stackClk = 0;
                                end 
                                else 
                                if (stackOutput[7:0] == "*") 
                                begin
                                    postfixExpression[8*idx-1 -: 8] = stackOutput[7:0];
                                    idx = idx + 1;
                                    j = 0 - (|sp);
                                end
                            end
                            stackOp = 3'b110; // opcode for pushing
                            stackInput[7:0] = "*"; #1; stackClk = 1; #1; stackClk = 0;
                        end

                        "(": begin
                            stackOp = 3'b110; // opcode for pushing
                            stackInput[7:0] = "("; #1; stackClk = 1; #1; stackClk = 0;
                        end

                        ")": begin
                            postfixExpression[8*idx-1 -: 8] = "W";
                            idx = idx + 1; // Append W to postfix expression as a splitter between different numbers
                            for (j = 0; j < 1; j = j + 1) 
                            begin
                                stackOp = 3'b111; #1; stackClk = 1; #1; stackClk = 0;
                                if (stackOutput[7:0] != "(") 
                                begin
                                    postfixExpression[8*idx-1 -: 8] = stackOutput[7:0];
                                    idx = idx + 1;
                                    j = j - 1;
                                end
                            end
                        end

                        "+": begin
                            postfixExpression[8*idx-1 -: 8] = "W";
                            idx = idx + 1; // Append W to postfix expression as a splitter between different numbers
                            for (j = 1 - (|sp); j < 1; j = j + 1) 
                            begin
                                stackOp = 3'b111; #1; stackClk = 1; #1; stackClk = 0;
                                if (stackOutput[7:0] == "(") 
                                begin
                                    stackOp = 3'b110; // opcode for pushing popped data
                                    stackInput[7:0] = stackOutput[7:0]; #1; stackClk = 1; #1; stackClk = 0;
                                end 
                                else if (stackOutput[7:0] == "*" || stackOutput[7:0] == "+") 
                                begin
                                    postfixExpression[8*idx-1 -: 8] = stackOutput[7:0];
                                    idx = idx + 1;
                                    j = 0 - (|sp);
                                end
                            end
                            stackOp = 3'b110; // opcode for pushing
                            stackInput[7:0] = "+"; #1; stackClk = 1; #1; stackClk = 0;
                        end

                        default: 
                        begin
                        end

                    endcase
                end
            end
            postfixExpression[8*idx-1 -: 8] = "W";
            idx = idx + 1;

            for (j = 1 - (|sp); j < 1; j = j + 1) 
            begin
                stackOp = 3'b111; // opcode for popping whatever is left on the stack
                #1;
                stackClk = 1;
                #1;
                stackClk = 0;
                postfixExpression[8*idx-1 -: 8] = stackOutput[7:0];
                idx = idx + 1;
                j = 0 - (|sp);
            end
            inputCalculator[50-1:0] = {50{0}};
            for (i = 1; i <= 4*50 + 1; i = i + 1) 
            begin
                if ((postfixExpression[8*i-1 -: 8] >= "0" && postfixExpression[8*i-1 -: 8] <= "9") || postfixExpression[8*i-1 -: 8] == "-") //start of converting
                begin 
                    isNeg = 0;  
                    isNeg=(postfixExpression[8*i-1 -: 8] == "-") ? 1 : 0;
                    i=(postfixExpression[8*i-1 -: 8] == "-") ? i + 1 : i;

                    for (j = 0; j < 1; j = j + 1) 
                    begin
                        inputCalculator[50-1:0] = inputCalculator[50-1:0] * 10 + (postfixExpression[8*i-1 -: 8] - "0");
                        i = i + 1;
                        if (postfixExpression[8*i-1 -: 8] == "W") 
                        begin
                            j=0;
                        end
                        else 
                        begin 
                            j=-1; 
                        end
                    end 
                    i = i - 1;

                    inputCalculator[50-1:0] =(isNeg == 1) ? -inputCalculator[50-1:0] : inputCalculator[50-1:0];
                    calculatorOp = 3'b110; #1; calculatorClk = 1; #1;calculatorClk = 0;inputCalculator[50-1:0] = {50{0}};
                end
                else if (postfixExpression[8*i-1 -: 8] != "W" && postfixExpression[8*i-1 -: 8] != 0) 
                begin
                    calculatorOp = (postfixExpression[8*i-1 -: 8] == "*") ? 3'b101 : 3'b100; // opcode for addition
                    #1; calculatorClk = 1; #1; calculatorClk = 0; 
                    tmp[50-1:0] = outputCalculator[50-1:0];

                    calculatorOp = 3'b111;  #1; calculatorClk = 1; #1; calculatorClk = 0; calculatorOp = 3'b111;  #1; calculatorClk = 1; #1; calculatorClk = 0; 

                    inputCalculator[50-1:0] = tmp[50-1:0]; calculatorOp = 3'b110; #1; calculatorClk = 1; #1; calculatorClk = 0;

                    inputCalculator[50-1:0] = {50{0}};
                end
            end
            calculatorOp = 3'b111; #1; calculatorClk = 1; #1; calculatorClk = 0;
            output_value[50-1:0] = outputCalculator[50-1:0];
        end
    end
endmodule

