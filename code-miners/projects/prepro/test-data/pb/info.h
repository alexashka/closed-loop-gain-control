; #define "info.h"

; Code
extern sdr_LockAndShiftOff;(?/?)

; Data
extern g_LACurrentValue, g_HACurrentValue, g_LBCurrentValue, g_HBCurrentValue, AY2L, AY2H
extern g_kFlag
extern g_LAShiftValue,g_HAShiftValue,D4BL,D4BH

#define	aliasStateByte 	g_summaryDataArray+10	;���� ���������	
#define byteAlrms	g_summaryDataArray+11	;���� �������
#define	bArrayTransmitted	g_kFlag,0		;H-Massive transmitted

;#define LEN_INFO_MSG 13
	
variable i = 0;
mCorrectHallSensor macro CORRECT_VALUE, LL, HH
	; ������ ������������! ����
	; ����� ���� �� ������������ ����
	movlw	LOW CORRECT_VALUE	
	subwf	LL
	movlw	HIGH CORRECT_VALUE
	subwfb	HH	; c ������ �����
	
	; �������� ������������
	bn _clear#v(i)
	bra _all_right#v(i)

_clear#v(i)
	clrf	LL
	clrf	HH
_all_right#v(i)
	i++
endm 