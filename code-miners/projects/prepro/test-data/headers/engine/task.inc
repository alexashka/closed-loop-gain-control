;#include <../headers/task.inc>
#include	<../headers/fixed/init_data.inc>
	constant	HERE=4
#define		_v4_TASK	_v4_TASK
#define		THIS	_v4_TASK
#include	<../headers/user_modes.inc>
;------------------------------------------------------------

mIfSlide	macro	cond, link
	xorlw	cond
	btfsc	STATUS,Z
	goto	link
endm
			
; Перейти по метке если равно
SLIDE_IF_EQU	macro	cond, link
	xorlw	cond
	btfsc	STATUS,Z
	goto	link
endm