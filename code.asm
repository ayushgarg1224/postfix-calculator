; The code below functions as a post fix notation calculator by making use of a stack. It inputs a post fix expression from the user and echoes it to the 
; screen. It pushes every operand the user types in to the stack and for every opearator it pops out the last two entries from the stack, calculates the
; operation and pushes the result into the stack. It also checks for invalid inputs and prints out the output result in a hexadecimal format once it
; encounter the equal to sign. 
;
.ORIG x3000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

READ_CHAR	
	GETC
	OUT
	LD R1, EQUAL		; loading negative of ASCII value for "="
	ADD R2, R0, R1		; checking if character just entered by the user is =
	BRz PRINT_HEX		; if the character is indeed = print the result from stack
	LD R1, SPACE		; loading negative of ASCII value for space 
	ADD R2, R0, R1		; checking if character entered by user is space
	BRz READ_CHAR		; if the character is space then read next character
	LD R1, ZERO		; loading the negative of the ascii value of zero
	ADD R2, R0, R1		; checking if the character entered by the user is greater than, equal to, or less than 0
	BRn OP_CHECK		; if character has an ASCII value less than 0 then we branch to check if it's an operand
	LD R1, NINE		; loading the negative of the ascii value of nine	
	ADD R2, R0, R1		; checking if the character entered by user is less than or equal to 9
	BRp OP_CHECK		; if the character is not a valid number we check for operations
	LD R1, ZERO		; subtracting ascii value of 0 from R0 to get actual value
	ADD R0, R0, R1		; change the value stored in R0 from the ASCII value of the number to the actual number
	JSR PUSH		; pushing the number to the stack as an operand
	BRnzp READ_CHAR		; start the loop again after reading a valid number

OP_CHECK
	LD R1, ADDIN		; loading the negative of the ASCII value for +
	ADD R2, R0, R1		; checking if the character entered is +
	BRnp SUB
	JSR POP			; popping out the last two operands from stack and storing it in R3
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; storing last popped out value in R3
	JSR POP			; popping out the last two operands from stack and storing it in R4
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R4, R0, #0		; storing last popped out value in R4
	JSR PLUS		; implementing the addition operation
	JSR PUSH
	BRnzp READ_CHAR

SUB	LD R1, MINUS		; loading the negative of the ASCII value for -
	ADD R2, R0, R1		; checking if the character entered is -
	BRnp D
	JSR POP			; popping out the last two operands from stack and storing it in R4
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R4, R0, #0		; storing last popped out value in R4
	JSR POP			; popping out the last two operands from stack and storing it in R3
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; storing last popped out value in R3
	JSR MIN			; implementing the subtraction operation
	JSR PUSH
	BRnzp READ_CHAR


D	LD R1, DIVIS		; loading the negative of the ASCII value for /
	ADD R2, R0, R1		; checking if the character entered is /
	BRnp M
	JSR POP			; popping out the last two operands from stack and storing it in R4
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R4, R0, #0		; storing last popped out value in R4
	JSR POP			; popping out the last two operands from stack and storing it in R3
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; storing last popped out value in R3
	JSR DIV			; implementing the division operation
	JSR PUSH
	BRnzp READ_CHAR

	

M	LD R1, MULT		; loading the negative of the ASCII value for *
	ADD R2, R0, R1		; checking if the character entered is *
	BRnp E
	JSR POP			; popping out the last two operands from stack and storing it in R3
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; storing last popped out value in R3
	JSR POP			; popping out the last two operands from stack and storing it in R4
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R4, R0, #0		; storing last popped out value in R4
	JSR MUL			; implementing the multiplication operation
	JSR PUSH
	BRnzp READ_CHAR


E	LD R1, EXPN		; loading the negative of the ASCII value for ^
	ADD R2, R0, R1		; checking if the character entered is ^
	BRnp INVALID
	JSR POP			; popping out the last two operands from stack and storing it in R4
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R4, R0, #0		; storing last popped out value in R4
	JSR POP			; popping out the last two operands from stack and storing it in R3
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; storing last popped out value in R3
	JSR EXP			; implementing the addition operation
	JSR PUSH
	BRnzp READ_CHAR

INVALID
	LEA R0, INVAL		; loading the invalid expression into R1
	PUTS			; printing the invalid expression
	HALT





EQUAL	.FILL #-61
SPACE	.FILL #-32
ZERO	.FILL #-48
NINE	.FILL #-57
ADDIN	.FILL #-43
MINUS	.FILL #-45
DIVIS	.FILL #-47
MULT	.FILL #-42
EXPN	.FILL #-94
INVAL	.STRINGZ "Invalid Expression"

;R3- value to print in hexadecimal
PRINT_HEX
	JSR POP
	ST R0, RESULT		; storing the final result at label RESULT
	ADD R5, R5, #-1		; checking for underflow
	BRz INVALID		; if R5 is 1 then underflow has occured and so we print out invalid expression
	ADD R3, R0, #0		; saving R0 before checking if there are any other operands left in the stack
	JSR POP			; trying to check if there are any other numbers left in the stack
	ADD R5, R5, #-1		; if there isn't an underflow then there are operands left in the stack and so we print invalid expression
	BRnp INVALID
	AND R4, R4, #0		; intialising R4
	ADD R4, R4, #4		; setting up the counter for the 4 hexa digits in the output


EXTRACTION
	AND R2, R2, #0		; initialising R2 
	ADD R0, R2, #4		; setting up a counter for extraction

LOOP_START
	ADD R2, R2, R2		; left shift to load next bit
	ADD R3, R3, #0		; sets cc
	BRzp BIT_ZERO		; checks if R1 has 0 as its MSB	
	ADD R2, R2, #1		; adds 1 to R2 for when R1 has 1 as its MSB

BIT_ZERO
	ADD R3, R3, R3		; left shifts to R1 to move onto the next bit
	ADD R0, R0, #-1		; decrement loop counter
	BRp LOOP_START		; if the counter is still positive then continue repeating the loop

	ADD R0, R2, #-9		; checking if the value in R2 is less than 9
	BRnz PRINT_NUMERICAL	; if the value is indeed less than 9 then branch to the code for printing numerical values	
	
	LD R0, A		; R0 <- R2 + 'A' - 10; doing so maps 10 to A, 11 to B, 12 to C and so on 
	ADD R0, R0, R2
	ADD R0, R0, #-10

	BRnzp DIG_LOOP_DONE

PRINT_NUMERICAL 
	LD R0, ZER		; R0 <- R2 + '0'
	ADD R0, R0, R2

DIG_LOOP_DONE
	OUT
	ADD R4, R4, #-1		; decrementing the counter for extraction
	BRp EXTRACTION		; if the counter is still positive we run the extraction and printing for the next digit
	LD R0, NEXTL		; prints next line character
	OUT

LD R5, RESULT

STOP	HALT			; done

NEXTL	.FILL x000A
A	.FILL x0041
ZER	.FILL x0030
RESULT 	.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS	
		
	ADD R0, R3, R4		; storing R3 + R4 in R0
	RET
	
;input R3, R4
;out R0

MIN	
	NOT R0, R4		; first step of negating R4
	ADD R0, R0, #1		; last step of negating R4	
	ADD R0, R3, R0		; storing R3 - R4 in R0
	RET

;input R3, R4
;out R0

MUL	
	ST R3, MULT_SaveR3	; storing the value of R3 in label
	ST R5, MULT_SAVER5	; storing the value of R5 in label
 	ST R4, MULT_SAVER4	; storing the value of R4 in label
	AND R0, R0, #0		; initialising R0	
	AND R5, R5, #0		; initialising R5 to keep a count of negative numbers
	AND R3, R3, R3		; checking if R3 is a negative number
	BRp R4C			; if it is negative then add 1 to R5
	BRz LAST		; if its zero then we simply give the output as 0
	ADD R5, R5, #1		; adding 1 to R5
	NOT R3, R3		; negating R3
	ADD R3, R3, #1
R4C	AND R4, R4, R4		; checking if R4 is a negative number
	BRzp MUL_S		; if it is negative then add 1 to R5
	ADD R5, R5, #1		; adding 1 to R5
	NOT R4, R4		; negating R4
	ADD R4, R4, #1		

MUL_S
	ADD R0, R4, R0		; storing result of repeated addition in R0
	ADD R3, R3, #-1		; decrementing the counter
	BRp MUL_S		; if the counter is still positive go back to the label MUL_S
	ADD R5, R5, #-1		; checking if both the inputs are negative
	BRnp LAST		; if they are both negative then we dont need to negate the output
	NOT R0, R0		; if only one of the inputs was negative then we negate the output
	ADD R0, R0, #1		; negating the output
LAST	LD R3, MULT_SaveR3	; loading the value of R3 back from the label
	LD R5, MULT_SAVER5	; loading the value of R5 back from the label
	LD R4, MULT_SAVER4	; loading the value of R4 back from the label
	RET

MULT_SaveR3	.BLKW #1	; label to save R3
MULT_SAVER5	.BLKW #1	; label to save R5
MULT_SAVER4	.BLKW #1	; label to save R4		
;input R3, R4
;out R0

DIV	
	ST R3, DIV_SAVER3	; storing value of R3 in label
	ST R4, DIV_SAVER4	; storing value of R4 in label
	AND R0, R0, #0		; initialising R0
	NOT R4, R4		; first step in negating R4
	ADD R4, R4, #1		; last step in negating R4
	BRnzp #1		; skips the first step before the first iteration 
DIV_S
	ADD R0, R0, #1		; increment the quotient
	ADD R3, R3, R4		; storing result of repeated subtraction in R3
	BRzp DIV_S		; if R3 is still positive or zero we continue with repeated subtraction 
	LD R3, DIV_SAVER3	; loading the original value of R3
	LD R4, DIV_SAVER4	; loading the original value of R4
	RET                        
	
DIV_SAVER3	.BLKW #1	; label to save R3
DIV_SAVER4	.BLKW #1	; label to save R4

;input R3, R4
;out R0

EXP
	ST R4, EXP_SAVER4	; saving the original value of R4
	ST R6, EXP_SAVER6	; saving the original valur of R6
	ST R7, EXP_SAVER7	; saving the value for R7 before calling another subroutine
	
	AND R0, R0, #0		; initializing R0
	ADD R0, R0, #1	 	; storing 1 in R0
	ADD R6, R4, #0		; storing value of R4 in R6 to make it into a counter
	BRz LASTE		; checking to see if either of the inputs are 0
	AND R3, R3, R3		; checking to see if either of the inputs are 0
	BRz LASTE		; checking to see if either of the inputs are 0
EXP_S	ADD R4, R0, #0		; R0 -> R4
	JSR MUL
	ADD R6, R6, #-1		; decrementing the counter
	BRp EXP_S		; if the counter is still positive keep multiplying
LASTE	LD R4, EXP_SAVER4	; loading the original value of R4
	LD R6, EXP_SAVER6	; loading the original value of R6
	LD R7, EXP_SAVER7	; loading the original value of R7
	RET	
	
EXP_SAVER4	.BLKW #1	; label to save R4
EXP_SAVER6	.BLKW #1	; label to save R6
EXP_SAVER7	.BLKW #1	; label to save R7 while calling another subroutine
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
