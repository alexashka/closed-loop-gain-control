;/**
;  uart2 - yes
;  похоже содержит код обслуживания обмена данными с ПК (COMPuter)
;  вызывается начало передачи. отправка, и выключение передачи
; ? где адреса буфферов для чтения и записи
; _COMP - признак размещения в этом файле
;*/

;************************************************************
;	Модуль обслуживания АРМ
;************************************************************
include "headers/comp.inc"

mObject_var	_v3_COMP
	Temp			res		1
	
	; резервируем буфферы для приема и передачи, так?
	Buffer_In_00	res		MAXNUMBERBYTE  ; было 88 в user_modes
	Buffer_Out_00	res		MAXNUMBERBYTE
	
	; states принимаемого потока байтов
	Newbyte_In		res		1
	Oldbyte_In		res		1
	TooOldbyte_In	res		1
	; состояния для вывода данных на ПК
	Newbyte_Out		res		1
	Oldbyte_Out		res		1
	TooOldbyte_Out	res		1
	; end states
	
	Number_In		res		1
	Number_Out		res		1
	Checksum_In		res		1
	Checksum_Out	res		1
	Tr_Temp			res		1
	Command			res		1
	Buffer_Temp		res		3
	Number_Out_Max	res		1
	Number_In_Max	res		1  ; это же резервированвие, а где присвоение значений?

	;// States
	; была ли комманда установки усиление аттенюатора?
	State_setGainAtt 	res 	1  

Object	code

;
_v#v(HERE)_COMP_INI:
;	mObject_sel	THIS
	;// инициализация состояний автоматов
	movlw 	NO_OBTAINED  ;// комманду о установке осл. атт. не получали
	movwf	State_setGainAtt
	;//
	retlw	VOID

;/// /// /// Downward methodes
;///
;/// Должна вызываться! где-то хранится адрес буффера данных для отправки
_v#v(HERE)_COMP_SETdw_wfSendMessage1;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max	; размер сообщения
	
	; debug point
	;movlw	0x07
	;movwf 	INDF0
	
	movlw	CMD_FROM_PC_GET_12
	bra		_Mess_send

;// Информация о МИП?
_v#v(HERE)_COMP_SETdw_wfSendMessage2;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max	
	movlw	0x02
	bra		_Mess_send

	
_v#v(HERE)_COMP_SETdw_wfSendMessage3;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x04
	bra		_Mess_send
	
;// Получить лог
_v#v(HERE)_COMP_SETdw_wfSendMessage4;(byte w,mass FSR0/void)
	mObject_sel	THIS
	movwf	Number_Out_Max
	movlw	0x05
	bra		_Mess_send

; Упаковка сообщений	
; точка входа для всех функций означенных выше
_Mess_send:	
	movwf	Buffer_Out_00+2
	clrf	Number_Out			;определение длины
	lfsr	1,	Buffer_Out_00+3		;// еще один буффер - Massn->Buffer_Out_00
	;// +0 +1 +2 [+3 ...] 
	
	;// цикл : загрузка счетчика
	;// вставляем данные
	
	movf	Number_Out_Max,w
_Copy_Loop2:
	movff	POSTINC0,POSTINC1 	; использует FSR регистры для адресации
	addlw	-1
	bnz		_Copy_Loop2  ;// перекачка буффера
	;// перемещение данных завершено
	
	movlw	4
	addwf	Number_Out_Max,f
	clrf	Number_Out
	movff	Number_Out_Max,Buffer_Out_00
	movlw	0x9F
	movwf	Buffer_Out_00+1
	clrf	Oldbyte_Out
	clrf	TooOldbyte_Out
	movlw	0xAA
	movwf	Newbyte_Out
	
	;// отправляем стартовый байт
	;// затем махом по прерываниям отправляются все
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart2StartTx;(byte W/void)

;/// 
;///
;/// /// ///


;/// /// /// Upward methodes
;///
;/// 
_v#v(HERE)_COMP_SETuw_ByteError;(void/void)
			mObject_sel	THIS
_COMP_ByteError:
			clrf	Number_In_Max
			clrf	Newbyte_In
			clrf	Oldbyte_In
			clrf	Number_In
			retlw	VOID

_v#v(HERE)_COMP_SETuw_BufFull;(void/void)		
			mObject_sel	THIS
			mSET	_v#v(DOWN)_PIO_SETdw_Uart2Antifreeze;(void/void)
			mSlideTo	_COMP_ByteError
			retlw	VOID

;/// /// ///
;///
;/// прием и определение комманды, а так же реакция на них
;// Распределение задач
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	...	!	TooOldbyte_In	!	Oldbyte_In	!	Newbyte_In	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Newbyte_In - число байт в комманде
; ! в аккамуляторе принятый байт
; AA 55 1F тип_сообщения код_комманды CRC
_v#v(HERE)_COMP_SETuw_wByteIn;(byte W/void)
	mObject_sel	THIS
	movwf	Newbyte_In  ; ? сохраняем в ОЗУ
	movf	TooOldbyte_In,w		; детектирование правдоподобия преамбулы
	xorlw	0xAA
	bnz		_Non_header  ; если не равно
	movf	Oldbyte_In,w
	xorlw	0x55
	bnz		_Non_header
			
_Header:
	movlw	MAXNUMBERBYTE  ; максимальный размер буффера?
	cpfslt	Newbyte_In  
	  ;(f) – (W),
	  ; skip i f (f) < (W) (unsigned comparison)
	mSlideTo	_COMP_ByteError		
	movf	Newbyte_In,w
	movwf	Number_In
	movwf	Number_In_Max	;определение длины
	clrf	Checksum_In	; сброс контрольной суммы?
	
_Non_header:
	movf	Number_In,f		;диагностика необходимости приема
	bz		_cash_In_IRQ		
	
_NextByte:
	movf	Oldbyte_In,w	;детектирование правдоподобия преамбулы
	xorlw	0xAA
	bnz		_ordin
	movf	Newbyte_In,w
	bz		_cash_In_IRQ
	mSlideTo	_COMP_ByteError
	
_ordin:
	decfsz	Number_In,f		;уже принятый байт в буфер
	bra		_Cash_In		;декремент счетчика принимаемых данных

_EOFbyte:	
	movf	Newbyte_In,w
	cpfseq	Checksum_In
	bra		_cash_In_IRQ
	mSlideTo	_COMP_Com_Process  ; goto к обработке?
	
_Cash_In:	
	lfsr	1,Buffer_In_00-1
	movf	Number_In,w
	subwf	Number_In_Max,w
	movff	Newbyte_In,PLUSW1
	movf	Newbyte_In,w
	addwf	Checksum_In,f
	
_cash_In_IRQ:
	movff	Oldbyte_In,TooOldbyte_In
	movff	Newbyte_In,Oldbyte_In	; перевод принятого байта из разряда нового в старые
	retlw	VOID

; ! С заголовком похоже разобрались
; метка была отделена
_COMP_Com_Process	; ? это метка или что, ! судя по всему да или функция
	mObject_sel	THIS

	movlw	0x1F	; магическое число из протокола обмена - похоже на часть протокола
	xorwf	Buffer_In_00+1,w	; Buffer_In_00 - указатель?
	btfss	STATUS,Z	; ветвление, вернее обход
		retlw	VOID

	lfsr	0,Buffer_In_00+2	; перемещения указателя чтения?
		; Buffer_In_00+2 - указывает на тип сообщения
		; Buffer_In_00+3 - указывает на данные в сообщении

;// Обработка типов сообщений 01, 02, 04, 05, 06(ATT_NFO), 03(CMD)
; ответы на запросы. Из задач
; приходят довольно больше блоки, кроме одной комманды
	movlw	0x01	; !посылает если нет связи
	xorwf	INDF0,w	; проверка комманды, switch
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req1;(void/void) *

	;// пришла комманда получений информации о мип
	movlw	TYPE_MSG_GET_NFO_ABOUT_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req2;(void/void) *
		
		;//mGET		_v#v(DOWN)_INFO_GETdw_ReqInfoForComp2WF;(void/byte,mass FSR0)
		;	...movlw	31  ;// длина посылки!
		;	lfsr	0,Mass2...  ;// FSR0
		;// отпревляем сообщение на ПК
		;//mSlideTo	_v#v(DOWN)_COMP_SETdw_wfSendMessage2;(byte,mass FSR0/void)
		; 	movwf	Number_Out_Max
		; 	movlw	0x02
		; 	bra		_Mess_send  ;// lfsr	0,Mass2 - еще сохранился?
		; 		mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart2StartTx;(byte W/void)
			
	movlw	0x04
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req3;(void/void) *
	
	movlw	TYPE_MSG_CPUX_LOG 	;//0x05
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req4;(void/void) *
; ответы на запросы

;/// /// ///
;///
;/// (igor 170412)
	; Введен дополнительный тип сообщения, которое 
	;   несет информацию об ослабленни атт.
	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass  ;// Если не оно, обходим обработку 
	
	;// Проверяем состояние автомата 
	movf 	State_setGainAtt, w	
	
	; Комманда не была получено - состояние нулевое. Обходим.
	;  Странно если это произойдет, но пусть будет. 
	bz _skipOut  

		; Начинаем посылку ослабления на аттенюатор
		lfsr	0, Buffer_In_00+3
		movf	INDF0, 	w
		
		; Установка ослабления аттенюатора	; может можно сразу и сохр, хотя если исп. одна ф, то
		mCall	pA_pub_setGainDigAtt;(W/void)
			; вызов защищенный, поэтом в акк. должно остаться пол. зн. ослабления
		; Запись в EEPROM полученного ослабления
		movff	Buffer_In_00+3, WREG
		mCall 	pA_pub_saveGain;(W/EEPROM[h01_00])
		
		;// Состояние <- не получали
		movlw 	NO_OBTAINED
		movwf	State_setGainAtt
		
		; Возвращаем указатель чтения обратно, что возможно и не нужно
		;   но пусть пока будет
		lfsr	0,	Buffer_In_00+2

_skipOut:	;// В любом случае выходим. Дальше идти смысла нет
	return  
	
_bypass:  ;// продолжаем анализировать тип сообщения

; Тип сообщения - комманда
	movlw	TYPE_MSG_CMD
	xorwf	INDF0,w
	btfss	STATUS,Z
		retlw	VOID
	lfsr	0,Buffer_In_00+3	; +0 Данные в сообщении!

; igor 170412
; Пришла ли комманда подготовки к записи ослабления в атт.?
; Если да :
;   ждем сообщения со значение ослабления
; 0x03 0x40 wait.. 0x03 value
; Cама комманда хранится по INDF0
	movlw	TYPE_MSG_CMD_SET_ATT_STAGE1	
	xorwf	INDF0,w
	; если ноль (Z = 1), то это она
	; Z=0, результат не нулевой - значит нет и выходим
	bnz 	_bypassSetState
		; Действия по приходу комманды ожидания смены ослабления
		; Состояние <- Получена
		; Можно и инкремент, но тогда нужно инициализировать переменную
		movlw 	OBTAINED 
		movwf	State_setGainAtt
		return
_bypassSetState:	;// продолжаем
; igor 170412
	
; Обработка уже конкретной комманды (не признака)
	; получили комманду включится?
	movlw	0xA0  
	xorwf	INDF0,w		; сравниваются данные по косвенному адресу и аккамулятор
	btfsc	STATUS,Z
		mSlideTo	_v#v(UP)_TASK_SETuw_On;(void/void) * 

	; получили комманду вЫключится?
	movlw	0xA1
	xorwf	INDF0,w
	btfsc	STATUS,Z
		mSlideTo	_v#v(UP)_TASK_SETuw_Off;(void/void) *

	; "Запереть"
	movlw	0x1F
	xorwf	INDF0,w
	btfsc	STATUS,Z
		mSlideTo	_v#v(UP)_TASK_SETuw_Lock;(void/void) *

	; "Отпереть"
	movlw	OPEN_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
		mSlideTo	_v#v(UP)_TASK_SETuw_UnLock;(void/void) *

	; сбросить параметры - какие еще параметры?
	movlw	RST_PARAMETERS
	xorwf	INDF0,w
	btfsc	STATUS,Z
		mSlideTo	_v#v(UP)_TASK_SETuw_Reset;(void/void) *

	; Здесь будет выявление команды номера канал
	; в новой версии частота?
	movlw	0x6B-1	; 0x6A = 0110_1010
	;skip if (f) > (W)
	cpfsgt	INDF0	; проверка границы - защита от случайных данных
		bra		_Tune	; value <= 0x6A
	movf	INDF0,w
	addlw	d'21'-0x6B
	mSlideTo	_v#v(UP)_TASK_SETuw_wChannelCom;(byte/void) 

; обработка прочих содержаний комманд
_Tune:
	movf	INDF0,w	; value <= 0x6A - передается с чистом виде!! но вот что происходит дальше!! - вопрос!
	mSlideTo	_v#v(UP)_TASK_SETuw_wTuneCom;(w/void)
;/// Анализатор принятого байта

;/// похоже на функцию отправка байтов на комп. Очень важная
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	...	!	TooOldbyte_Out	!	Oldbyte_Out	!	Newbyte_Out	!	...
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
_v#v(HERE)_COMP_SETuw_ByteOut;(void/void)
	mObject_sel	THIS
	movff	Oldbyte_Out, TooOldbyte_Out
	movff	Newbyte_Out, Oldbyte_Out		; перевод принятого байта из разряда нового в старые
	tstfsz	Number_Out_Max
	bra		_transmit
	tstfsz	Number_Out
	bra		_DecandcCash
	;// внутри есть return! стопорим, по прерыванию
	mSlideTo	_v#v(DOWN)_PIO_SETdw_Uart2StopTx;(void/void)	

_transmit:
	movf	TooOldbyte_Out,w	; детектирование правдоподобия преамбулы
	xorlw	0xAA
	bnz		_Non_framer
	movf	Oldbyte_Out,w
	xorlw	0x55
	bnz		_Non_framer
	
_framer:
	movff	Number_Out_Max,Number_Out
	clrf	Checksum_Out
	bra		_Cash_Out
	
_Non_framer:
	movf	Oldbyte_Out,w
	xorlw	0xAA
	bnz		_ordout
	movlw	0x55
	tstfsz	Number_Out
	movlw	0x00
	movwf	Newbyte_Out
	bra		_cash_Out_IRQ
	
_ordout:
	decf	Number_Out,w							
	bnz		_Cash_Out
	clrf	Number_Out_Max
	movff	Checksum_Out,Newbyte_Out
	bra		_cash_Out_IRQ
	
_Cash_Out:
	lfsr	1,Buffer_Out_00
	movf	Number_Out,w
	subwf	Number_Out_Max,w
	movf	PLUSW1,w
	movwf	Newbyte_Out
	addwf	Checksum_Out,f
	
_DecandcCash:
	decf	Number_Out,f

_cash_Out_IRQ:
	movf	Newbyte_Out,w  ;// загружаем в аккамулятор байт для передачи
			
	;// Отправка следующего байта - return внутри!
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wUart2NextTx;(byte W/void)


	end