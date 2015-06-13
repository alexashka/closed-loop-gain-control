	;********************************************************************
	;	Tiny Bootloader		18F series		Size=100words
	;	claudiu.chiculita@ugal.ro
	;	http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
	;********************************************************************
	; Updated by Patrik Spanel and S'L ava

#include "headers/tinybld18F6621.inc"
#ifdef	bootloader
	extern	_start
mydata1	udata_ovr
	crc		res		1
	i		res		1
	cnt2	res		1
	cnt3	res		1
	flag		res	1

mydata1	udata_ovr
	counter_hi		res	1

mydata2	udata
	buffer	res	64
	dummy4crc	res	1

;0000000000000000000000000 RESET 00000000000000000000000000

	code    0x0000
	goto    IntrareBootloader

;view with TabSize=4
;&&&&&&&&&&&&&&&&&&&&&&&   START     &&&&&&&&&&&&&&&&&&&&&&
;----------------------  Bootloader  ----------------------
;PC_flash:		C1h				U		H		L		x  ...  <64 bytes>   ...  crc	
;PC_eeprom:		C1h			   	40h   EEADR   EEDATA	0		crc					
;PC_cfg			C1h			U OR 80h	H		L		1		byte	crc
;PIC_response:	   type `K`
	
first	code first_address		;space to deposit first 4 instr. of user prog.
	goto	_start
	nop
	nop


first_a	code first_address+8
IntrareBootloader:
	
 	;// init serial port
	movlw	b'00100100'
	movwf	TXSTA2
	;// CSRC
		;//TX9 
			;//TXEN - разрешение передачи
				;//SYNC  - 0 асин.
					;// SENDB 
						;//BRGH - 1 high speed
							;//TRMT
								;//TX9D
	;// битовая скорость
	;// 20 000/9600
	movlw	129		;spbrg_value
	movwf	SPBRG2  

	movlw	b'10010000'
	movwf	RCSTA2
	;//SPEN - разрешение работы
		;//RX9 
			;//SREN 
				;//CREN - 1 разрешение приема
					;//ADDEN 
						;//FERR 
							;//OERR 
								;//RX9D

							;wait for computer
	rcall	Receive			
	xorlw	0xC1			;Expect C1h
	bnz		way_to_exit
	SendL	IdTypePIC		;send PIC type

;MainLoop:
;	SendL	'K'				; "-Everything OK, ready and waiting."
MainLoop:
	movlw 	'K'
MainLoop2:
	movwf 	TXREG2
mainl:
	clrf 	crc
	rcall	Receive			;Upper
	movwf	TBLPTRU
	movwf	flag			;(for EEPROM and CFG cases)
	rcall	Receive			;Hi
	movwf	TBLPTRH
	movwf	EEADR			;(for EEPROM case)
	rcall	Receive			;Lo
	movwf	TBLPTRL
	movwf	EEDATA			;(for EEPROM case)
	rcall	Receive			;count
	movwf	i
;	incf	i
	lfsr	FSR0, (buffer-1)

rcvoct:						;read 64+1 bytes
	movwf	TABLAT			;prepare for cfg; => store byte before crc
	rcall	Receive
	movwf	PREINC0
	decf	i
	bnn		rcvoct
;	decfsz	i
;	bra 	rcvoct

	movlw	'N'		
	tstfsz	crc				;check crc
;	bra		ziieroare
	bra		MainLoop2

;	btfss	flag,6			;is EEPROM data?
;	bra		noeeprom
;	movlw 	b'00000100'		;Setup eeprom
;	rcall	Write
;	bra		waitwre

	movlw 	b'00000100'		;Setup eeprom
	btfsc	flag,6			;is EEPROM data?
	bra		wr_b
;noeeprom:
	btfss	flag,7			;is CFG data?
	bra		noconfig
	tblwt*					;write TABLAT(byte before crc) to TBLPTR***
	movlw	b'11000100'		;Setup cfg
wr_b:
	rcall	Write
	bra		waitwre
noconfig:
							;write
eraseloop:
	movlw	b'10010100'		; Setup erase
	rcall	Write
	TBLRD*-					; point to adr-1

;writebigloop:	
;	movlw	8					; 8groups
;	movwf	counter_hi
;	lfsr	FSR0,buffer
;writesloop:
;	movlw	8					; 8bytes = 4instr
;	movwf	counter_lo
;writebyte:
;	movf	POSTINC0,w			; put 1 byte
;	movwf	TABLAT
;	tblwt+*
;	decfsz	counter_lo
;	bra		writebyte
;	
;	movlw	b'10000100'		; Setup writes
;	rcall	Write
;	decfsz	counter_hi
;	bra		writesloop

;next code instead of previuos remarked block for one word economy
;//
writebigloop:
	lfsr	FSR0,buffer
writesloop:
	bsf		counter_hi,3
	movff	POSTINC0,TABLAT			; put 1 byte
	tblwt+*
	movlw	b'10000100'		; Setup writes
	incf	counter_hi,f
	btfss	counter_hi,3
	rcall	Write
	bnn		writesloop
;//
	


waitwre:	
	;btfsc EECON1,WR		;for eeprom writes (wait to finish write)
	;bra waitwre			;no need: round trip time with PC bigger than 4ms
	
	bcf		EECON1,WREN			;disable writes
	bra		MainLoop
	
;ziieroare:					;CRC failed
;	SendL	'N'
;	bra		mainl
	  
;******** procedures ******************

Write:
	movwf	EECON1
	movlw	0x55
	movwf	EECON2
	movlw	0xAA
	movwf	EECON2
	bsf		EECON1,WR			;WRITE
	;nop
	bra		$+2
	;nop
	return


Receive:
	movlw	11;xtal/2000000+1	; for 20MHz => 11 => 1second delay
;	movwf	cnt1
;rpt2:						
	clrf	cnt2
;rpt3:
	clrf	cnt3
rptc:
	clrwdt
	btfss	PIR3,RC2IF			;test RX
	bra		notrcv
	movf	RCREG2,w			;return read data in W
	addwf	crc,f				;compute crc
	return
notrcv:
;	decfsz	cnt3
;	bra		rptc
;	decfsz	cnt2
;	bra		rpt3
;	decfsz	cnt1
;	bra		rpt2

	dcfsnz	cnt3
	decfsz	cnt2
	bra		rptc
	addlw	-1				
	bnz		rptc
	;timeout:
way_to_exit:
	bcf		RCSTA2,	SPEN			; deactivate UART
	bra		first_address
;*************************************************************
; After reset
; Do not expect the memory to be zero,
; Do not expect registers to be initialised like in catalog.
endif
	END
