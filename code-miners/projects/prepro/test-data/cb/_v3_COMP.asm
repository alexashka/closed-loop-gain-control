;/**
;  uart2 - yes
;  ������ �������� ��� ������������ ������ ������� � �� (COMPuter)
;  ���������� ������ ��������. ��������, � ���������� ��������
; ? ��� ������ �������� ��� ������ � ������
; _COMP - ������� ���������� � ���� �����
;*/
;!FAIL
	;// ���������� �� �������, ���-�� ��������
	;// ������ ������ ������ ������ ��������
	;// � ������ ���� ����������������
	;//
    ;forAttCall res 1
	;//
	;lfsr	0, Buffer_In_00+3	;// ����� �������, �� ����� �����
	;movf	INDF0, 	w
	;movwf 	forAttCall
	;incf 	forAttCall
	;movf 	forAttCall, w
    ;// ����� �������
	;movf 	forAttCall, w	; ������ �������� �����

;************************************************************
;	������ ������������ ���
;************************************************************
	constant	HERE=3
#define		_v3_COMP	_v3_COMP
#define		THIS	_v3_COMP
#include	<headers\user_modes.inc>
#include 	<headers\Const.inc>

mObject_var	_v3_COMP

	Temp			res		1
	
	; ����������� ������� ��� ������ � ��������, ���?
	Buffer_In_00	res		MAXNUMBERBYTE  ; ���� 88 � user_modes
	Buffer_Out_00	res		MAXNUMBERBYTE
	
	; states ������������ ������ ������
	Newbyte_In		res		1
	Oldbyte_In		res		1
	TooOldbyte_In	res		1
	; ��������� ��� ������ ������ �� ��
	Newbyte_Out		res		1
	Oldbyte_Out		res		1
	TooOldbyte_Out	res		1
	; end states
	
	Number_In		res		1
	Number_Out		res		1
	Checksum_In		res		1
	Checksum_Out	res		1
	Tr_Temp			res		1
	Command			res		1
	Buffer_Temp		res		3
	Number_Out_Max	res		1
	Number_In_Max	res		1  ; ��� �� ���������������, � ��� ���������� ��������?

	;// States
	;// ���� �� �������� ��������� �������� �����������?
	State_setGainAtt 	res 	1  
	#define OBTAINED 	0x01
	#define NO_OBTAINED 0x00
	;// States
	
	;// Types Msgs
#define TYPE_MSG_GET_NFO_ABOUT_MIP	0x02
#define TYPE_MSG_CPUX_LOG	0x05
	;// ������ ������, ����������� �� �� : 
	;//  0xAA
	;//    0x55
	;//	 // ��� ���������� ������ ������� ��������� ���� ������?
	;//      0xXX - ����� ���������
	;//		   0x1F - 
	;//		     0xXX - ��� ��������� TYPE_MSG
	;//			   0xXX - �������������� ���������� ��� ���������
   	;//			     0xXX - �RC
#define TYPE_MSG_VALUE_ATT_GAIN		0x06
		;// ! � ���������� ������� ���������� ����������!! 
		;// ! ����� �������������, ��� �� ��������� �� ���� ������ ��������
		;// �������� ��������� ������ ���� �����, �����, ��� ����������, 
		;//   ��� �������� ��������. � ���� �������� �������� �����������, �����
		;//   ���� ������� �� ��������. 
#define TYPE_MSG_CMD 	0x03
#define TYPE_MSG_CMD_SET_ATT_STAGE1	0x40
#define RST_PARAMETERS 	0x37  ;// �������� ������ ����������
#define OPEN_MIP 	0x1E
	;// Types Msgs



Object code
_v#v(HERE)_COMP_INI:
;	mObject_sel	THIS
	;// ������������� ��������� ���������
	movlw 	NO_OBTAINED  ;// �������� � ��������� ���. ���. �� ��������
	movwf	State_setGainAtt
	;//
	retlw	VOID

;/// /// /// Downward methodes
;///
;/// ������ ����������! ���-�� �������� ����� ������� ������ ��� ��������
_v#v(HERE)_COMP_SETdw_wfSendMessage1;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x01
	bra		_Mess_send

;// ���������� � ���?
_v#v(HERE)_COMP_SETdw_wfSendMessage2;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x02
	bra		_Mess_send

_v#v(HERE)_COMP_SETdw_wfSendMessage3;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x04
	bra		_Mess_send
	
_v#v(HERE)_COMP_SETdw_wfSendMessage4;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x05
	bra		_Mess_send

; �������� ���������	
; ����� ����� ��� ���� ������� ���������� ����
_Mess_send:	
	movwf	Buffer_Out_00+2
	clrf	Number_Out			;����������� �����
	lfsr	1,	Buffer_Out_00+3		;// ��� ���� ������ - Massn->Buffer_Out_00
	;// +0 +1 +2 [+3 ...] 
	
	;// ���� : �������� ��������
	movf	Number_Out_Max,w
_Copy_Loop2:
	movff	POSTINC0,POSTINC1 	; ���������� FSR �������� ��� ���������
	addlw	-1
	bnz		_Copy_Loop2  ;// ��������� �������
	;// ����������� ������ ���������
	
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
	
	;// ���������� ��������� ����
	;// ����� ����� �� ����������� ������������ ���
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart2StartTx;(byte W/void)

;/// 
;///
;/// /// ///


;/// /// /// Upward methodes
;///
;/// 
_v#v(HERE)_COMP_SETuw_ByteError;(void/void)
			mObject_sel	THIS
_COMP_ByteError:
			clrf	Number_In_Max
			clrf	Newbyte_In
			clrf	Oldbyte_In
			clrf	Number_In
			retlw	VOID

_v#v(HERE)_COMP_SETuw_BufFull;(void/void)		
			mObject_sel	THIS
			mSET	_v#v(DOWN)_PIO_SETdw_Uart2Antifreeze;(void/void)
			mSlideTo	_COMP_ByteError
			;r etlw	VOID

;/// /// ///
;///
;/// ����� � ����������� ��������, � ��� �� ������� �� ���
;// ������������� �����
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	...	!	TooOldbyte_In	!	Oldbyte_In	!	Newbyte_In	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Newbyte_In - ����� ���� � ��������
; ! � ������������ �������� ����
; AA 55 1F ���_��������� ���_�������� CRC
_v#v(HERE)_COMP_SETuw_wByteIn;(byte W/void)
	mObject_sel	THIS
	movwf	Newbyte_In  ; ? ��������� � ���
	movf	TooOldbyte_In,w		; �������������� ������������� ���������
	xorlw	0xAA
	bnz		_Non_header  ; ���� �� �����
	movf	Oldbyte_In,w
	xorlw	0x55
	bnz		_Non_header
			
_Header:
	movlw	MAXNUMBERBYTE  ; ������������ ������ �������?
	cpfslt	Newbyte_In  
	mSlideTo	_COMP_ByteError		
	movf	Newbyte_In,w
	movwf	Number_In
	movwf	Number_In_Max	;����������� �����
	clrf	Checksum_In	; ����� ����������� �����?
	
_Non_header:
	movf	Number_In,f		;����������� ������������� ������
	bz		_cash_In_IRQ		
	
_NextByte:
	movf	Oldbyte_In,w	;�������������� ������������� ���������
	xorlw	0xAA
	bnz		_ordin
	movf	Newbyte_In,w
	bz		_cash_In_IRQ
	mSlideTo	_COMP_ByteError
	
_ordin:
	decfsz	Number_In,f		;��� �������� ���� � �����
	bra		_Cash_In		;��������� �������� ����������� ������

_EOFbyte:	
	movf	Newbyte_In,w
	cpfseq	Checksum_In
	bra		_cash_In_IRQ
	mSlideTo	_COMP_Com_Process  ; g oto � ���������?
	
_Cash_In:	
	lfsr	1,Buffer_In_00-1
	movf	Number_In,w
	subwf	Number_In_Max,w
	movff	Newbyte_In,PLUSW1
	movf	Newbyte_In,w
	addwf	Checksum_In,f
	
_cash_In_IRQ:
	movff	Oldbyte_In,TooOldbyte_In
	movff	Newbyte_In,Oldbyte_In	; ������� ��������� ����� �� ������� ������ � ������
	retlw	VOID

; ! � ���������� ������ �����������
; ����� ���� ��������
_COMP_Com_Process	; ? ��� ����� ��� ���, ! ���� �� ����� �� ��� �������
	mObject_sel	THIS

	movlw	0x1F	; ���������� ����� �� ��������� ������
	xorwf	Buffer_In_00+1,w	; Buffer_In_00 - ���������?
	btfss	STATUS,Z	; ���������, ������ �����
	retlw	VOID

	lfsr	0,Buffer_In_00+2	; ����������� ��������� ������?
		;// Buffer_In_00+2 - ��������� �� ��� ���������
		;// Buffer_In_00+3 - ��������� �� ������ � ���������

;// ��������� ����� ��������� 01, 02, 04, 05, 06(ATT_NFO), 03(CMD)
; ������ �� �������. �� �����
; �������� �������� ������ �����, ����� ����� ��������
	movlw	0x01	; !�������� ���� ��� �����
	xorwf	INDF0,w	; �������� ��������, switch
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req1;(void/void) *

	;// ������ �������� ��������� ���������� � ���
	movlw	TYPE_MSG_GET_NFO_ABOUT_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req2;(void/void) *
		
		;//m GET		_v#v(DOWN)_INFO_GETdw_ReqInfoForComp2WF;(void/byte,mass FSR0)
		;	...movlw	31  ;// ����� �������!
		;	lfsr	0,Mass2...  ;// FSR0
		;// ���������� ��������� �� ��
		;//m SlideTo	_v#v(DOWN)_COMP_SETdw_wfSendMessage2;(byte,mass FSR0/void)
		; 	movwf	Number_Out_Max
		; 	movlw	0x02
		; 	b ra		_Mess_send  ;// lfsr	0,Mass2 - ��� ����������?
		; 		m SlideTo	_v#v(DOWN)_PIO_SETdw_wUart2StartTx;(byte W/void)
			
	movlw	0x04
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req3;(void/void) *
	
	movlw	TYPE_MSG_CPUX_LOG 	;//0x05
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req4;(void/void) *
; ������ �� �������

;/// /// ///
;///
;/// (igor 170412)
	;// ������ �������������� ��� ���������, ������� 
	;//   ����� ���������� �� ���������� ���.
	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass  ;// ���� �� ���, ������� ��������� 
	
	;// ��������� ��������� �������� 
	movf 	State_setGainAtt, w	
	
	;// �������� �� ���� �������� - ��������� �������. �������.
	;//  ������� ���� ��� ����������, �� ����� �����. 
	bz _skipOut  

	;// �������� ������� ���������� �� ����������
	;// ��������� ���������� �����������, ������ �� ������ ������� ���� ����!
	;// i2c send
	call    _v#v(DOWN)_PIO_SETdw_I2CMIntStart	; 150811 ������������� �����������
	movlw 	ADD_ATT
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 
	movlw 	OUT_TO_PORT1  ;//OUT_TO_PORT0?	;// ������ �� PORT 1 ������? ������ ��� �������� � �� 0x02?
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 

	;// ���������� ��������� ������ �������� ������� �� ��� ������
	;// ����� �������� ���������� �� ����� ���������
	;//   � ���������� ��� � �����������, � ����� � ��������������
	lfsr	0, Buffer_In_00+3
	movf	INDF0, 	w
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 

	;// ������� ���������
	call   _v#v(DOWN)_PIO_SETdw_I2CMIntStop 
	;/// i2c send

	;// ������ � EEPROM ����������� ����������
	lfsr	0, Buffer_In_00+3	;// ����� �������, �� ����� �����
	movf	INDF0, 	w
	call 	_v#v(HERE)_EC_SaveValAtt
	
	;// ��������� <- �� ��������
	movlw 	NO_OBTAINED
	movwf	State_setGainAtt
	
	;// ���������� ��������� ������ �������, ��� �������� � �� �����
	;//   �� ����� ���� �����
	lfsr	0,	Buffer_In_00+2

_skipOut:	;// � ����� ������ �������. ������ ���� ������ ���
	return  
	
_bypass:  ;// ���������� ������������� ��� ���������
;///
;///
;/// /// ///

;/// ��� ��������� - ��������
	movlw	TYPE_MSG_CMD	
	xorwf	INDF0,w
	btfss	STATUS,Z
	retlw	VOID
	lfsr	0,Buffer_In_00+3

;// igor 170412
;// ������ �� �������� ���������� � ������ ���������� � ���.?
;// ���� �� :
;//   ���� ��������� �� �������� ����������
;// 0x03 0x40 wait.. 0x03 value
;// C��� �������� �������� �� INDF0
	movlw	TYPE_MSG_CMD_SET_ATT_STAGE1	
	xorwf	INDF0,w
	;// ���� ���� (Z = 1), �� ��� ���
	;// Z=0, ��������� �� ������� - ������ ��� � �������
	bnz 	_bypassSetState
	;// �������� �� ������� �������� �������� ����� ����������
	;// ��������� <- ��������
	;// ����� � ���������, �� ����� ����� ���������������� ����������
	movlw 	OBTAINED 
	movwf	State_setGainAtt
	return
_bypassSetState:	;// ����������
;// igor 170412
	
;// ��������� ��� ���������� �������� (�� ��������)
	; �������� �������� ���������?
	movlw	0xA0  
	xorwf	INDF0,w		; ������������ ������ �� ���������� ������ � �����������
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_On;(void/void) * 

	; �������� �������� ����������?
	movlw	0xA1
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Off;(void/void) *

	;// �������� ���
	movlw	0x1F
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Lock;(void/void) *

	;// �������� ���
	movlw	OPEN_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_UnLock;(void/void) *

	;// �������� ���������
	movlw	RST_PARAMETERS
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Reset;(void/void) *
	

; ����� ����� ��������� ������� ������ �����
;// � ����� ������ �������?
	movlw	0x6B-1
	cpfsgt	INDF0
	bra		_Tune
	movf	INDF0,w
	addlw	d'21'-0x6B
	mSlideTo	_v#v(UP)_TASK_SETuw_wChannelCom;(byte/void) 			


_Tune:	;// ��������� ������ ���������� �������
	movf	INDF0,w
	mSlideTo	_v#v(UP)_TASK_SETuw_wTuneCom;(byte/void) *
;/// ���������� ��������� �����
;///
;/// /// ///


;/// /// ///
;///
;/// ������ �� ������� �������� ������ �� ����. ����� ������
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	...	!	TooOldbyte_Out	!	Oldbyte_Out	!	Newbyte_Out	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_v#v(HERE)_COMP_SETuw_ByteOut;(void/void)
	mObject_sel	THIS
	movff	Oldbyte_Out, TooOldbyte_Out
	movff	Newbyte_Out, Oldbyte_Out		; ������� ��������� ����� �� ������� ������ � ������
	tstfsz	Number_Out_Max
	bra		_transmit
	tstfsz	Number_Out
	bra		_DecandcCash
	;// ������ ���� re turn! ��������, �� ����������
	mSlideTo	_v#v(DOWN)_PIO_SETdw_Uart2StopTx;(void/void)	

_transmit:
	movf	TooOldbyte_Out,w	; �������������� ������������� ���������
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
	movf	Newbyte_Out,w  ;// ��������� � ����������� ���� ��� ��������
			
	;// �������� ���������� ����� - r eturn ������!
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart2NextTx;(byte W/void)
;/// /// ///

	end
	