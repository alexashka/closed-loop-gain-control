#include "../headers/user_modes.inc"
;NOTE:	закомментир блок исключения показаний T=85
; повторный опрос DS, при показаниях Т>80 c +261010
; Code
global hot_Ini;(?/?)
global hot_DoMeasureTemperature;(?/?)
global hot_GetTemperature;(void/w)

; Data
global g_DSFlag
extern	g_summaryDataArray, CalcCRC8

mydata_hot		idata_acs
	g_DSFlag		res	1
		;	g_DSFlag,0 - H - Init is successful
		;	g_DSFlag,1 - H - Last cicle is start( не было запущено темпер преобразов)
		;	g_DSFlag,2 - H - есть первое показание T>80 C, L-нет.  H-Normal Work,L-first mal(-261010)
		;	g_DSFlag,3 - H - 
			
		;	g_DSFlag,4 - H - DS- дребезг (неисправность) линии DS (принята T=85, CRC=CRC_DS)
		;	g_DSFlag,5 - H - DS- готов для общения после температурного преобразования(3-й проход п\программы)
		;	g_DSFlag,6 - H - ошибка приёма данных от DS
		;	g_DSFlag,7 - H - авария по температуре?

; Локальные для модуля переменные
	dsTemp		res	1
	DSLoop		res	1
	CTDS		res 1
	ds_flag_total_cont	res 1			;для разбиения п/п DS на циклы не превышающие T=1ms! +271010
		;0-H-нужно идти к метке...
		;1-H-...
		;2-H-...
		;3-H-...
		;4-H-...
		;5-7-свободны
									
Dtat_hot		idata_acs	0x50		;+++++280110
	DSbyte		res 9		
	ctERR_DS	res	1				;счётчик ERROR DS - при счёте до4 формируется задержка около 4сек
									;для передачи значения 0 градусов наружу
	Del_rslot	res 1								

Obj_HOT	code

hot_GetTemperature;(void/w)
	movff g_summaryDataArray+12, WREG
	return
	
; начало начал
hot_Ini;(?/?);(?/?)
	movlw	b'00000010'			;	b'00000110'	-261010		;начальное сост флага: определ инициал(,bit<0>) и запущено преобраз темп (bit<1>)
	movwf	g_DSFlag,0			;DS1820PAR
	clrf	ctERR_DS,0		; +040310 сброс счётчика ERROR DS
	movlw	5					;1=Del_rslot соотв примерно 2мкс зад на считывание.
	movwf	Del_rslot			;начальное знач задержки на считывание инф. с DS 
	return
	
; измерение?
hot_DoMeasureTemperature;(?/?);(?/?)
_DSread
	lbl_IF_ds_flag_total_cont:				;+271010проверка на каком цикле общения с DS находимся и переход далее
	btfsc	ds_flag_total_cont,0			;+271010
		bra	lbl_if_H_ds_flag_total_cont_0		
	btfsc 	ds_flag_total_cont,1			
		bra	lbl_if_H_ds_flag_total_cont_1		
	btfsc 	ds_flag_total_cont,2			
		bra		_DSini_status				; (переход, если было запущ преобраз T)
	btfsc 	ds_flag_total_cont,3			
		bra	lbl_if_H_ds_flag_total_cont_3		
	btfsc 	ds_flag_total_cont,4			
		bra	lbl_if_H_ds_flag_total_cont_4		

_DSini_status
	btfsc	g_DSFlag,0	;INI flag resetting				;проверка отсутсвия инициализаци DS (от 2-10мс - до 5сек)
		bra		out_DSini_status 							
	clrf	dsTemp,0									;индикация T=0 C

	incf	ctERR_DS,f,0			;+040310			инкремент счётчика ошибок 
	movlw		4					;+040310
	cpfslt		ctERR_DS,0			;+040310  			была 4 раза ошибка?
		movff	dsTemp,g_summaryDataArray + 12	;+310110	
	
out_DSini_status:
	btfsc	INTCON,TMR0IF	;АНАЛИЗ ФЛАГА ПЕРЕПОЛНЕНИЯ TMR0
		bra		_Testo
	btfsc	g_DSFlag,1	;0- было запущено температурное преобразование
		bra		_Tstart	
	return
	
_Testo
	btfsc	g_DSFlag,1	;0- было запущено температурное преобразование
	bra		_Tstart
	btfsc	g_DSFlag,5
		bra		_DSyes	;DS- готов для общения после температурного преобразования(3-й проход п\программы)
	call	_DSini
	btfss	g_DSFlag,0
		return
	bsf	g_DSFlag,5,0		;1-DS готов для общения после температурного преобразования
	return
	
_DSyes 
	DelayUs	25
	movlw	0xCC		;command	обращения к DS1820
	call	_DSWbyte
	DelayUs	25
	bsf	ds_flag_total_cont,3	;+271010
	bcf	ds_flag_total_cont,2	;(чтобы вернуться в lbl_if_H_ds_flag_total_cont_3)
	return	

lbl_if_H_ds_flag_total_cont_3:			
	movlw	0xBE		;command	чтения t из DS1820
	call	_DSWbyte
	DelayUs	10			;~20mKs-уменьшить?
	bsf	ds_flag_total_cont,4	;+271010
	bcf	ds_flag_total_cont,3	
	return			
		
lbl_if_H_ds_flag_total_cont_4:			
	bcf	ds_flag_total_cont,4	
	call	_DS_R9byte		;приём 9байтов от DS и вычисление контр суммы
	cpfseq	DSbyte+8		;проверка контр суммы
		bra		lbl_DSfalse_crc	;CRC NOT=DSbyte+8
	movff	DSbyte,dsTemp
	nop						;здесь ещё 1раз раз считать t, для проверки правильности приёма
	rrncf	dsTemp,1		;делим на 2 теперь точноть t=1 градус С
	bcf		dsTemp,7

lbl_repeated_T:				;повторный опрос при T=85 градусов  +	
	; Danger!!
	movlw	d'85'					
	cpfseq	dsTemp,0			;85=DS ?
	bra		lbl_out_DSyes		;lbl_repeated_T_OUT		;no
	bra		lbl_DSfalse_crc		;yes.(H-  of/on питания DS)
	bra		lbl_out_DSyes

lbl_DSfalse_crc:
	incf	ctERR_DS,f,0		;+040310								
	clrf	dsTemp,0			;T=0 C
	bsf		g_DSFlag,6			;ошибка приёма от DS
	bra		lbl_DS_in_Lava
	
lbl_out_DSyes:
	clrf	ctERR_DS			;+040310
	
lbl_out_DSyes2:
	bcf		g_DSFlag,6			;not ошибка приёма от DS
	
lbl_DS_in_Lava:					;запись значения Т, разрешение/запрет показать T=0			(добавлен и дополнен+040310)
	btfss	g_DSFlag,6			;H-ошибка приёма от DS?
		movff	dsTemp,g_summaryDataArray + 12 ;измеренное значение температуры наружу	
	
lbl_ctERR:
	lbl_ctERR2:
	movlw	7;	4					;+040310
	cpfslt		ctERR_DS,0			;+040310 была 8;4 раза ошибка?
		movff	dsTemp,g_summaryDataArray + 12	;+310110 dа, разрешаем показать T=0 после 8; 4-х ошибок подряд
	
lbl_withoutmeasDS:
	bsf		g_DSFlag,1
	bcf	g_DSFlag,5,0			;0-DS не готов для общения после температурного преобразования(нет_DSini)
	return

_Tstart						;старт преобразования t в DS1820par
	call	_DSini
	btfss	g_DSFlag,0
		return
	DelayUs	160;25			;+181210
	bsf	ds_flag_total_cont,0	;+271010
	return		
		
lbl_if_H_ds_flag_total_cont_0:			
	movlw	0xCC		;command
	call	_DSWbyte
	DelayUs	25			;в дальнейшем можно уменьшить зад
	bsf	ds_flag_total_cont,1	;+271010
	bcf	ds_flag_total_cont,0	
	return		
		
lbl_if_H_ds_flag_total_cont_1:			
	movlw	0x44		;command	температурного преобразования в DS1820
	call	_DSWbyte	
	bsf		PORTC,6,0
	bcf		TRISC,6,0
	bcf		g_DSFlag,1	;выставили флаг преобраз - запущено
	movlw	0xC2
	movwf	TMR0H
	movlw	0x00
	movwf	TMR0L
	movlw	b'10000111'
	movwf	T0CON	;включение TMRO,синхр внутр,подкл предделителя 256
	bcf		INTCON,TMR0IF		;сбросили наконец-то таймер!!!!!!(перенос из Testo)NEW rev 111110!
	bsf 	ds_flag_total_cont,2	;+271010
	bcf		ds_flag_total_cont,1		
	return

_DSRbyte					;DS1821 BYTE Read Sub-Programm
	clrf	dsTemp
	movlw	0x08
	movwf	DSLoop
	
_DSLoopr
	bcf		INTCON,PEIE	;!!!
	bcf		TRISC,6
	bcf		PORTC,6
	DelayUs	2			;Really x2
	bsf		TRISC,6
	
	DelayUs	10
	btfsc	PORTC,6
		bsf		dsTemp,7,0
	bsf		INTCON,PEIE
		
	dcfsnz	DSLoop,f
		return				;Byte Reading is finished
	nop
	nop
	DelayUs	60
	rrncf	dsTemp,f
	bra		_DSLoopr

_DSWbyte			;DS1821 BYTE Write Sub-Programm
	movwf	dsTemp
	movlw	0x09	;так и надо 9
	movwf	DSLoop
	
_DSLoopw
	dcfsnz	DSLoop,f
	return
	bcf		TRISC,6
	bcf		PORTC,6
	DelayUs	10;2
	btfsc	dsTemp,0	;Sending H?
	bsf		TRISC,6		;Yes, H
	DelayUs	60			;Send Slot Time
	bsf		TRISC,6
	DelayUs	10			;Pause 
	rrncf	dsTemp,f
	bra		_DSLoopw

_DSini					;DS1821 INI Sub-Programm
	bcf		g_DSFlag,0	;INI flag resetting
	bcf		TRISC,6
	bcf		PORTC,6
	DelayUs	200			;Really ~500mkS
	DelayUs	200
	bsf		TRISC,6
	DelayUs	15
	movlw	50
	movwf	CTDS
	
_DSW
	DelayUs	1
	dcfsnz	CTDS,f
	return		
	btfsc	PORTC,6
	bra		_DSW
	movlw	200
	movwf	CTDS
	
_DSW2
	DelayUs	1
	dcfsnz	CTDS,f
	return
	btfss	PORTC,6
	bra		_DSW2
	bsf		g_DSFlag,0	;INI is successful
	return
	
_DS_R9byte		;приём 9 байтов от DS, вычисление CRC
	call	_DSRbyte	
	MOVFF	dsTemp,DSbyte
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+1
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+2
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+3
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+4
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+5
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+6
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+7
	DelayUs	20
	call	_DSRbyte
	MOVFF	dsTemp,DSbyte+8

	lfsr	FSR0,0x50		;адрес _DSRbyte	
	movlw	0x08			;кол байтов для вычисления CRC
	call	CalcCRC8		;вычисление CRC, return CRC in W
	return
end