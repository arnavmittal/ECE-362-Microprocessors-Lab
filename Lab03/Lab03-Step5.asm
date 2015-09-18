; ECE 362 Lab 3 - Fall 2014 - Step 5

; Name: < enter name here >

; Lab: < enter lab division here >

; Class Number: < enter class number here >

; Use Code Warrior (CW) in Full Chip Simulation mode

;***********************************************************************
;
; Write a program that prompts the user for the initial (ASCII) character
; of a string followed by the number (range: 1-9) of characters that follow
; it in the ASCII table (Reference: page 30 of the CPU12 Reference Guide).
; The program should respond by printing the starting character along with
; the N characters that follow it. If the number entered is not in the range 
; of 1-9, an error message should be displayed.
;
;                                                                            
; Example session:
;                          
;   Enter starting character: N
;   Enter number: 8
;   NOPQRSTUV
;   Enter starting character: a
;   Enter number: 1
;   ab
;   Enter starting character: A
;   Enter number: 0
;   *** ERROR *** Invalid number
;   Enter starting character: A
;   Enter number: B
;   *** ERROR *** Invalid number
;   Enter starting character: ;
;   Enter number: 6
;   ;<=>?@A
; 
; (program keeps running until process is terminated)
;


;***********************************************************************
;
; Print macro (from notes) - use to output "prompt" strings

print		MACRO
		jsr	pmsg
		fcb	RET,LF
		fcc	\1
 		fcb	RET,LF
		fcb	NULL
		ENDM


;***********************************************************************
; Step a: 
;
; Subroutine: nchars
;
; Inputs: ASCII value of starting character in the A register
;         Number of characters to be printed in the B register
;
; Function: Prints a series of N+1 characters beginning with the ASCII 
;	          character in the A register and followed by the N 
;	          characters that follow in the ASCII table
;
; Subroutines called:  outchar
;
;***********************************************************************

      	        org	$0800
nchars

; put your subroutine code here
    
loop_print      jsr     outchar       ;  Prints the first character onto the screen
                inca                  ;  Brings the next character by getting the new ASCII value
                dbne    b, loop_print ;  Decrements B register and => loop_print again
	              rts   


;***********************************************************************
; Step b: 
; 
; Program: main
;
; Function:  Prompts the user for the beginning character and the 
;            number of characters to be printed.
;            Prints a series of N+1 characters beginning with the ASCII 
;	           character in the A register and followed by the N 
;	           characters that follow in the ASCII table (call nchars)
;
; Subroutines called:  <List the subroutines you use here>
;
;***********************************************************************

      	        org	$0900
main 	          lds	#$1000	        ; initialize SP
              	jsr	sinit 	        ; initialize serial port

mloop			                          ; main loop

; put your code for main here
      	        
      	        print   "Enter starting character: "
      	        jsr     inchar
      	        jsr     outchar
      	        ;print   \n
      	        psha
      	        
loop_check      print   "Enter number: "
      	        jsr     inchar
      	        jsr     outchar
      	        ;print   \n
      	        
      	        jsr     pmsg
      	        fcb     LF
      	        fcb     NULL
      	        
      	        cmpa    #$30
      	        beq     loop_error
      	        
      	        cmpa    #$39
      	        bhi     loop_error     
      	        ble     loop_progress
      	        
loop_error      print   "*** ERROR *** Invalid number"
                ;print   \n
                bra     mloop      	        
      	        
loop_progress   suba    #$30
      	        tfr     a,b
      	        pula
                jsr     nchars
      	        jmp	    mloop	      ; continue execution until process is terminated



;***********************************************************************
; Character I/O Library Routines for 9S12C32
;***********************************************************************
;
; ==== SCI Register Definitions

SCIBDH		equ	$00C8		;SCI0BDH - SCI BAUD RATE CONTROL REGISTER
SCIBDL		equ	$00C9		;SCI0BDL - SCI BAUD RATE CONTROL REGISTER
SCICR1		equ	$00CA		;SCI0CR1 - SCI CONTROL REGISTER
SCICR2		equ	$00CB		;SCI0CR2 - SCI CONTROL REGISTER
SCISR1		equ	$00CC		;SCI0SR1 - SCI STATUS REGISTER
SCISR2		equ	$00CD		;SCI0SR2 - SCI STATUS REGISTER
SCIDRH		equ	$00CE		;SCI0DRH - SCI DATA REGISTER
SCIDRL		equ	$00CF		;SCI0DRL - SCI DATA REGISTER
PORTB		equ	$0001		;PORTB - DATA REGISTER
DDRB		equ	$0003		;PORTB - DATA DIRECTION REGISTER

; ==== ASCII Character Definitions

NULL    	equ	$00
CR      	equ	$0D
LF      	equ	$0A
RET       equ $d

;
; Initialize asynchronous serial port (SCI) for 9600 baud
;
; Assumes PLL not engaged -> CPU bus clock is 4 MHz
;

sinit	  movb	#$00,SCIBDH	; set baud rate to 9600
	  movb	#$1A,SCIBDL	; 4,000,000 / 16 / 26 = 9600 (approx)
	  movb	#$00,SCICR1	; $1A = 26
	  movb	#$0C,SCICR2	; initialize SCI for program-driven operation
	  movb	#$10,DDRB	; set PB4 for output mode
	  movb	#$10,PORTB	; assert DTR pin of COM port
	  rts

;
; SCI handshaking status bits
;

rxdrf   equ   $20    ; receive data register full (RDRF) mask pattern
txdre   equ   $80    ; transmit data register empty (TDRE) mask pattern

;***********************************************************************
; Name:         inchar
; Description:  inputs ASCII character from SCI serial port
;                  and returns it in the A register
; Returns:      ASCII character in A register
; Modifies:     A register
;***********************************************************************

inchar  brclr  SCISR1,rxdrf,inchar
        ldaa   SCIDRL ; return ASCII character in A register
        rts

;***********************************************************************
; Name:         outchar
; Description:  outputs ASCII character passed in the A register
;                  to the SCI serial port
;***********************************************************************

outchar brclr  SCISR1,txdre,outchar
        staa   SCIDRL ; output ASCII character to SCI
        rts

;***********************************************************************
; pmsg -- Print string following call to routine.  Note that subroutine
;         return address points to string, and is adjusted to point to
;         next valid instruction after call as string is printed.
;***********************************************************************

pmsg    pulx            ; Get pointer to string (return addr).
        psha
ploop   ldaa    1,x+    ; Get next character of string.
        beq     pexit   ; Exit if ASCII null encountered.
        jsr     outchar ; Print character on terminal screen.
        bra     ploop   ; Process next string character.
pexit   pula
        pshx            ; Place corrected return address on stack.
        rts             ; Exit routine.
	
;***********************************************************************
; Subroutine:	htoa
; Description:  converts the hex nibble in the A register to ASCII
; Input:	hex nibble in the A accumualtor
; Output:	ASCII character equivalent of hex nibble
; Reg. Mod.:	A, CC
;***********************************************************************

htoa	adda	 #$90
	daa
	adca	 #$40
	daa
	rts

	end

