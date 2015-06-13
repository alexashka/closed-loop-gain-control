;/**
;  HOT- жара
;
;  Вывода через Usart похоже нет
;*/
;NOTE:	закомментир блок исключения показаний T=85
#include <../headers/hot.inc>
mObject_var	_v2_HOT

home_data	res	0


Obj_HOT	code

;// Инициализация
_HOT_SET_Ini:
	mObject_sel	THIS
	movlw	b'10001110'		;начальное сост флага: определ инициал(,bit<0>) и запущено преобраз темп (bit<1>)
	movwf	DSFLAG			;DS1820PAR
	clrf	ctERR_DS		; +040310 сброс счётчика ERROR DS
	
	; !!Один для всех операторов положительного ветвления
	banksel	waveFormTemper
	clrf	hot_readOnly_zero
	return

;// п/п управления и снятия температурных данных с DS1820PAR
;// похоже запускается в таймере, через промежутки времени
;_B UM_SETdw_Temper
;	_v#v(HERE)_T ASK_HLTuw_DataRefreshWait;(void/void)<<<DataRefreshWait
;		_C LK_HLTuw_Tick; обработчик прерывания таймера
_HOT_SET_DS1821:
_DSread
_DSini_status
	mObject_sel	THIS
	btfsc	DSFLAG,0	;INI flag resetting		
		;проверка отсутсвия инициализаци DS (от 2-10мс - до 5сек)
	bra		out_DSini_status 
	clrf	DSTEMP		;индикация T=0 C

	incf	ctERR_DS,f	;+040310	инкремент счётчика ошибок 
	movlw	4			;+040310
	cpfslt	ctERR_DS	;+040310  	была 4 раза ошибка?

	movff	DSTEMP,	LavaData ;  + 12	;+310110

out_DSini_status:
	btfsc	DSFLAG,3	; ++060910
	bra		_Testo
	btfsc	DSFLAG,1	;0- было запущено температурное преобразование
	bra		_Tstart
	return
end




