 ;Text after a semicolon is comments, you don't need to type it in

	org $0801			;Header starts at address $0801

;Init Routine. This is the basic code for command to run our program
	db $0E,$08,$0A,$00,$9E,$20,$28,$32,$30,$36,$34,$29,$00,$00,$00  

;Program Start at $0810

	lda #$0e			;Full Charset (not just uppercase)
	jsr $ffd2			;CHROUT - Output a character  

;Load in the address of the Message into the zero page address $0020/21

	lda #>HelloWorld	;> takes the High byte of a 16 bit address
	sta $21				;H Byte of string address
	lda #<HelloWorld	;< takes the Low byte of a 16 bit address
	sta $20				;L Byte of string address
	
	jsr PrintStr		;Show to the screen
	rts					;Return to basic

PrintStr:
	ldy #0				;Reset Y
PrintStr_again:
	lda ($20),y			;Read in a character
	cmp #255
	beq PrintStr_Done	;Return if we've reached a 255
	jsr PrintChar		;Print to screen if not
	iny
	jmp PrintStr_again	;repeat
PrintStr_Done:
	rts					;Return when done
	
PrintChar:
	cmp #64				;Check if character >64 (any letter)
	bcc	PrintCharOKB
	eor #%00100000		;Convert to lower/uppercase (Swap them)
PrintCharOKB:	
	jmp $FFD2			;CHROUT - Output a character 
	
HelloWorld:				;Test string to show
	db "Hello World. My name is Chastity!"
	db 255				;End of string
	
	
	
	 
