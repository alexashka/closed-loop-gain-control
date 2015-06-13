;/**
;  Есть отправка данных через uart1 - к/от вызбудителя
;*/

;************************************************************
;	Модуль обслуживания БУ
;************************************************************
#include <../headers/bupr_new.inc>

mObject_var	_v3_BUPR

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
;------------------------------------------------------------
_v#v(HERE)_BUPR_INI:
;			mObject_sel	THIS
			retlw	VOID

;************************************************************
;			vvvvv <Downward methodes> vvvvv
;************************************************************
_v#v(HERE)_BUPR_SETdw_wfSendMessage1;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x89
	movwf	Buffer_Out_00+3
	clrf	Number_Out			;определение длины
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
;	movlw	0x1F
	movf	Address,w
	movwf	Buffer_Out_00+2
	clrf	Oldbyte_Out
	clrf	TooOldbyte_Out
	movlw	0xAA
	movwf	Newbyte_Out
	; Отправляем байт начала
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart1StartTx;(byte W/void)

;------------------------------------------------------------
_v#v(HERE)_BUPR_GETdw_AdrRequestW;(void/byte)
			mSET	_v#v(DOWN)_PIO_SETdw_AdrLoadW;(VOID/byte W)
;			andlw	b'00011111'
			return
;------------------------------------------------------------
_v#v(HERE)_BUPR_SETdw_wAddress;(byte/void)
			mObject_sel	THIS
			movwf	Address
			retlw	VOID
;------------------------------------------------------------
;************************************************************
;				^^^^^ <Upward methodes> ^^^^^ 
;************************************************************
_v#v(HERE)_BUPR_SETuw_ByteError;(void/void)
			mObject_sel	THIS
			mSET	_v#v(DOWN)_PIO_SETdw_wLedAlrOn;(byte W/VOID)			
_BUPR_ByteError:
			clrf	Number_In_Max
			clrf	Newbyte_In
			clrf	Oldbyte_In
			clrf	TooOldbyte_In
			clrf	Number_In
			retlw	VOID
;------------------------------------------------------------
_v#v(HERE)_BUPR_SETuw_BufFull;(void/void)		
			mObject_sel	THIS
			mSET	_v#v(DOWN)_PIO_SETdw_Uart1Antifreeze;(void/void)
			mSlideTo	_BUPR_ByteError
			retlw	VOID
;------------------------------------------------------------			
_v#v(HERE)_BUPR_SETuw_wByteIn;(byte W/void)
;____________________________________________________________________
;	...	!	TooOldbyte_In	!	Oldbyte_In	!	Newbyte_In	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			mObject_sel	THIS
			movwf	Newbyte_In
			movf	TooOldbyte_In,w					;детектирование правдоподобия преамбулы
			xorlw	0xAA
			bnz		_Non_header
			movf	Oldbyte_In,w
			xorlw	0x55
			bnz		_Non_header
_Header:
			movlw	MAXNUMBERBYTE
			cpfslt	Newbyte_In
			mSlideTo	_BUPR_ByteError	
			movf	Newbyte_In,w
			movwf	Number_In
			movwf	Number_In_Max			;определение длины
			clrf	Checksum_In	
_Non_header:
			movf	Number_In,f						;диагностика необходимости приема
			bz		_cash_In_IRQ		
_NextByte:
			movf	Oldbyte_In,w					;детектирование правдоподобия преамбулы
			xorlw	0xAA
			bnz		_ordin
			movf	Newbyte_In,w
			bz		_cash_In_IRQ
			mSlideTo	_BUPR_ByteError
_ordin:
			decfsz	Number_In,f							;уже принятый байт в буфер
			bra		_Cash_In							;декремент счетчика принимаемых данных
_EOFbyte:	
			movf	Newbyte_In,w
			cpfseq	Checksum_In
			bra		_cash_In_IRQ
			mSlideTo	_BUPR_Com_Process
_Cash_In:	
			lfsr	1,Buffer_In_00-1
			movf	Number_In,w
			subwf	Number_In_Max,w
			movff	Newbyte_In,PLUSW1
			movf	Newbyte_In,w
			addwf	Checksum_In,f
_cash_In_IRQ:
			movff	Oldbyte_In,TooOldbyte_In
			movff	Newbyte_In,Oldbyte_In			;перевод принятого байта из разряда нового в старые
			retlw	VOID
;------------------------------------------------------------
;------------------------------------------------------------
_BUPR_Com_Process
			mObject_sel	THIS
;			movlw	0x1F
			movf	Address,w
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem	;retlw	VOID
			movlw	0x2F
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem2	;retlw	VOID
			movlw	0xAF
			xorwf	Buffer_In_00+1,w
			btfsc	STATUS,Z
			bra		_priem2	;retlw	VOID
			retlw	VOID

_priem:
			lfsr	0,Buffer_In_00+2

			movlw	0x09
			xorwf	INDF0,w
			btfsc	STATUS,Z
			mSlideTo	_v#v(UP)_TASK_SETuw_ReqBu;(void/void) *
_priem2:
			lfsr	0,Buffer_In_00+2

			movlw	0x01	;0xA0
			xorwf	INDF0,w
			btfsc	STATUS,Z
			mSlideTo	_v#v(UP)_TASK_SETuw_On;(void/void) *

			movlw	0x02	;0xA1
			xorwf	INDF0,w
			btfsc	STATUS,Z
			mSlideTo	_v#v(UP)_TASK_SETuw_Off;(void/void) *

			movlw	0x04	;0x1F
			xorwf	INDF0,w
			btfsc	STATUS,Z
			mSlideTo	_v#v(UP)_TASK_SETuw_Lock;(void/void) *

			movlw	0x03	;0x1E
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
			mSET	_v#v(UP)_TASK_SETuw_wChannelCom;(byte/void)
			mSlideTo	_v#v(UP)_TASK_SETuw_UnLock;(void/void) *
_rest_search:
			movlw	0x05	;0x37
			xorwf	INDF0,w
			btfsc	STATUS,Z
			mSlideTo	_v#v(UP)_TASK_SETuw_Reset;(void/void) *
			retlw	VOID

			
;------------------------------------------------------------
;____________________________________________________________________
;	...	!	TooOldbyte_Out	!	Oldbyte_Out	!	Newbyte_Out	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_v#v(HERE)_BUPR_SETuw_ByteOut;(void/void)
	mObject_sel	THIS
	movff	Oldbyte_Out,TooOldbyte_Out
	movff	Newbyte_Out,Oldbyte_Out			;перевод принятого байта из разряда нового в старые
	tstfsz	Number_Out_Max
	bra		_transmit

	; проверка итоговой Checksum_Out на = AA, подстановка следом 0х00 	;+andrey 070711
	movf	Oldbyte_Out,w									;
	xorlw	0xAA											;
	bnz		lbl_notChecksumAA								;
																	;
	movlw	0x00											;
	movwf	Newbyte_Out										;
	bra		_cash_Out_IRQ									;
	
lbl_notChecksumAA:													;
	tstfsz	Number_Out
	bra		_DecandcCash
	mSlideTo	_v#v(DOWN)_PIO_SETdw_Uart1StopTx;(void/void)
	
_transmit:
	movf	TooOldbyte_Out,w	; детектирование правдоподобия преамбулы
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
	;// отправляем
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart1NextTx;(byte W/void)
;------------------------------------------------------------
; _v#v(HERE)_BUPR_SETdw_Antifreeze;(void/void)
			; mObject_sel	THIS
			; mSlideTo	_v#v(DOWN)_PIO_SETdw_Uart1Antifreeze;(void/void)			
			; retlw	VOID
;------------------------------------------------------------
			end