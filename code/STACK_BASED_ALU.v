module STACK_BASED_ALU #(parameter n = 32) (input signed [n-1:0] input_data,input clk,input rst,input [2:0] opcode,output reg signed [n-1:0] output_data,output reg overflow,output reg [4:0] sp);

    reg signed [n-1:0] stack [0:31];
    reg signed [2*n-1:0] real_res;
    reg signed  [2*n-1:0] se_out;
    reg signed  [2*n-1:0]  se_stacko;
    reg signed  [2*n-1:0]  se_stackt;
    integer i;

    always @(posedge clk or posedge rst) 
    begin
        if (rst) 
        begin
            sp = 0;
            output_data = 0;
            overflow = 0;
        end 
        else 
        begin
            case (opcode)
                3'b100: 
                begin // Addition
                    if (sp >= 2) 
                    begin
                        output_data = stack[sp-1] + stack[sp-2];
                        se_out={ {n{output_data[n-1]}}, output_data };
                        se_stacko={ {n{stack[sp-1][n-1]}}, stack[sp-1] };
                        se_stackt={ {n{stack[sp-2][n-1]}}, stack[sp-2] };
                        real_res = se_stacko + se_stackt ;

                        if(real_res==se_out)
                        begin
                            overflow=0;
                        end 
                        else
                        begin
                            overflow=1;
                        end 
                    end 
                    else 
                    begin
                        overflow <= 0;
                    end
                end
                3'b101: 
                begin // Multiply
                    if (sp >= 2) 
                    begin
                        output_data = stack[sp-1] * stack[sp-2];
                        se_out={ {n{output_data[n-1]}}, output_data };
                        se_stacko={ {n{stack[sp-1][n-1]}}, stack[sp-1] };
                        se_stackt={ {n{stack[sp-2][n-1]}}, stack[sp-2] };
                        real_res = se_stacko * se_stackt ;
                        if(real_res==se_out)
                        begin
                            overflow=0;
                        end 
                        else
                        begin
                            overflow=1;
                        end 
                    end 
                    else 
                    begin
                        overflow <= 0;
                    end
                end
                3'b110: begin // PUSH
                    if (sp < 32) 
                    begin
                        stack[sp] <= input_data;
                        sp <= sp + 1;
                    end
                end
                3'b111: begin // POP
                    if (sp > 0) 
                    begin
                        output_data <= stack[sp-1]; 
                        stack[sp-1] = {n{0}};
                        sp <= sp - 1;
                    end
                end
                default: 
                begin 
                    output_data <= output_data;
                    overflow <= overflow;
                end
            endcase
        end
    end
endmodule
