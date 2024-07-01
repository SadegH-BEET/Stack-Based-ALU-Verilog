# Stack-Based-ALU-Verilog
![SBALU](https://github.com/SadegH-BEET/Stack-Based-ALU-Verilog/blob/main/STALU.png)
In this project i desigend a **STACK BASED ALU** and a **calculator** for infix math expressions  
this ALU support push,pop,add,multiply instruction with 32 bit inputs and outputs  
you can see the ports of this ALU in table below:  
| port | function | 
| -------- | -------- | 
| clk   | clk!   | 
| rst  | input signal to reset ALU   |
| input_data | data for push to stack |
| opcode | showing operation |
| output_data | data of different operations |  
# Tools  
in this project i used   
* Modelsim for simulating
* VsCode writing verilog code
# Implementation Details  
# How to run  
To use this program, you can use different software such as QEMU or ModelSim or iverilog in mac
for running the Testbench with iverilog in mac you can use this command:
```
cd verilog
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




