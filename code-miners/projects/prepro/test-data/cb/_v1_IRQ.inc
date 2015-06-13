;/**
;  file : #include _v1_IRQ.inc
;
;  abs. : макросы и переменные дл€ работы с прерывани€ми
;
; */

temps	idata

;// сюда сохран€ютс€ спец. регистры при вызове высокопреоритетных прер.
temp_fsr0L		res 1
temp_fsr0H		res 1
temp_fsr1L		res 1
temp_fsr1H		res 1
temp_fsr2L		res 1
temp_fsr2H		res 1

;// сюда сохран€ютс€ спец. регистры при вызове низкопреор. прер.
temp2_fsr0L		res 1
temp2_fsr0H		res 1
temp2_fsr1L		res 1
temp2_fsr1H		res 1
temp2_fsr2L		res 1
temp2_fsr2H		res 1
temp2_WREG		res 1
temp2_BSR		res 1
temp2_STATUS	res 1

;// btfsc - Bit Test f, Skip if Clear
;// btfss - Bit Test f, Skip if Set
mUART2TX_int macro	label
	btfsc	PIE3,TX2IE	; TX2IE - используетс€ как номер бита?
		btfss	PIR3,TX2IF ; проскакиваем и вызываем функцию?
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm
;asdf
mSSP1_int	macro	label, label2
	btfsc	PIE1,SSP1IE
		btfss   PIR1,SSP1IF	
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm
asdf
asdfdffdf
mSSP1_int2	macro
	btfsc	PIE1,SSP1IE
		btfss   PIR1,SSP1IF	
	bra		metka#v(i)
		call	label
metka#v(i):
	i++
endm
