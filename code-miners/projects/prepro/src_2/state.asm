#include "../headers/user_modes.inc"
#include "../headers/protocol_exchange.ink"
#include "../headers/BoardMapping.h"
#include "info.h"

;; Import
; Data
extern g_summaryDataArray

;;Export
; Code
global state_CheckVoltageAlrm;(?/?)

ram_info	idata_acs
	tempL	res	1
	tempH	res	1

Obj_INFO code
	
; �������� ������ �� ���
state_CheckVoltageAlrm;(?/?)
	movff	g_summaryDataArray+4,tempL
	movff	g_summaryDataArray+5,tempH

	bcf	STATUS,C,0
	rrcf	tempH,f,0		;������� � 8-�� ������ ������
	rrcf	tempL,f,0
	
	bcf	STATUS,C,0
	rrcf	tempH,f,0
	rrcf	tempL,f,0

	; �������� ����������?
_lbl_mip_max_alarm
#ifdef	MODE_NEW_033	
	; +120312
	btfss	PORTB,0
		return
	bra		_lbl_mip_min_alarm	
#endif
	cpfsgt	tempL,0
		bra		_lbl_next_alr
	bsf		byteAlrms,5,0	;����� �� ��� max
	bra		_lbl_mip_min_alarm
_lbl_next_alr
#ifdef	MODE_3U
	movlw	d'220'	;43V ( d'220' -3U )
#endif
	cpfslt	tempL,0
		return

; �������� ����������?
_lbl_mip_min_alarm
	; ����� �� ���������� - �����������
	bsf	byteAlrms,3,0		;����� �� ���
	
	btfss	aliasStateByte,0		;�������� ���������� ��������
		return		;������� ���� �������		
	bsf		g_bLockAtt_leg		;(bsf	PORTB,2	����)	;������� ����������
	call	sdr_LockAndShiftOff;(?/?)		;_OFF
	return
end