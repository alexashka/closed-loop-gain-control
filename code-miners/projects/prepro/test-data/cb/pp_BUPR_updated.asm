#-*- coding: utf-8 -*-
constant	HERE=3
#define		_v3_BUPR	_v3_BUPR
#define		THIS	_v3_BUPR
	radix dec
constant		UPNUM		=		1
#define ZOND
#define VUM_TEMPER_DBG	;  подмена данных +igor заменяем порог отказа по темпер.
	#define TERM_THRESHOLD 32 ;  oC порог срабатывания отказа по темпертуре
#define	_2Ublock
#define _Umip42V		; для перекл порога по МИП на +42(+13%/-15%) V	 +020312
#define TM_250W
	#define CURRENT_THRESHOLD 0x855	;  10 А
#define TH_TATT 0xFFF; 4095; 
	#define VOLTAGE_THRESHOLD 0xDA5
#define VUM		;  +igor
#define UKV_ARU		;  пусть будет один тип сообщения - 
#define _duplex		;  (при НЕактивной _Uniplex)при активировании контроллер на выв. 
#define	manyBUM_OFF_bDE		;  активировать!!!, для многоблочных ПРД 
#define air100
	constant	MINUMDOPTOON	=	2; 1; 2
	constant	DOWN			=	HERE-1; 
	constant	UP				=	HERE+1; 
	constant	VOID			=	0
	constant	TRUE			=	0x00
	constant	FALSE			=	0xFF
	constant	SLOMAN			=	0xFF
	constant	NORMA			=	0
	constant	YES				=	0
	constant	NO				=	0xFF
	constant	EOF				=	0x55
	constant	MAXNUMBERBYTE	=	88; ..\headers\objects_macro.inc
#define OBJ_MAC
	variable	Number_Static=0
	variable	Number_Public=0
	variable	Number_Ext_Functions=0
	variable	Number_Ext_Variables=0
mObject_var		macro	klass
	klass		idata
	klass#v(0)	res	0
endm
				
mObject_end		macro	klass
				endm
mObject_sel		macro	klass
				endm
mEXTENDS		macro	klass_s, klass_d, name
				endm
mSlideTo	macro	Link
	goto	Link
endm
mRetIfF	macro	link
	call	link
	xorlw	TRUE
	btfss	STATUS,Z
	retlw	FALSE
			endm
mFunction	macro	link
	call	link
			endm
mASK		macro	link
	call	link
			endm
mGET		macro	link
	call	link
			endm
mSET		macro	link
	call	link
			endm
mRUN		macro	link
	call	link
			endm
			
mRETURN		macro
	return
			endm
mCallSave	macro	link
	call	link, FAST
			endm
mReturnSave	macro
	return	FAST
			endm
mCall		macro 	link
	call link
			endm
	#define Z_I2C_ERR
	#define M1_ZOND	;  
#define MOVE_CODE
 		extern	_v2_PIO_SETdw_wUart1StartTx
 		extern	_v2_PIO_SETdw_wUart1NextTx
 		extern	_v2_PIO_SETdw_Uart1StopTx
 		extern	_v2_PIO_SETdw_Uart1Antifreeze
 		extern	_v2_PIO_SETdw_AdrLoadW
 		extern	_v2_PIO_SETdw_wLedAlrOn
 		global	_v3_BUPR_SETuw_wByteIn
 Number_Ext_Functions++
 		global	_v3_BUPR_SETuw_ByteOut
 Number_Ext_Functions++
 		global	_v3_BUPR_SETuw_ByteError
 Number_Ext_Functions++
 		global	_v3_BUPR_SETuw_BufFull
 Number_Ext_Functions++
 		global	_v3_BUPR_INI
 Number_Ext_Functions++
 		global	_v3_BUPR_SETdw_wfSendMessage1
 Number_Ext_Functions++
 		global	_v3_BUPR_GETdw_AdrRequestW
 Number_Ext_Functions++
 		global	_v3_BUPR_SETdw_wAddress
 Number_Ext_Functions++
 		extern	_v4_TASK_SETuw_ReqBu
 		extern	_v4_TASK_SETuw_On
 		extern	_v4_TASK_SETuw_Off
 		extern	_v4_TASK_SETuw_Lock
 		extern	_v4_TASK_SETuw_UnLock
 		extern	_v4_TASK_SETuw_Reset
 		extern	_v4_TASK_SETuw_wChannelCom
 	_v3_BUPR		idata
 	_v3_BUPR#v(0)	res	0
	Temp			res		1
	Buffer_In_00	res		MAXNUMBERBYTE
	Buffer_Out_00	res		MAXNUMBERBYTE
	Newbyte_In		res		1
	Oldbyte_In		res		1
	TooOldbyte_In	res		1
	Newbyte_Out		res		1
	Oldbyte_Out		res		1
	TooOldbyte_Out	res		1
	Number_In		res		1
	Number_Out		res		1
	Checksum_In		res		1
	Checksum_Out	res		1
	Tr_Temp			res		1
	Command			res		1
	Buffer_Temp		res		3
	Number_Out_Max	res		1
	Number_In_Max	res		1
	Address			res		1
Object	code
_v#v(HERE)_BUPR_INI:
			retlw	VOID
_v#v(HERE)_BUPR_SETdw_wfSendMessage1; (byte w,mass FSR0/void)
 		banksel	THIS#v(0)
	movwf	Number_Out_Max
	movlw	0x89
	movwf	Buffer_Out_00+3
	clrf	Number_Out			; определение длины
	lfsr	1,Buffer_Out_00+4
	movf	Number_Out_Max,w
_Copy_Loop2:
	movff	POSTINC0,POSTINC1
	addlw	-1
	bnz		_Copy_Loop2
	movlw	5
	addwf	Number_Out_Max,f
	clrf	Number_Out
	movff	Number_Out,Buffer_Out_00
	movff	Number_Out_Max,Buffer_Out_00+1
	movf	Address,w
	movwf	Buffer_Out_00+2
	clrf	Oldbyte_Out
	clrf	TooOldbyte_Out
	movlw	0xAA
	movwf	Newbyte_Out
 	goto	_v#v(DOWN)_PIO_SETdw_wUart1StartTx
_v#v(HERE)_BUPR_GETdw_AdrRequestW; (void/byte)
 	call	_v#v(DOWN)_PIO_SETdw_AdrLoadW
			return
_v#v(HERE)_BUPR_SETdw_wAddress; (byte/void)
 		banksel	THIS#v(0)
			movwf	Address
			retlw	VOID
_v#v(HERE)_BUPR_SETuw_ByteError; (void/void)
 		banksel	THIS#v(0)
 	call	_v#v(DOWN)_PIO_SETdw_wLedAlrOn
_BUPR_ByteError:
			clrf	Number_In_Max
			clrf	Newbyte_In
			clrf	Oldbyte_In
			clrf	TooOldbyte_In
			clrf	Number_In
			retlw	VOID
_v#v(HERE)_BUPR_SETuw_BufFull; (void/void)		
 		banksel	THIS#v(0)
 	call	_v#v(DOWN)_PIO_SETdw_Uart1Antifreeze
 	goto	_BUPR_ByteError
			retlw	VOID
_v#v(HERE)_BUPR_SETuw_wByteIn; (byte W/void)
 		banksel	THIS#v(0)
			movwf	Newbyte_In
			movf	TooOldbyte_In,w					; детектирование правдоподобия преамбулы
			xorlw	0xAA
			bnz		_Non_header
			movf	Oldbyte_In,w
			xorlw	0x55
			bnz		_Non_header
_Header:
			movlw	MAXNUMBERBYTE
			cpfslt	Newbyte_In
 	goto	_BUPR_ByteError
			movf	Newbyte_In,w
			movwf	Number_In
			movwf	Number_In_Max			; определение длины
			clrf	Checksum_In	
_Non_header:
			movf	Number_In,f						; диагностика необходимости приема
			bz		_cash_In_IRQ		
_NextByte:
			movf	Oldbyte_In,w					; детектирование правдоподобия преамбулы
			xorlw	0xAA
			bnz		_ordin
			movf	Newbyte_In,w
			bz		_cash_In_IRQ
 	goto	_BUPR_ByteError
_ordin:
			decfsz	Number_In,f							; уже принятый байт в буфер
			bra		_Cash_In							; декремент счетчика принимаемых данных
_EOFbyte:	
			movf	Newbyte_In,w
			cpfseq	Checksum_In
			bra		_cash_In_IRQ
 	goto	_BUPR_Com_Process
_Cash_In:	
			lfsr	1,Buffer_In_00-1
			movf	Number_In,w
			subwf	Number_In_Max,w
			movff	Newbyte_In,PLUSW1
			movf	Newbyte_In,w
			addwf	Checksum_In,f
_cash_In_IRQ:
			movff	Oldbyte_In,TooOldbyte_In
			movff	Newbyte_In,Oldbyte_In			; перевод принятого байта из разряда нового в старые
			retlw	VOID
_BUPR_Com_Process
 		banksel	THIS#v(0)
			movf	Address,w
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem	; retlw	VOID
			movlw	0x2F
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem2	; retlw	VOID
			movlw	0xAF
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem2	; retlw	VOID
			retlw	VOID
_priem:
			lfsr	0,Buffer_In_00+2
			movlw	0x09
			xorwf	INDF0,w
			btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_ReqBu
_priem2:
			lfsr	0,Buffer_In_00+2
			movlw	0x01	; 0xA0
			xorwf	INDF0,w
			btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_On
			movlw	0x02	; 0xA1
			xorwf	INDF0,w
			btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_Off
			movlw	0x04	; 0x1F
			xorwf	INDF0,w
			btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_Lock
			movlw	0x03	; 0x1E
			xorwf	INDF0,w
			btfss	STATUS,Z
			bra		_rest_search
			lfsr	0,Buffer_In_00+3
			swapf	INDF0,w
			andlw	b'00001111'
			mullw	d'10'
			movf	INDF0,w
			andlw	b'00001111'
			addwf	PRODL,w
 	call	_v#v(UP)_TASK_SETuw_wChannelCom
 	goto	_v#v(UP)_TASK_SETuw_UnLock
_rest_search:
			movlw	0x05	; 0x37
			xorwf	INDF0,w
			btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_Reset
			retlw	VOID
			
_v#v(HERE)_BUPR_SETuw_ByteOut; (void/void)
 		banksel	THIS#v(0)
	movff	Oldbyte_Out,TooOldbyte_Out
	movff	Newbyte_Out,Oldbyte_Out			; перевод принятого байта из разряда нового в старые
	tstfsz	Number_Out_Max
	bra		_transmit
	movf	Oldbyte_Out,w									; 
	xorlw	0xAA											; 
	bnz		lbl_notChecksumAA								; 
	movlw	0x00											; 
	movwf	Newbyte_Out										; 
	bra		_cash_Out_IRQ									; 
lbl_notChecksumAA:													; 
	tstfsz	Number_Out
	bra		_DecandcCash
 	goto	_v#v(DOWN)_PIO_SETdw_Uart1StopTx
_transmit:
	movf	TooOldbyte_Out,w	;  детектирование правдоподобия преамбулы
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
	movlw	0x00		; 
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
 	goto	_v#v(DOWN)_PIO_SETdw_wUart1NextTx
			end
