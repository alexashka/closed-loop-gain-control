_v#v(HERE)_COMP_SETuw_wByteIn
	mObject_sel	THIS
	movwf	Newbyte_In  
	movf	TooOldbyte_In,w		
	xorlw	0xAA
	bnz		_Non_header  
	movf	Oldbyte_In,w
	xorlw	0x55
	bnz		_Non_header
_Header:
	movlw	MAXNUMBERBYTE  
	cpfslt	Newbyte_In  
	goto	_COMP_ByteError		
	movf	Newbyte_In,w
	movwf	Number_In
	movwf	Number_In_Max	
	clrf	Checksum_In	
_Non_header:
	movf	Number_In,f		
	bz		_cash_In_IRQ		
_NextByte:
	movf	Oldbyte_In,w	
	xorlw	0xAA
	bnz		_ordin
	movf	Newbyte_In,w
	bz		_cash_In_IRQ
	goto	_COMP_ByteError
_ordin:
	decfsz	Number_In,f		
	bra		_Cash_In		
_EOFbyte:	
	movf	Newbyte_In,w
	cpfseq	Checksum_In
	bra		_cash_In_IRQ
	goto	_COMP_Com_Process  
_Cash_In:	
	lfsr	1,Buffer_In_00-1
	movf	Number_In,w
	subwf	Number_In_Max,w
	movff	Newbyte_In,PLUSW1
	movf	Newbyte_In,w
	addwf	Checksum_In,f
_cash_In_IRQ:
	movff	Oldbyte_In,TooOldbyte_In
	movff	Newbyte_In,Oldbyte_In	
	retlw	VOID
_COMP_Com_Process	
	mObject_sel	THIS
	movlw	0x1F	
	xorwf	Buffer_In_00+1,w	
	btfss	STATUS,Z	
	retlw	VOID
	lfsr	0,Buffer_In_00+2	
	movlw	0x01	
	xorwf	INDF0,w	
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Req1
	movlw	TYPE_MSG_GET_NFO_ABOUT_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Req2
	movlw	0x04
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Req3
	movlw	TYPE_MSG_CPUX_LOG 	
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Req4
	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass  
	movf 	State_setGainAtt, w	
	bz _skipOut  
	call    _v#v(DOWN)_PIO_SETdw_I2CMIntStart	
	movlw 	ADD_ATT
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 
	movlw 	OUT_TO_PORT1  
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 
	lfsr	0, Buffer_In_00+3
	movf	INDF0, 	w
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 
	call   _v#v(DOWN)_PIO_SETdw_I2CMIntStop 
	lfsr	0, Buffer_In_00+3	
	movf	INDF0, 	w
	call 	_v#v(HERE)_EC_SaveValAtt
	movlw 	NO_OBTAINED
	movwf	State_setGainAtt
	lfsr	0,	Buffer_In_00+2
_skipOut:	
	return  
_bypass:  
	movlw	TYPE_MSG_CMD	
	xorwf	INDF0,w
	btfss	STATUS,Z
	retlw	VOID
	lfsr	0,Buffer_In_00+3
	movlw	TYPE_MSG_CMD_SET_ATT_STAGE1	
	xorwf	INDF0,w
	bnz 	_bypassSetState
	movlw 	OBTAINED 
	movwf	State_setGainAtt
	return
_bypassSetState:	
	movlw	0xA0  
	xorwf	INDF0,w		
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_On
	movlw	0xA1
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Off
	movlw	0x1F
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Lock
	movlw	OPEN_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_UnLock
	movlw	RST_PARAMETERS
	xorwf	INDF0,w
	btfsc	STATUS,Z
	goto	_v#v(UP)_TASK_SETuw_Reset
	movlw	0x6B-1
	cpfsgt	INDF0
	bra		_Tune
	movf	INDF0,w
	addlw	d'21'-0x6B
	goto	_v#v(UP)_TASK_SETuw_wChannelCom
_Tune:	
	movf	INDF0,w
	goto	_v#v(UP)_TASK_SETuw_wTuneCom
_v#v(HERE)_COMP_SETuw_ByteOut
	mObject_sel	THIS
	movff	Oldbyte_Out, TooOldbyte_Out
	movff	Newbyte_Out, Oldbyte_Out		
	tstfsz	Number_Out_Max
	bra		_transmit
	tstfsz	Number_Out
	bra		_DecandcCash
	goto	_v#v(DOWN)_PIO_SETdw_Uart2StopTx
_transmit:
	movf	TooOldbyte_Out,w	
	xorlw	0xAA
	bnz		_Non_framer
	movf	Oldbyte_Out,w
	xorlw	0x55
	bnz		_Non_framer
_framer:
	movff	Number_Out_Max,Number_Out
	clrf	Checksum_Out
	bra		_Cash_Out
_Non_framer:
	movf	Oldbyte_Out,w
	xorlw	0xAA
	bnz		_ordout
	movlw	0x55
	tstfsz	Number_Out
	movlw	0x00
	movwf	Newbyte_Out
	bra		_cash_Out_IRQ
_ordout:
	decf	Number_Out,w							
	bnz		_Cash_Out
	clrf	Number_Out_Max
	movff	Checksum_Out,Newbyte_Out
	bra		_cash_Out_IRQ
_Cash_Out:
	lfsr	1,Buffer_Out_00
	movf	Number_Out,w
	subwf	Number_Out_Max,w
	movf	PLUSW1,w
	movwf	Newbyte_Out
	addwf	Checksum_Out,f
_DecandcCash:
	decf	Number_Out,f
_cash_Out_IRQ:
	movf	Newbyte_Out,w  
	goto	_v#v(DOWN)_PIO_SETdw_wUart2NextTx