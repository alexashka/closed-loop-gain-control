; ������� �����
; ACS713
#include "dvr_hall_sensors.inc"

; Vars

; Code
hall code

; ����� ��������������� 
; Uo = R16*Uerr/(R16+R10) = 10*500/(10+5.11) = 330.907 mV
; 2^10 - 5000 mV
; x - Uo ; x = 67.76 ue = 68 ue = 0x44 ue
; ���� ������� ����� ����� ������������
currZeroCorr;(fsr0+L+H/fsr0+L+H)
	; ������ ������������! ����
	movlw	0x44	; ����� ���� �� ������������ ����
	subwf	Adc_Temp+0
	movlw	0x00
	subwfb	Adc_Temp+1	; c ������ �����
	
	; ���������� ����� ����������
	movlw	0x05	; ����� ���� �� ������������ ����
	addwf	Adc_Temp+0
	movlw	0x00
	addwfc	Adc_Temp+1	; c ������ ��������
	return
	
end