; for f2520
; ����� ���
#include <../headers/user_modes.inc>	; �����, ��� ��� ����������� � �������

extern	DAL, DAH
global lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)

Extract	code
lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)
	swapf	DAH,f
	swapf	DAL,f
	movlw	b'11110000'
	andwf	DAH,f
	movlw	b'00001111'
	andwf	DAL,w
	iorwf	DAH,f
	lfsr	0,DAL
	return
end
	