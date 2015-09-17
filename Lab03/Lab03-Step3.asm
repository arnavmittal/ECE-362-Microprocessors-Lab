; ECE 362 - Lab 3 - Step 3

; Name: Arnav Mittal

; Lab: #9

; Class Number: 8153 - M

; Use Code Warrior (CW) in Full Chip Simulation mode

;***********************************************************************
; Write a subroutine "correl" that calculates the correlation between
; two 16-bit binary values, where the correlation is defined as the
; number of corresponding bit positions that are identical.
;
; At entry, the X and Y registers contain the two 16-bit operands;
; at exit, the B register contains the correlation value (which can
; range from $00 to $10).
;
; Examples:
;
; if   (X) = %10101010 01010101 = $AA55 and (Y) = %01010101 10101010 = $55AA
; then (B) = $00
;
; if   (X) = %11001100 11001100 = $CCCC and (Y) = %01010101 10101010 = $55AA
; then (B) = $08
;
; if   (X) = %00000000 00000000 = $0000 and (Y) = %00000000 00000000 = $0000
; then (B) = $10
;
;***********************************************************************
;
; To test and auto-grade your solution:
;	- Use CodeWarrior to assemble your code and launch the debugger
;	- Load the Auto-Grader (L3AG-3.s19) into the debugger
;		> Choose File -> Load Application
;		> Change the file type to "Motorola S-Record (*.s*)"
;		> Navigate to the 'AutoGrade' folder within your project
;		> Open 'L3AG-3.s19'
; - Open and configure the SCI terminal as a debugger component
;	- Start execution at location $800
;
; The score displayed is the number of test cases your code has passed.
; If nothing is displayed (i.e., your code "crashes"), no points will be
; awarded - note that there is no way to "protect" the application that
; tests your code from stack errors inflicted by mistakes in your code.
;
; Also note: If the message "STACK CREEP!" appears, it means that the
; stack has not been handled correctly (e.g., more pushes than pops or
; data passed to it not de-allocated correctly). 
;
;***********************************************************************

	org	$A00	; DO NOT REMOVE OR MODIFY THIS LINE

; Place your code for "correl" below

correl

              ldab   #$0          ;  Loads B register with 0 initially
              pshx                ;  Pushes X register on the stack
              pshy                ;  Pushes Y register on the stack
              pula                ;  Pulls Y register's L byte into A register
              
              eora   1,sp         ;  XORs X_L and Y_L and result goes to A
	            
              ldy    #$8          ;  Loads Y register with loop counter
              coma                ;  Compliments A register's bits           
loop1
              rola                ;  Rotates A register to left
              adcb   #$0          ;  Adds with carry to B register
              dbne   y,loop1      ;  Decrements Y register by 1, if Y!=0 => loop1
	            
	      pula                ;  Pulls Y register's H byte into A register
	      eora   1,sp         ;  XORs X_H and Y_H and result goes to A
              
              
              ldy    #$8          ;  Loads Y register with loop counter
              coma                ;  Compliments A register's bits           
loop2
              rola                ;  Rotates A register to left
              adcb   #$0          ;  Adds with carry to B register
              dbne   y,loop2      ;  Decrements Y register by 1, if Y!=0 => loop1	            
	            
	      puly
	            
	            
	      rts

	      end
