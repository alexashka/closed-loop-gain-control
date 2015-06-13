#include "../headers/user_modes.inc"

	
; Сохраниения результата измерения
mResultSave	macro	g_L, g_H 
	movff	metroTmpLow,g_L
	movff	metroTmpHight,g_H
	endm

variable i_adc = 0;
mADC macro
	clrwdt
	movlw	0x10
	movwf	counter
	clrf	metroTmpLow
	clrf	metroTmpHight
LoopADC#v(i_adc):
i_adc++
	movf	yanus,w		
	call	_cAD
	movwf	metroTmpLow
	movff	FSR1L,metroTmpHight
endm

; Запуск измерений
mSmao	macro	gLow, gHigh
	movf	yanus,w
	DelayMs	1
	mADC
	mResultSave	gLow, gHigh
endm
; ^ to .inc file!

global g_LACurrentValue, g_HACurrentValue
global g_LBCurrentValue, g_HBCurrentValue
global AY2L, AY2H	; два тока и напряжение
global adc_Init;(?/?)
global adc_Measure;(?/?)
	
; RAM
ram_adc	idata_acs
	g_LACurrentValue 		res	1	;analog values registers
	g_HACurrentValue		res	1
	g_LBCurrentValue		res	1
	g_HBCurrentValue		res	1
	AY2L		res	1
	AY2H		res	1
	
	; utils
	metroTmpLow		res	1
	metroTmpHight		res	1
	yanus		res	1
	counter		res	1

Obj_ADC	code

adc_Init;(?/?):
	movlw	b'10000001'	;bit 6 corrected from L to H 18.08.2005y.
	movwf	ADCON0
	movlw	b'10001010'	;A0...A5-analog inputs
	movwf	ADCON1
	movlw	b'10000001'
	movwf	ADCON2
	return
	
; Похоже на процедуру измерений
adc_Measure;(?/?):
	;I1 measure
	movlw	0x02
	movwf	yanus
	mSmao	g_LACurrentValue, g_LACurrentValue		
	
	;I2 measure
	;movlw	0x03
	;movwf	yanus
	;mSmao	ACurrentValue	
	
	;U measure
	;movlw	0x04
	;movwf	yanus
	;mSmao	2		

#ifdef LOCAL_DATA_PROC
	;norm_meas Umip x1,93 06032012
	movff	AY2L,AARGB2
	movff	AY2H,AARGB1	
	
	banksel	AARGB2
	clrf	AARGB0
	clrf	AEXP
	call	FLO32

	;умнож на коэф K=1,87  (norm fl point d'127-exp		111-hi		92-midl		41-low')
	;  K=1,9						127	115	51	51		
	banksel	BARGB2
	movlw	d'51'
	movwf	BARGB2
	movlw	d'51'
	movwf	BARGB1
	movlw	d'115'
	movwf	BARGB0
	movlw	d'127'
	movwf	BEXP
	call	FPM32	;Umip xK
	
	;проверка на ошибку

	;float > integer meas Umip
	banksel	AARGB3	
	call	INT3232
	
	;проверка на ошибку 
	
	movff	AARGB3,AY2L ;result
	movff	AARGB2,AY2H	;result
	banksel	yanus
#endif ; LOCAL_DATA_PROC
	retlw	VOID


; подпрограмма ADC
; номер канала в W регистре
; возврат младший байт в W, старший в FSR1 
_cAD;(w/w, frs1+0)
	nop
	movwf	FSR1L
	rlncf	FSR1L,f
	rlncf	FSR1L,w
	andlw	b'00111100'
	movwf	FSR1L
	movlw	b'11000011'
	andwf	ADCON0,w
	iorwf	FSR1L,w
	movwf	ADCON0	; регистр конторля преобразований?
	
	nop
	DelayUs	5
	bsf		ADCON0,GO_DONE
	btfsc	ADCON0,GO_DONE
	goto	$-2
	movf	ADRESH,w
	movwf	FSR1L
	movf	ADRESL,w
	return
end

