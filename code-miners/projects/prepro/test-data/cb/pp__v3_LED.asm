#-*- coding: utf-8 -*-
	constant	HERE=3
#define		THIS	_v3_LED
#define		_v3_LED		_v3_LED
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
 		extern	_v2_PIO_SETdw_wLedControl
 		extern	_v2_PIO_SETdw_wLedAlrOn
 		extern	_v2_PIO_SETdw_wLedAlrOff
 		global	_v3_LED_INI
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ComSendOn
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ComSendOff
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ReqSendOn
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ReqSendOff
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_BumLock
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_BumUnLock
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_AlarmOff
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_AlarmOn
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ExchOn
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_ExchOff
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_MipOn
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_MipOff
 Number_Ext_Functions++
 		global	_v3_LED_SETdw_fLedMode
 Number_Ext_Functions++
#define		bComSend	LedByte,0
#define		bReqSend	LedByte,1
#define		bBumLocking	LedByte,6
#define		bBumAlarm	LedByte,5  ;  alarm - тревога
#define		bBumExch	LedByte,7
#define		bBumMip		LedByte,2  ;  мощный? источник питания
#define		bBumWork	LedByte,3
#define		bBumFault	LedByte,4
 	_v3_LED		idata
 	_v3_LED#v(0)	res	0
	LedByte	res	1
	MipsLedMode		res	1
	WorkLedMode		res	1
	AlrmLedMode		res	1	;  alr - один байт
	FlashCounter	res	1
object	code
_v#v(HERE)_LED_INI
 		banksel	THIS#v(0)
	movlw	0xFF
	movwf	LedByte
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ComSendOn; (byte W/void)
 		banksel	THIS#v(0)
	bcf		bComSend
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ComSendOff; (byte W/void)
 		banksel	THIS#v(0)
	bsf	bComSend
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ReqSendOn; (byte W/void)
 		banksel	THIS#v(0)
	bcf		bReqSend
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ReqSendOff; (void/void)
 		banksel	THIS#v(0)
	bsf		bReqSend
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_BumLock; (void/void)
 		banksel	THIS#v(0)
	bsf		bBumWork; bBumLocking
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_BumUnLock; (void/void)
 		banksel	THIS#v(0)
	bcf		bBumWork; bBumLocking
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_AlarmOff; (void/void)
 		banksel	THIS#v(0)
	bsf		bBumFault; bBumAlarm
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_AlarmOn; (void/void)
 		banksel	THIS#v(0)
	bcf		bBumFault; bBumAlarm
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ExchOn; (void/void)
 		banksel	THIS#v(0)
	bcf		bBumExch
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_ExchOff; (void/void)
 		banksel	THIS#v(0)
	bsf		bBumExch
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_MipOn; (void/void)
 		banksel	THIS#v(0)
	bcf		bBumMip
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_MipOff; (void/void)
 		banksel	THIS#v(0)
	bsf		bBumMip
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
_v#v(HERE)_LED_SETdw_fLedMode; (*FSR0/void)
 		banksel	THIS#v(0)
	movff	POSTINC0,MipsLedMode
	movff	POSTINC0,WorkLedMode
	movff	POSTINC0,AlrmLedMode
	incf	FlashCounter,w
	andlw	b'01111111'
	iorlw	b'00000001'
	movwf	FlashCounter
	movf	FlashCounter,w
	andwf	MipsLedMode
	bsf		bBumMip
	btfss	STATUS,Z
	bcf		bBumMip
	movf	FlashCounter,w
	andwf	WorkLedMode
	bsf		bBumWork
	btfss	STATUS,Z
	bcf		bBumWork
	movf	FlashCounter,w
	andwf	AlrmLedMode
	bsf		bBumFault
	btfss	STATUS,Z
	bcf		bBumFault
	movf	LedByte,w
 	goto	_v#v(DOWN)_PIO_SETdw_wLedControl
 	return
	end
