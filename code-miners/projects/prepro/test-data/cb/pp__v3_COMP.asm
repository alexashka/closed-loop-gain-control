#-*- coding: utf-8 -*-
constant	HERE=3
#define		_v3_COMP	_v3_COMP
#define		THIS	_v3_COMP
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
 		extern	setZ0
 		extern	setZ1
 		extern	setZ2
 		extern	setZ3
 		extern	pA_pub_setGainDigAtt
 		extern	_v2_PIO_SETdw_I2CMIntStart
#define MOVE_CODE
 		extern	pA_pub_saveGain
 		extern	_v2_PIO_SETdw_wUart2StartTx
 		extern	_v2_PIO_SETdw_wUart2NextTx
 		extern	_v2_PIO_SETdw_Uart2StopTx
 		extern	_v2_PIO_SETdw_Uart2Antifreeze
 		global	_v3_COMP_SETuw_wByteIn
 Number_Ext_Functions++
 		global	_v3_COMP_SETuw_ByteOut
 Number_Ext_Functions++
 		global	_v3_COMP_SETuw_ByteError
 Number_Ext_Functions++
 		global	_v3_COMP_SETuw_BufFull
 Number_Ext_Functions++
 		global	_v3_COMP_INI
 Number_Ext_Functions++
 		global	_v3_COMP_SETdw_wfSendMessage1
 Number_Ext_Functions++
 		global	_v3_COMP_SETdw_wfSendMessage2
 Number_Ext_Functions++
 		global	_v3_COMP_SETdw_wfSendMessage3
 Number_Ext_Functions++
 		global	_v3_COMP_SETdw_wfSendMessage4
 Number_Ext_Functions++
 		extern	_v4_TASK_SETuw_On
 		extern	_v4_TASK_SETuw_Off
 		extern	_v4_TASK_SETuw_Lock
 		extern	_v4_TASK_SETuw_UnLock
 		extern	_v4_TASK_SETuw_Reset
 		extern	_v4_TASK_SETuw_Req1
 		extern	_v4_TASK_SETuw_Req2
 		extern	_v4_TASK_SETuw_Req3
 		extern	_v4_TASK_SETuw_Req4
 		extern	_v4_TASK_SETuw_wTuneCom
 		extern	_v4_TASK_SETuw_wChannelCom
#define PRE_APM_MSG_LEN	10
#define OK_I_MSG_LEN	10
#define IN_TO_PORT0	0x00 	; Output Port 0 Read/write byte 1111 1111
#define IN_TO_PORT1	0x01 	; Output Port 1 Read/write byte 1111 1111
#define OUT_TO_PORT0	0x02 	; Output Port 0 Read/write byte 1111 1111
#define OUT_TO_PORT1 	0x03 	; Output Port 1 Read/write byte 1111 1111
#define CONF_PORT0 		0x06	; Configuration Port 0 Read/write byte 1111 1111 iiii_iiii
#define CONF_PORT1 		0x07	; Configuration Port 1 Read/write byte 1111 1111 iiii_iiii
#define ADD_ATT 		0xE8 ;  b'1110_1000'
#define ADDR_DET 		0x68
#define ADDR_DET_RD		0x69
	constant ADROK1	=	0x72;  0x72
	constant ADROK2	=	0x72;  0x74
	constant ADROK3	=	0x72;  0x76
	constant ADROK4	=	0x72
#define ADDR_JUMPER_WR 	0xEA
#define ADDR_JUMPER_RD 	0xEB
#define CMD_FROM_PC_GET_12	0x01
#define TYPE_MSG_GET_NFO_ABOUT_MIP	0x02
#define TYPE_MSG_CPUX_LOG	0x05
#define TYPE_MSG_VALUE_ATT_GAIN		0x06
#define TYPE_MSG_CMD 	0x03
#define TYPE_MSG_CMD_SET_ATT_STAGE1	0x40
#define RST_PARAMETERS 	0x37  ; // комманда сброса параметров
#define OPEN_MIP 	0x1E
DAC_A_LSB		equ		0x10
DAC_B_LSB		equ		0x12
DAC_C_LSB		equ		0x14
DAC_D_LSB		equ		0x16
CONTROL1		equ		0x18	;  Control Configuration 0
CONTROL2		equ		0x19	;  Control Configuration 1
CONTROL3		equ		0x1A	;  Control Configuration 2
INT_MASK1		equ		0x1D
DAC_CONFIG		equ		0x1B
LDAC_CONFIG		equ		0x1C
constant	WRITECOMMAND	=	0x90
constant	READCOMMAND		=	0x91
AD8402_CHA	equ		b'00000000'
AD8402_CHB	equ		b'01000000'
AD8522_CHA	equ		b'10100000'
AD8522_CHB	equ		b'11000000'
constant SPEED=10; 	;  cкоростная прокрутка?;  coding : UTF-8
#define		bRSPI		PORTA,4	;  091110
#define		bRST		PORTB,0
#define 	bLENREGD27	PORTB,1
#define		bZP			TRISB,2
#define 	bZP_PORT	PORTB,2
#define		bZAP		PORTB,3
#define		bRSB1		PORTB,3
#define		bDE			PORTC,0
#define		bRB			PORTD,0
#define		bLDB		PORTD,2
#define		bCS1		PORTD,3
#define		bSDI2		PORTD,4
#define		bSDO2		PORTD,5
#define		bSCK2		PORTD,6
#define		bCS3		PORTE,0
#define		bLD			PORTE,1
#define 	bLENREGD24	PORTE,4
#define		bCS2		PORTE,5
#define		bDC3		PORTE,6 ;  091110 PORTB,5
#define		bALMP		PORTH,2
#define 	bSELREGD24	PORTH,3
#define 	bSELREGD27	PORTH,3
#define		bCS4		PORTH,4	;  091110
#define		bUALR		PORTH,5	;  091110
#define		bRSU		PORTH,6	;  091110
#define		bD_A		PORTH,7	;  091110 PORTF,4
#define OBTAINED 	0x01
#define NO_OBTAINED 0x00
 	_v3_COMP		idata
 	_v3_COMP#v(0)	res	0
	Temp			res		1
	Buffer_In_00	res		MAXNUMBERBYTE  ;  было 88 в user_modes
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
	Number_In_Max	res		1  ;  это же резервированвие, а где присвоение значений?
	State_setGainAtt 	res 	1  
Object	code
_v#v(HERE)_COMP_INI:
	movlw 	NO_OBTAINED  ; // комманду о установке осл. атт. не получали
	movwf	State_setGainAtt
	retlw	VOID
_v#v(HERE)_COMP_SETdw_wfSendMessage1; (byte w,mass FSR0/void)
 		banksel	THIS#v(0)
	movwf	Number_Out_Max	;  размер сообщения
	movlw	CMD_FROM_PC_GET_12
	bra		_Mess_send
_v#v(HERE)_COMP_SETdw_wfSendMessage2; (byte w,mass FSR0/void)
 		banksel	THIS#v(0)
	movwf	Number_Out_Max	
	movlw	0x02
	bra		_Mess_send
_v#v(HERE)_COMP_SETdw_wfSendMessage3; (byte w,mass FSR0/void)
 		banksel	THIS#v(0)
	movwf	Number_Out_Max
	movlw	0x04
	bra		_Mess_send
_v#v(HERE)_COMP_SETdw_wfSendMessage4; (byte w,mass FSR0/void)
 		banksel	THIS#v(0)
	movwf	Number_Out_Max
	movlw	0x05
	bra		_Mess_send
_Mess_send:	
	movwf	Buffer_Out_00+2
	clrf	Number_Out			; определение длины
	lfsr	1,	Buffer_Out_00+3		; // еще один буффер - Massn->Buffer_Out_00
	movf	Number_Out_Max,w
_Copy_Loop2:
	movff	POSTINC0,POSTINC1 	;  использует FSR регистры для адресации
	addlw	-1
	bnz		_Copy_Loop2  ; // перекачка буффера
	movlw	4
	addwf	Number_Out_Max,f
	clrf	Number_Out
	movff	Number_Out_Max,Buffer_Out_00
	movlw	0x9F
	movwf	Buffer_Out_00+1
	clrf	Oldbyte_Out
	clrf	TooOldbyte_Out
	movlw	0xAA
	movwf	Newbyte_Out
 	goto	_v#v(DOWN)_PIO_SETdw_wUart2StartTx
_v#v(HERE)_COMP_SETuw_ByteError; (void/void)
 		banksel	THIS#v(0)
_COMP_ByteError:
			clrf	Number_In_Max
			clrf	Newbyte_In
			clrf	Oldbyte_In
			clrf	Number_In
			retlw	VOID
_v#v(HERE)_COMP_SETuw_BufFull; (void/void)		
 		banksel	THIS#v(0)
 	call	_v#v(DOWN)_PIO_SETdw_Uart2Antifreeze
 	goto	_COMP_ByteError
			retlw	VOID
_v#v(HERE)_COMP_SETuw_wByteIn; (byte W/void)
 		banksel	THIS#v(0)
	movwf	Newbyte_In  ;  ? сохраняем в ОЗУ
	movf	TooOldbyte_In,w		;  детектирование правдоподобия преамбулы
	xorlw	0xAA
	bnz		_Non_header  ;  если не равно
	movf	Oldbyte_In,w
	xorlw	0x55
	bnz		_Non_header
			
_Header:
	movlw	MAXNUMBERBYTE  ;  максимальный размер буффера?
	cpfslt	Newbyte_In  
 	goto	_COMP_ByteError
	movf	Newbyte_In,w
	movwf	Number_In
	movwf	Number_In_Max	; определение длины
	clrf	Checksum_In	;  сброс контрольной суммы?
_Non_header:
	movf	Number_In,f		; диагностика необходимости приема
	bz		_cash_In_IRQ		
_NextByte:
	movf	Oldbyte_In,w	; детектирование правдоподобия преамбулы
	xorlw	0xAA
	bnz		_ordin
	movf	Newbyte_In,w
	bz		_cash_In_IRQ
 	goto	_COMP_ByteError
_ordin:
	decfsz	Number_In,f		; уже принятый байт в буфер
	bra		_Cash_In		; декремент счетчика принимаемых данных
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
	movff	Newbyte_In,Oldbyte_In	;  перевод принятого байта из разряда нового в старые
	retlw	VOID
_COMP_Com_Process	;  ? это метка или что, ! судя по всему да или функция
 		banksel	THIS#v(0)
	movlw	0x1F	;  магическое число из протокола обмена
	xorwf	Buffer_In_00+1,w	;  Buffer_In_00 - указатель?
	btfss	STATUS,Z	;  ветвление, вернее обход
	retlw	VOID
	lfsr	0,Buffer_In_00+2	;  перемещения указателя чтения?
	movlw	0x01	;  !посылает если нет связи
	xorwf	INDF0,w	;  проверка комманды, switch
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
	movlw	TYPE_MSG_CPUX_LOG 	; //0x05
	xorwf	INDF0,w
	btfsc	STATUS,Z
 	goto	_v#v(UP)_TASK_SETuw_Req4
	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass  ; // Если не оно, обходим обработку 
	movf 	State_setGainAtt, w	
	bz _skipOut  
	lfsr	0, Buffer_In_00+3
	movf	INDF0, 	w
 	call pA_pub_setGainDigAtt
	movff	Buffer_In_00+3, WREG
 	call pA_pub_saveGain
	movlw 	NO_OBTAINED
	movwf	State_setGainAtt
	lfsr	0,	Buffer_In_00+2
_skipOut:	; // В любом случае выходим. Дальше идти смысла нет
	return  
_bypass:  ; // продолжаем анализировать тип сообщения
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
_bypassSetState:	; // продолжаем
	movlw	0xA0  
	xorwf	INDF0,w		;  сравниваются данные по косвенному адресу и аккамулятор
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
	cpfsgt	INDF0	;  проверка границы - защита от случайных данных
	bra		_Tune
	movf	INDF0,w
	addlw	d'21'-0x6B
 	goto	_v#v(UP)_TASK_SETuw_wChannelCom
_Tune:			
	movf	INDF0,w
 	goto	_v#v(UP)_TASK_SETuw_wTuneCom
_v#v(HERE)_COMP_SETuw_ByteOut; (void/void)
 		banksel	THIS#v(0)
	movff	Oldbyte_Out, TooOldbyte_Out
	movff	Newbyte_Out, Oldbyte_Out		;  перевод принятого байта из разряда нового в старые
	tstfsz	Number_Out_Max
	bra		_transmit
	tstfsz	Number_Out
	bra		_DecandcCash
 	goto	_v#v(DOWN)_PIO_SETdw_Uart2StopTx
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
	movf	Newbyte_Out,w  ; // загружаем в аккамулятор байт для передачи
			
 	goto	_v#v(DOWN)_PIO_SETdw_wUart2NextTx
	end
