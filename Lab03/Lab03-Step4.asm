; ECE 362 Lab 3 - Fall 2014 - Step 4

; Name: Arnav Mittal

; Lab: #9

; Class Number: 8153 - M

; Use Code Warrior (CW) in Full Chip Simulation mode

;***********************************************************************
; Write a subroutine "minmax" that searches the array of UNSIGNED 16-bit
; words passed to it by name, and returns the MINIMUM and MAXIMUM values
; via the stack. The minimum array length that needs to be handled is
; 2 words and the maximum array length is 100 words.
;
; At entry to "minmax", the stack content is as follows (note that the
; calling program allocates space on the stack for MINVAL and MAXVAL,
; and initializes these to $0000):
;
;      +--------------------+
; SP ->| return address - H |
;      +--------------------+
;      | return address - L |
;      +--------------------+
;      | number of elements |
;      +--------------------+
;      | array pointer - H  |
;      +--------------------+
;      | array pointer - L  |
;      +--------------------+
;      |   00 (maxval - H)  |
;      +--------------------+
;      |   00 (maxval - L)  |
;      +--------------------+
;      |   00 (minval - H)  |
;      +--------------------+
;      |   00 (minval - L)  |
;      +--------------------+
;
; Just prior to exit from "minmax", the stack content is as follows:
;
;      +--------------------+
; SP ->| return address - H |
;      +--------------------+
;      | return address - L |
;      +--------------------+
;      |    <don't care>    |
;      +--------------------+
;      | array pointer - H  |
;      +--------------------+
;      | array pointer - L  |
;      +--------------------+
;      |     maxval - H     |
;      +--------------------+
;      |     maxval - L     |
;      +--------------------+
;      |     minval - H     |
;      +--------------------+
;      |     minval - L     |
;      +--------------------+
;
;***********************************************************************
;
; To test and auto-grade your solution:
;	- Use CodeWarrior to assemble your code and launch the debugger
;	- Load the Auto-Grader (L3AG-4.s19) into the debugger
;		> Choose File -> Load Application
;		> Change the file type to "Motorola S-Record (*.s*)"
;		> Navigate to the 'AutoGrade' folder within your project
;		> Open 'L3AG-4.s19'
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

; Place your code for "minmax" below

minmax

                movw #$ffff, 7, sp   ;
                ldx   3,sp           ; 
                ldaa  2,sp           ;
                tfr   a,y            ;

                
loop            ldd   2,x+           ;
                emaxm 5,sp           ;
                eminm 7,sp           ;
                dbne y,loop          ;
                


        rts

	end
