# Stack-Based-ALU-Verilog
![SBALU](https://github.com/SadegH-BEET/Stack-Based-ALU-Verilog/blob/main/STALU.png)  

In this project i desigend a **STACK BASED ALU** and a **calculator** for infix math expressions  
this ALU support push,pop,add,multiply instruction with **n** bit inputs and outputs  
you can see the ports of this ALU in table below:  
| port | function | 
| -------- | -------- | 
| clk   | clk!   | 
| rst  | input signal to reset ALU   |
| input_data | data for push to stack with length n |
| opcode | showing operation |
| output_data | data of different operations |  
# Tools  
in this project i used   
* Modelsim for simulating
* VsCode writing verilog code
# Implementation Details  
My design consists of two modules:  
* STACK_BASED_ALU
* EXP_CALC

in first module i designed a STACK_BASE_ALU that supports the following 6 commands:

| opcode | instruction | 
| -------- | -------- | 
| 100   | add instruction   | 
| 101   | mul instruction   |
| 110   | PUSH instruction |
| 110   | POP instruction |
| 0xx   | NO operation |    

note: mul and add instruction don't change the values in stack, they get two first element in stack as operand and after performing the operation, it drops the result in the output_data    
``` verilog
module STACK_BASED_ALU #(parameter n = 32)
      (input signed [n-1:0] input_data,
       input clk,
       input rst,
       input [2:0] opcode,
       output reg signed [n-1:0] output_data,
       output reg overflow,
       output reg [4:0] sp);

```

in second module i used this [algorithm](https://www.geeksforgeeks.org/evaluation-of-postfix-expression/) that use stack to convert infix order math exp. to posfix order math exp. , after this step we can calculate the value of posfix math exp. with this [algorithm](https://www.geeksforgeeks.org/evaluation-of-postfix-expression/)  
When we convert an expression to posfix, the advantage is that we no longer need to pay attention to the priority of algebraic operations, and in fact, this order is included in the conversion to posfix.  
so in this module i get two instance from first module with arbitary clk signal for each one to control them, one is used for converting posfix to infix and other for calculating the posfix math exp.  
``` verilog
module EXP_CALC (
    input wire [399:0] expression,
    output reg [49:0] output_value,
    input wire rst,
    input wire clk
);
```



# How to run  
To use this program, you can use different software such as QEMU or ModelSim or iverilog in mac
for running the Testbench with iverilog in mac you can use this command:   
```
cd code
iverilog -o test tb_EXP_CALC.v EXP_CALC.v STACK_BASED_ALU.v
vvp test
```
for simulating in ModelSim do the following:  
* make new project
* add verilog files to project
* compile files
* simulate
# Results  
for testing my design i tested 5 math expressions   

 $$((7+3)*5)+8)*2$$  
 
 $$ 2 * 3 + (10 + 4 + 3) * -20 + (6 + 5) $$  
 
 $$1+2*3+8+9$$  
 
 $$2 * 3 + (10 + 4 + 3) * -20 + ( ( 6 + 5 ) * ( 8 + 1 ) * ( 9 + 1 ) ) +2 $$  
 
 $$1+(-2+0)$$    
 
and the results are as follows:  

 ![result](https://github.com/SadegH-BEET/Stack-Based-ALU-Verilog/blob/main/Picture1.jpg)

# Related Links  
[Converting infix order exp. to posfix order using Stack](https://www.geeksforgeeks.org/convert-infix-expression-to-postfix-expression)  
[calculating posfix order math exp. using stack ](https://www.geeksforgeeks.org/evaluation-of-postfix-expression)  
[Shunting Yard algorithm](https://www.geeksforgeeks.org/java-program-to-implement-shunting-yard-algorithm/)  
[stack](https://www.geeksforgeeks.org/stack-data-structure/)  
[Download Modelsim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html)
# Author  
**Sadegh Mohammadian | 401109477**  




