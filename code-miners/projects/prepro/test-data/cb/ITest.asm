

Object	code

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
	cpfseq xxx	;!!!
	mSlideTo	_COMP_ByteError
	
_ordin:
	decfsz	Number_In,f		;��� �������� ���� � �����
	bra		_Cash_In		;��������� �������� ����������� ������

_EOFbyte:	
	movf	Newbyte_In,w
	cpfseq	Checksum_In
	bra		_cash_In_IRQ
	;mS lideTo	_COMP_Com_Process  ; g oto � ���������?
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
		
	movlw	0x04
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req3;(void/void) *
	
	movlw	TYPE_MSG_CPUX_LOG 	;//0x05
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req4;(void/void) *
; ������ �� �������

	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass2  ;// ���� �� ���, ������� ��������� 
	
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
	
_bypass2:  ;// ���������� ������������� ��� ���������
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

end