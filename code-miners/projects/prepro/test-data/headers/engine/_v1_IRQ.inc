; формат - есть выделение пам€ти
;  file : #include _v1_IRQ.inc
;
;  abs. : макросы и переменные дл€ работы с прерывани€ми
;
constant	HERE=1
#define		THIS	_v1_IRQ
#define		_v1_IRQ		_v1_IRQ
#include	<../headers/user_modes.inc>

;/// похоже это сохнанение состо€ние преде вызовом 
;// программы обработки прерывани€
mTpush	macro
	movff	FSR0L, temp2_fsr0L
	movff	FSR0H, temp2_fsr0H
	movff	FSR1L, temp2_fsr1L
	movff	FSR1H, temp2_fsr1H
	movff	FSR2L, temp2_fsr2L
	movff	FSR2H, temp2_fsr2H
	movff	BSR,   temp2_BSR
	movff	STATUS,temp2_STATUS
	movwf	FSR0L	; ? а почему не сразу
	movff	FSR0L, temp2_WREG
endm

;// восстанавливаем состо€ние прерванной программы
mTpull	macro
	movff	temp2_WREG,FSR0L
	movf	FSR0L,w
	movff	temp2_BSR,BSR
	movff	temp2_STATUS,STATUS
	movff	temp2_fsr0L,FSR0L
	movff	temp2_fsr0H,FSR0H
	movff	temp2_fsr1L,FSR1L
	movff	temp2_fsr1H,FSR1H
	movff	temp2_fsr2L,FSR2L
	movff	temp2_fsr2H,FSR2H
endm
;///
	
;/// “оже похоже сохранение, но дл€ высокопреоритетных прерываний	
mFSRin	macro	;// FSR in
	movff	FSR0L,temp_fsr0L
	movff	FSR0H,temp_fsr0H
	movff	FSR1L,temp_fsr1L
	movff	FSR1H,temp_fsr1H
	movff	FSR2L,temp_fsr2L
	movff	FSR2H,temp_fsr2H
endm

mFSRout	macro
	movff	temp_fsr0L,FSR0L
	movff	temp_fsr0H,FSR0H
	movff	temp_fsr1L,FSR1L
	movff	temp_fsr1H,FSR1H
	movff	temp_fsr2L,FSR2L
	movff	temp_fsr2H,FSR2H
endm
;///

variable	i=0

;/// TMR1IE - номер бита в PIE1
;// PIE1: PERIPHERAL INTERRUPT ENABLE REGISTER 1
mTimer1_int	macro	label
	btfsc	PIE1,TMR1IE
		btfss	PIR1,TMR1IF
	bra		metka#v(i)
		bcf		PIR1,TMR1IF
	clrwdt	;// wd timer
	call	label
metka#v(i):
	i++
endm

mADconv_int	macro	label
	btfsc	PIE1,ADIE
		btfss	PIR1,ADIF
	bra		metka#v(i)
		bcf		PIR1,ADIF
	call	label
metka#v(i):
	i++
endm

;/// UART_i
mUART1RX_int macro	label
	btfsc	PIE1,RC1IE
		btfss	PIR1,RC1IF
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm
			
mUART1TX_int macro	label
	btfsc	PIE1,TX1IE
		btfss	PIR1,TX1IF
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm

;// UART2
mUART2RX_int macro	label
	btfsc	PIE3,RC2IE
		btfss	PIR3,RC2IF
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm

;// btfsc - Bit Test f, Skip i f Clear
;// btfss - Bit Test f, Skip i f Set
mUART2TX_int macro	label
	btfsc	PIE3,TX2IE	; TX2IE - используетс€ как номер бита?
		btfss	PIR3,TX2IF ; проскакиваем и вызываем функцию?
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm
;/// end UARTs

;/// 
;
;SSP1IE: MSSP1 Interrupt Enable bit
;1 = Enables the MSSP1 interrupt
;0 = Disables the MSSP1 interrupt
mSSP1_int	macro	label
	btfsc	PIE1,SSP1IE
		btfss   PIR1,SSP1IF	
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm


