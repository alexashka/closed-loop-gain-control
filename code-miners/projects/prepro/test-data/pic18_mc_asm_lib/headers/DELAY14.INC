
	ifndef	DefMacroDelay
	extern	DelayUs20MHz, DelayMs20MHz, delay10s, delay1s
	endif



DelayMs	macro	T_ms
	movlw	low	T_ms
pagesel		DelayMs20MHz
	call	DelayMs20MHz
pagesel	$
	endm

DelayUs	macro	T_us
	movlw	low	T_us
pagesel		DelayMs20MHz
	call	DelayUs20MHz
pagesel	$
	endm

Delay1s	macro
pagesel		DelayMs20MHz
	call	delay1s
pagesel	$
	endm

Delay10s	macro
pagesel		DelayMs20MHz
	call	delay10s
pagesel	$
	endm










