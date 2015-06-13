;/**
;  HOT- ����
;
;  ������ ����� Usart ������ ���
;*/
;NOTE:	����������� ���� ���������� ��������� T=85
#include <../headers/hot.inc>
mObject_var	_v2_HOT

home_data	res	0


Obj_HOT	code

;// �������������
_HOT_SET_Ini:
	mObject_sel	THIS
	movlw	b'10001110'		;��������� ���� �����: ������� �������(,bit<0>) � �������� �������� ���� (bit<1>)
	movwf	DSFLAG			;DS1820PAR
	clrf	ctERR_DS		; +040310 ����� �������� ERROR DS
	
	; !!���� ��� ���� ���������� �������������� ���������
	banksel	waveFormTemper
	clrf	hot_readOnly_zero
	return

;// �/� ���������� � ������ ������������� ������ � DS1820PAR
;// ������ ����������� � �������, ����� ���������� �������
;_B UM_SETdw_Temper
;	_v#v(HERE)_T ASK_HLTuw_DataRefreshWait;(void/void)<<<DataRefreshWait
;		_C LK_HLTuw_Tick; ���������� ���������� �������
_HOT_SET_DS1821:
_DSread
_DSini_status
	mObject_sel	THIS
	btfsc	DSFLAG,0	;INI flag resetting		
		;�������� ��������� ������������ DS (�� 2-10�� - �� 5���)
	bra		out_DSini_status 
	clrf	DSTEMP		;��������� T=0 C

	incf	ctERR_DS,f	;+040310	��������� �������� ������ 
	movlw	4			;+040310
	cpfslt	ctERR_DS	;+040310  	���� 4 ���� ������?

	movff	DSTEMP,	LavaData ;  + 12	;+310110

out_DSini_status:
	btfsc	DSFLAG,3	; ++060910
	bra		_Testo
	btfsc	DSFLAG,1	;0- ���� �������� ������������� ��������������
	bra		_Tstart
	return
end




