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
	
; проверка отказа по МИП
state_CheckVoltageAlrm;(?/?)
	movff	g_summaryDataArray+4,tempL
	movff	g_summaryDataArray+5,tempH

	bcf	STATUS,C,0
	rrcf	tempH,f,0		;перевод в 8-ми битный формат
	rrcf	tempL,f,0
	
	bcf	STATUS,C,0
	rrcf	tempH,f,0
	rrcf	tempL,f,0

	; Проверка превышения?
_lbl_mip_max_alarm
#ifdef	MODE_NEW_033	
	; +120312
	btfss	PORTB,0
		return
	bra		_lbl_mip_min_alarm	
#endif
	cpfsgt	tempL,0
		bra		_lbl_next_alr
	bsf		byteAlrms,5,0	;отказ по МИП max
	bra		_lbl_mip_min_alarm
_lbl_next_alr
#ifdef	MODE_3U
	movlw	d'220'	;43V ( d'220' -3U )
#endif
	cpfslt	tempL,0
		return

; Проверка проседания?
_lbl_mip_min_alarm
	; Отказ по напряжению - минимальный
	bsf	byteAlrms,3,0		;отказ по МИП
	
	btfss	aliasStateByte,0		;проверка запертости смещения
		return		;переход если заперто		
	bsf		g_bLockAtt_leg		;(bsf	PORTB,2	было)	;заперли аттенюатор
	call	sdr_LockAndShiftOff;(?/?)		;_OFF
	return
end