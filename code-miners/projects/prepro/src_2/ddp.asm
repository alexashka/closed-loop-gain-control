; abs. : 
;	1. алгоритмы обработки полученных данных 
;	2. управление потоками данных(сбор и упаковка)
;
#include "../headers/user_modes.inc"
#include "../headers/protocol_exchange.ink"
#include "info.h"
extern state_CheckVoltageAlrm;(?/?)

global ddp_DoTermoCorrection;(w/void)
;; Export
; Danger!!
; имя ничего особо не говорящее и еще и !глобалное
global	 g_summaryDataArray
; Danger!!

; Code
global	ddp_SetArrayMaker;(?/?)

ram_ddp	idata_acs
	_idata_acs res 0
	_tmp_w	res	1;
	
	; связан или нет с инф. сообщение?
	 g_summaryDataArray	res LEN_INFO_MSG	; может здесь находится пакет данных для отправки

object code

;
ddp_DoTermoCorrection;(w/void)
	banksel _idata_acs
	
	; сохраняемся
	movf _tmp_w
	
	; получаем текущее значение смещения
	
	; разрешена ли коррекция. Это важно при сбросе смещения, т.к. может установить
		; корректируем смещение
	
	; загружаем код смещения, лучше пусть загружает, но ноль
	
	return
	
; Похоже только одна процеура
ddp_SetArrayMaker;(?/?)
	bcf	bArrayTransmitted
	
	; для токов нужна коррекция
#ifdef HALL_SENSORS
	mCorrectHallSensor ZERO_HALL_CORRECT, g_LACurrentValue, g_HACurrentValue
#endif
#ifndef SHIFT_CORRECTION_TEST
	movff	g_LACurrentValue, g_summaryDataArray+0		;I1
	movff	g_HACurrentValue, g_summaryDataArray+1
#endif

#ifdef HALL_SENSORS
	mCorrectHallSensor ZERO_HALL_CORRECT, g_LBCurrentValue, g_HBCurrentValue
#endif
	movff	g_LBCurrentValue, g_summaryDataArray+2	;I2
	movff	g_HBCurrentValue, g_summaryDataArray+3	

	; считывание и проверка напряжения МИП
	movff	AY2L, g_summaryDataArray+4	;U
	movff	AY2H, g_summaryDataArray+5
#ifndef NO_ALRMS
	call state_CheckVoltageAlrm;(?/?)
#endif

	; продолжаем заполнение массива
	movff	g_LAShiftValue, g_summaryDataArray+6	;SM1
	movff	g_HAShiftValue, g_summaryDataArray+7

#ifdef SHIFT_CORRECTION_TEST
	movff	g_LAShiftValue, g_summaryDataArray+0	;SM1
	movff	g_HAShiftValue, g_summaryDataArray+1
#endif
	movff	D4BL, g_summaryDataArray+8	;SM2
	movff	D4BH, g_summaryDataArray+9

	bsf	PORTB,6
	DelayMs	5
	bcf	PORTB,6
	return		;back from MEOS
end