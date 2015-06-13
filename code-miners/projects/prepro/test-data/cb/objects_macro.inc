#ifndef OBJ_MAC
#define OBJ_MAC
; format - Ok
;  выводит статистику по используемым функциям
;*/
	variable	Number_Static=0
	variable	Number_Public=0
	variable	Number_Ext_Functions=0
	variable	Number_Ext_Variables=0

mObject_var		macro	klass
	klass		idata
	klass#v(0)	res	0
				endm
mObject_end		macro	klass
	ifdef	klass
	messg В модуле klass найдено:
	messg 1. Статических переменных____#v(Number_Static)
	messg 2. Открытых переменных_______#v(Number_Ext_Variables)
	messg 3. Глобальных переменных_____#v(Number_Public) 
	messg 4. Открытых функций__________#v(Number_Ext_Functions)
	endif
				endm
mObject_sel		macro	klass
	ifdef	klass
		banksel	klass#v(0)
	endif
				endm
;///


;/// /// ///
mEXTENDS		macro	klass_s, klass_d, name
	ifdef	klass_s
		global	name
Number_Ext_Functions++
	endif
	ifdef	klass_d
		extern	name
	endif
				endm
;///

;/// просто вызов функции?
mSlideTo	macro	Link
	goto	Link
endm
;/// ///

;// вызовы прдпрограмм
mRetIfF?	macro	link
	call	link
	xorlw	TRUE
	btfss	STATUS,Z
	retlw	FALSE
			endm

mFunction	macro	link
	call	link
			endm

mASK		macro	link
	call	link
			endm
mGET		macro	link
	call	link
			endm
mSET		macro	link
	call	link
			endm
mRUN		macro	link
	call	link
			endm
			
mRETURN		macro
	return
			endm

; igor 170512
; вызов и возврат с сохранением всего
;Syntax: CALL k {,s}
;Operands: 0 ? k ? 1048575
;	s ? [0,1]
;Operation: (PC) + 4 > TOS,
;	k > PC<20:1>,
;	if s = 1
;		(W) > WS,
;		(STATUS) > STATUSS,
;		(BSR) > BSRS
;Syntax: RETURN {s}
;Operands: s ? [0,1]
;Operation: 
;	(TOS) > PC,
;	if s = 1
;		(WS) > W,
;		(STATUSS) > STATUS,
;		(BSRS) > BSR,
;		PCLATU, PCLATH are unchanged
mCallSave	macro	link
	call	link, FAST
			endm
mReturnSave	macro
	return	FAST
			endm
mCall		macro 	link
	call link
			endm
#endif ;OBJ_MAC