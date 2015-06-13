; #include <../headers/bum.inc>


	constant	HERE=3
#define		THIS	_v3_BUM
#define		_v3_BUM	_v3_BUM
#include <../headers/board/BoardSpecificFile.inc>
#include <../headers/user_modes.inc>

; Danger!!
	;extern Resp_UM2, 
	extern CurrentUm
	extern Vremen
; Danger!!

#ifdef DVBT2bred_
GLOBAL	DVBT2bred
			DVBT2bred		res 1		;bit0 = H- flag 5T с контроллера удержание аттен.
										;bit1  btgTMR1 in _V1_IRQ.inc (стр.38)delete
										;bit2 = H - запущен ctTMR1L_PinDVBT2
			
			ctTMR1L_PinDVBT2	res 1	;для отсчёта задержки отпирания аттенюатора после появления Pin
			ctTMR1H_PinDVBT2	res 1	;
#endif
	


;// Макросы
variable	k=0;
m_transbuff	macro	name
	movlw 	UPPER name	; Load TBLPTR with the base
	movwf 	TBLPTRU 	; address of the word
	movlw 	HIGH name
	movwf 	TBLPTRH
	movlw 	LOW name
	movwf 	TBLPTRL

metka#v(k):
	TBLRD*+
	movf	TABLAT,w
	btfsc	STATUS,Z
		bz		metka_out#v(k)
	movwf	POSTINC1
	TBLRD*+
	movff	TABLAT,POSTINC1			
	bra		metka#v(k)

metka_out#v(k)
			clrf	POSTINC1
k++
endm
