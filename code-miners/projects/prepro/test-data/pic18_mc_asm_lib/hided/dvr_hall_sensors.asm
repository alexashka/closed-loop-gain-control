; Датчики Холла
; ACS713
#include "dvr_hall_sensors.inc"

; Vars

; Code
hall code

; нужно скорректировать 
; Uo = R16*Uerr/(R16+R10) = 10*500/(10+5.11) = 330.907 mV
; 2^10 - 5000 mV
; x - Uo ; x = 67.76 ue = 68 ue = 0x44 ue
; Пока отладка пусть будет закомменчено
currZeroCorr;(fsr0+L+H/fsr0+L+H)
	; ошибка переполнения! была
	movlw	0x44	; через ноль не переваливало пока
	subwf	Adc_Temp+0
	movlw	0x00
	subwfb	Adc_Temp+1	; c учетом заема
	
	; калибровка нужно прибавлять
	movlw	0x05	; через ноль не переваливало пока
	addwf	Adc_Temp+0
	movlw	0x00
	addwfc	Adc_Temp+1	; c учетом переноса
	return
	
end