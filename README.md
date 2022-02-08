Postfix Calculator

Introduction:
While learning about LC3 assembly language and data structures I decided to make a postfix calculator using a stack. The code is written in LC3 assembly language. It inputs positive numbers between 1-9 and operations (*,+,-,/,^) and outputs the result of the calculation when it encounters "=" (equal to sign). It also identifies invalid postfix expressions and is able to add, subtract and multiply negative intermediate values. 

Technical summary:
The code evaluates the expression as the user inputs it and pushes all operands into a stack. When it encounters an operation it pops out the two last values in the stack and pushes the result back into the stack. It repeats these steps till it encounters an equal to sign and then it pops out the result of the expression from the stack and outputs it in a hexadecimal format.

