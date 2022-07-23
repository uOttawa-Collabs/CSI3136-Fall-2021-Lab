;------------------------------------------------------
; Alarm System Simulation Assembler Program
; File: delay.asm
; Description: The Delay Module
; Author: Gilbert Arbez
; Date: Fall 2010
;------------------------------------------------------

; Some definitions
MSCOUNT equ 3000  ; count to create a 1 ms delay

	SWITCH code_section

;------------------------------------------------------
; Subroutine setDelay
; Parameters: cnt - accumulator D
; Returns: nothing
; Global Variables: delayCount
; Description: Intialises the delayCount 
;              variable.
;------------------------------------------------------
setDelay: 
   std delayCount     ; delayCount = cnt;
   rts


;------------------------------------------------------
; Subroutine: polldelay
; Parameters:  none
; Returns: TRUE when delay counter reaches 0 - in accumulator A
; Local Variables
;   retval - acc A cntr - X register
; Global Variables:
;      delayCount
; Description: The subroutine delays for 1 ms, decrements delayCount.
;              If delayCount is zero, return TRUE; FALSE otherwise.
;   Core Clock is set to 24 MHz, so 1 cycle is 41 2/3 ns
;   NOP takes up 1 cycle, thus 41 2/3 ns
;   Need 24 cyles to create 1 microsecond delay
;   8 cycles creates a 333 1/3 nano delay
;	DEX - 1 cycle
;	BNE - 3 cyles - when branch is taken
;	Need 4 NOP
;   Run Loop 3000 times to create a 1 ms delay   
;------------------------------------------------------
; Stack Usage:
	OFFSET 0  ; to setup offset into stack
PDLY_VARSIZE:
PDLY_PR_Y   DS.W 1 ; preserve Y
PDLY_PR_X   DS.W 1 ; preserve X
PDLY_PR_B   DS.B 1 ; preserve B
PDLY_PR_A   DS.B 1 ; preserve A
PDLY_RA     DS.W 1 ; return address

polldelay: psha
   pshb
   pshx
   pshy
   ldaa #FALSE		; byte retval=FALSE; // return value
   ldx #MSCOUNT		; byte cntr = MSCOUNT;
pdly_while:
   beq pdly_endwhile ; while(cntr != 0)
                     ; {
   nop               ;   asm { nop; nop; nop; nop; }
   nop
   nop
   nop
   dex               ;   cntr--;
   bra pdly_while    ; }
pdly_endwhile:
   ldy delayCount    ; delayCount--;
   dey
   sty delayCount
   bne pldy_endif    ; if(delayCount==0) 
   ldaa #TRUE        ; retval=TRUE;
pldy_endif:
   ; restore registers and stack
   puly
   pulx
   pulb
   pula
   rts



;------------------------------------------------------
; Global variables
;------------------------------------------------------
   switch globalVar
delayCount ds.w 1   ; 2 byte delay counter
