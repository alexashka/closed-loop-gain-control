;/**
;  HOT- жара
;
;  Вывода через Usart похоже нет
;*/
;NOTE:	закомментир блок исключения показаний T=85
#include <../headers/hot.inc>
mObject_var	_v2_HOT

home_data	res	0

;// объявлены еще в KPUP но там они не используются
DSFLAG		res		1
			;		DSFLAG,0 - H-Init is successful
			;		DSFLAG,1 - H-Last cicle is start( не было запущено темпер преобразов)
			;		DSFLAG,2 - H-Normal Work,L-first mal
			;		DSFLAG,3 - Время истекло
			;		DSFLAG,4 - H- DS- дребезг (неисправность) линии DS (принята T=85, CRC=CRC_DS)
			;		DSFLAG,5 - H- DS- готов для общения после температурного преобразования(3-й проход п\программы)
			;		DSFLAG,6 - H- ошибка приёма данных от DS
			;+060910 DSFLAG,7 - Запрос запуска таймера
DSTEMP		res		1	; сама температура ->L avaData(_HOT)->M assiveUp+20(_BUM)->Resp_UM1+20(_INFO)->Mass2(_INFO)-> to PC
;/// 

DSLoop		res		1
CTDS		res 	1

;// похоже вот эта переменная хранит значение температуры
;//   и из нее похоже это значение уходит за границы модуля
LavaData	res 	1  
  ;//  movff	DSTEMP,LavaData ;  + 12	;+310110
  ;_HOT_GET_DS1821:	mObject_sel	THIS	movf	LavaData,w

DSbyte		res 	9
ctERR_DS	res		1		; счётчик ERROR DS - при счёте до4 формируется задержка около 4сек
							; для передачи значения 0 градусов наружу
ByteCount   res     1       ; Счетчик байт данных
BitCount    res     1       ; Счетчик бит в байте
DataByte    res     1       ; Байт данных
CRC         res     1       ; Временное значение CRC

;
xxxx idata
	waveFormTemper	res	1	; 0000_00ss
	hot_readOnly_zero	res	1; очень важно что только для чтения

;/// /// ///
;///
;/// Начало кода
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
		
		mObject_sel	THIS
	return

;/// /// ///
;///
;/// п/п управления и снятия температурных данных с DS1820PAR
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
_Testo
		btfsc	DSFLAG,1	;0- было запущено температурное преобразование
		bra		_Tstart
		btfsc	DSFLAG,5
		bra		_DSyes		;DS- готов для общения после температурного преобразования(3-й проход п\программы)
		call	_DSini
		btfss	DSFLAG,0
		return
		bsf		DSFLAG,5	;1-DS готов для общения после температурного преобразования
		return

_DSyes 
		DelayUs	30;25
		movlw	0xCC		;command	обращения к DS1820
		call	_DSWbyte
		DelayUs	30;25
		movlw	0xBE		;command	чтения t из DS1820
		call	_DSWbyte
		DelayUs	13; 10		;~20mKs-уменьшить?

		call	_DS_R9byte		;приём 9байтов от DS и вычисление контр суммы
		cpfseq	DSbyte+8		;проверка контр суммы
		bra		lbl_DSfalse_crc	;CRC NOT=DSbyte+8
		movff	DSbyte,DSTEMP

		nop						;здесь ещё 1раз раз считать t, для проверки правильности приёма

		rrncf	DSTEMP		;делим на 2 теперь точноть t=1 градус С
		bcf		DSTEMP,7

lbl_85:						;исключаем T=85, как возможную ошибку датчика DS:
		movlw	85			
		cpfseq	DSTEMP
		bra		lbl_85OUT
		bsf		DSFLAG,4		;H- дребезг линии DS
			incf	ctERR_DS	;+040310	инкремент счётчика ошибок 
		clrf	DSTEMP			;T=0 C
			bra		lbl_out_DSyes2			;+040310
lbl_85OUT:	
		bcf	DSFLAG,4

		bra		lbl_out_DSyes

lbl_DSfalse_crc:
		incf	ctERR_DS		;+040310						
		clrf	DSTEMP			;T=0 C
		bsf		DSFLAG,6		;ошибка приёма от DS
		bra		lbl_DS_in_Lava
lbl_out_DSyes:
		clrf	ctERR_DS		;+040310
lbl_out_DSyes2:
		bcf		DSFLAG,6		;not ошибка приёма от DS

lbl_DS_in_Lava:	;запись значения Т, разрешение/запрет показать T=0			(добавлен и дополнен+040310)

		btfsc	DSFLAG,4		;H- дребезг линии DS ?
		bra		lbl_ctERR
		btfss	DSFLAG,6		;H-ошибка приёма от DS?
		movff	DSTEMP,	LavaData ;+ 12 ;измеренное значение температуры наружу
lbl_ctERR:
		movlw		4			;+040310
		cpfslt		ctERR_DS	;+040310  	была 4 раза ошибка?
		movff	DSTEMP,LavaData ;+ 12			;+310110	 да, разрешаем показать T=0 после 4-х ошибок подряд

		bsf		DSFLAG,1
		bcf	DSFLAG,5		;0-DS не готов для общения после температурного преобразования(нет_DSini)
		return

_Tstart						;старт преобразования t в DS1820par
		mObject_sel	THIS	
		call	_DSini
		btfss	DSFLAG,0
		return
		DelayUs	30;25
		movlw	0xCC		;command
		call	_DSWbyte
		DelayUs	30;25		;в дальнейшем можно уменьшить зад
		movlw	0x44		;command температурного преобразования в DS1820
		call	_DSWbyte
		bsf		TTX_port

		bcf		TTX_tris

		bcf		DSFLAG,1	;выставили флаг преобраз - запущено

		bcf		DSFLAG,7	;выставили флаг запрос таймера
		bcf		DSFLAG,3	;++ 060910

		return

_DSRbyte					;DS1821 BYTE Read Sub-Programm
		clrf	DSTEMP
		movlw	0x08
		movwf	DSLoop
_DSLoopr
		bcf		TTX_tris
		bcf		TTX_port
		DelayUs	3;2			;Really x2

		bcf		INTCON,GIEH
		bsf		TTX_tris
		DelayUs	12; 8
		btfsc	TTX_port

		bsf		DSTEMP,7

		bsf		INTCON,GIEH

		dcfsnz	DSLoop,f
		return				;Byte Reading is finished
		nop
		nop
		DelayUs	25 ;20 ;10 ;20 ПОПРОБОВАТЬ!
		rrncf	DSTEMP,f
		bra		_DSLoopr

_DSWbyte					;DS1821 BYTE Write Sub-Programm
		movwf	DSTEMP

		movlw	0x09	;так и надо 9

		movwf	DSLoop
_DSLoopw
		dcfsnz	DSLoop,f
		return

		bcf		INTCON,GIEH

		bcf		TTX_tris
		bcf		TTX_port
		DelayUs	3; 2
		btfsc	DSTEMP,0	;Sending H?
		bsf		TTX_tris	;Yes, H
		DelayUs	75 ;60		;Send Slot Time
		bsf		TTX_tris

		bsf		INTCON,GIEH

		DelayUs	3; 2		;Pause 
		rrncf	DSTEMP,f
		bra		_DSLoopw

_DSini						;DS1821 INI Sub-Programm
		bcf		DSFLAG,0	;INI flag resetting
		bcf		TTX_tris
		bcf		TTX_port
		DelayUs	250; 200	;Really ~500mkS
		DelayUs	250; 200
		bsf		TTX_tris
		DelayUs	21; 15
		movlw	50
		movwf	CTDS
_DSW
		DelayUs	2;1
		dcfsnz	CTDS,f
		return
		btfsc	TTX_port
		bra		_DSW

		movlw	200
		movwf	CTDS
_DSW2
		DelayUs	2;1
		dcfsnz	CTDS,f
		return
		btfss	TTX_port
		bra		_DSW2
		bsf		DSFLAG,0	;INI is successful
		return

_DS_R9byte		;приём 9 байтов от DS, вычисление CRC
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+1
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+2
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+3
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+4
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+5
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+6
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,DSbyte+7
		DelayUs	25 ; 20
		call	_DSRbyte
		MOVFF	DSTEMP,	DSbyte+8

		lfsr	0, 	DSbyte ;0x50		;адрес _DSRbyte
		movlw	0x08			;кол байтов для вычисления CRC
;		call	CalcCRC8		;вычисление CRC, return CRC in W


;   *********************************************************************
;   *                                                                   *
;   *                   Процедура: CalcCRC8                             *
;   *                                                                   *
;   *    Процессор: PIC16.                                              *
;   *    Параметры: W = число байт данных.                              *
;   *               FSR = адрес буфера данных.                          *
;   *               IRB = банки буфера данных.                          *
;   *      Возврат: W = CRC8.                                           *
;   *     Описание: Вычисление CRC8 основано на циклическом полиноме    *
;   *               вида X8+X5+X4+X1 (см. документ DA LLAS AN27). CRC8   *
;   *               вычисляется для указанного в W числа байтов данных, *
;   *               расположенных в буфере, находящемся в памяти данных *
;   *               по адресу, указанному в регистре FSR в банке,       *
;   *               определяемом битом IRB. Результат возвращается в W. *
;   *               Процедура написана в перемещаемых кодах и может     *
;   *               быть размещена в любой странице памяти программ.    *
;   *               Локальные переменные размещаются в оверлейной       *
;   *               секции для любого банка памяти данных.              *
;   *      История: 26.11.2006 - числовая маска CRC заменена            *
;   *               определением "#d efine CRC_POLY 0x18".               *
;   *                                                                   *
;   *********************************************************************

CalcCRC8:
        movwf   ByteCount       ; Сохранение длины сообщения
        movlw   0x00            ; Инициализация CRC было FF !!! -для опред нулевой последовательности данных
        movwf   CRC
CalcNextByte                    ; Внешний цикл по байтам данных
        movlw   8               ; Инициализация внутреннего цикла для 8
        movwf   BitCount        ;   бит в счетчике бит
        movf   POSTINC0,w       ; SLAVA 051010 Выборка очередного байта данных
        movwf   DataByte        ;   и его запоминание
CalcNextBit                     ; Внутренний цикл по битам байта
        movf   CRC,w            ; Выделение младшего бита CRC
        andlw   0x01
        xorwf   DataByte, F     ; DataByte.0 = новое CRC.0
        btfss   DataByte, 0     ; Переход, если надо инвертировать биты 4 и 5 в CRC
        goto    ShftCRC        ; Переход, если не надо инвертировать биты 4 и 5 в CRC

        movlw   CRC_POLY        ; Инвертирование битов 4 и 5 в CRC
        xorwf   CRC, F
ShftCRC
        rrcf     DataByte, F     ; Сдвиг всей CRC
        rrcf     CRC, F

        decfsz  BitCount, F     ; Декремент и проверка счетчика бит
        goto    CalcNextBit     ; Цикл, если не все биты байта обработаны

        decfsz  ByteCount, F    ; Декремент и проверка счетчика байт
        goto    CalcNextByte    ; Цикл, если не все байты данных обработаны

        movf   	CRC,w           ; Возврат результата через W
        return

;/// /// ///
;///
;/// Еще набор каких-то функций
_HOT_GET_DS1821:
		mObject_sel	THIS
		movf	LavaData,w
	return

;
_HOT_ASK_DS1821NeedTime:
		mObject_sel	THIS
		btfss	DSFLAG,7
		retlw	TRUE
		retlw	FALSE
;
_HOT_CLR_DS1821NeedTime:
		mObject_sel	THIS
		bsf		DSFLAG,7
	return
;
_HOT_SET_DS1821TimeOver:
		mObject_sel	THIS
		bsf		DSFLAG,3
	return


; igor
; проверить на отказ температуры
_v0_hot_getTermAlrmMask;(void/w)

	; сдвигаем диаграмму
	banksel	waveFormTemper
	rlncf	waveFormTemper, f	; сдвигаем влево и пишем обратно 
	movlw	0x03	; 0000_0011 - очищаем
	andwf	waveFormTemper, f	; чистый фронт
		; в 0-бите образуется ноль - отказа не было

	mObject_sel	THIS
	; проверка на отказ по температруе
	movlw	TERM_THRESHOLD
	cpfsgt	LavaData	; f > w
	bra		temperAlrmNoAdded	; все хорошо, если превысело, нужно это перескочить

	; отказ был
	; маскируем и добавляем в конец
	banksel	waveFormTemper
	bsf	waveFormTemper, 0	; 0000_00x1

	; заготовка для отказа
	movlw	b'00010000'
	bra		temperAlrmWasAdded

temperAlrmNoAdded:
	movlw	0
temperAlrmWasAdded:
	mRETURN



; проверка фронта
; waveFormTemper = 0,1,2,3
;mEXTENDS	_v2_HOT,	_v?,	hot_public_testTempFront;(void/w)
hot_public_testTempFront;(void/w)
	banksel	waveFormTemper

	; switch (waveFormTemper) {
	; Неизменные состояния
	; нет и не было отказа 0000_0000
	movlw	0x00
	cpfseq	waveFormTemper
		TSTFSZ	hot_readOnly_zero	; будет неверное! и не перескочет
			retlw NO_EVENT

	; был отказ и он сохранился 0000_0011
	movlw	0x03
	cpfseq	waveFormTemper
		TSTFSZ	hot_readOnly_zero
			retlw NO_EVENT

; Event occure
	; проверка положительного фронта 0000_0001
	movlw	0x01
	cpfseq	waveFormTemper
		TSTFSZ	hot_readOnly_zero
			retlw EVENT_UP

	; проверка спада 0000_0010
	movlw	0x02
	cpfseq	waveFormTemper
		TSTFSZ	hot_readOnly_zero
			mSlideTo	hot_prv_tAlrFalled;()
	;}
	retlw	NO_EVENT
; Конец кода
hot_prv_tAlrFalled;()
	;bcf 	INTCON,	GIE		;disable irq вот так вот. интересно выход ли..
#ifdef Z_T_ALR_FALL
	;movlw	0x13
	;mCall setZ1
#endif
	mCall	onDisappearTemperAlrm;(void/void)
	retlw EVENT_DOWN
end