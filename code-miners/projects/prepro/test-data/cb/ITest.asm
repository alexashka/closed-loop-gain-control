

Object	code

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
	cpfseq xxx	;!!!
	mSlideTo	_COMP_ByteError
	
_ordin:
	decfsz	Number_In,f		;уже принятый байт в буфер
	bra		_Cash_In		;декремент счетчика принимаемых данных

_EOFbyte:	
	movf	Newbyte_In,w
	cpfseq	Checksum_In
	bra		_cash_In_IRQ
	;mS lideTo	_COMP_Com_Process  ; g oto к обработке?
	mSlideTo	_COMP_Com_Process  ; g oto к обработке?
	
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

	movlw	0x1F	; магическое число из протокола обмена
	xorwf	Buffer_In_00+1,w	; Buffer_In_00 - указатель?
	btfss	STATUS,Z	; ветвление, вернее обход
	retlw	VOID

	lfsr	0,Buffer_In_00+2	; перемещения указателя чтения?
		;// Buffer_In_00+2 - указывает на тип сообщения
		;// Buffer_In_00+3 - указывает на данные в сообщении

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
		
	movlw	0x04
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req3;(void/void) *
	
	movlw	TYPE_MSG_CPUX_LOG 	;//0x05
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Req4;(void/void) *
; ответы на запросы

	movlw 	TYPE_MSG_VALUE_ATT_GAIN
	xorwf 	INDF0, 	w
	bnz 	_bypass2  ;// Если не оно, обходим обработку 
	
	;// Проверяем состояние автомата 
	movf 	State_setGainAtt, w	
	
	;// Комманда не была получено - состояние нулевое. Обходим.
	;//  Странно если это произойдет, но пусть будет. 
	bz _skipOut  

	;// Начинаем посылку ослабления на аттенюатор
	;// Установка ослабления аттенюатора, хорошо бы отсюда вынести куда либо!
	;// i2c send
	call    _v#v(DOWN)_PIO_SETdw_I2CMIntStart	; 150811 инициализация аттенюатора
	movlw 	ADD_ATT
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 
	movlw 	OUT_TO_PORT1  ;//OUT_TO_PORT0?	;// выдаем на PORT 1 данные? почему эта комманда а не 0x02?
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 

	;// Перемещаем указатель чтения входного буффера на шаг вперед
	;// Берем значение ослабления по этому указателю
	;//   и отправляем его в аккамулятор, а затем к распределителю
	lfsr	0, Buffer_In_00+3
	movf	INDF0, 	w
	call	_v#v(DOWN)_PIO_SETdw_I2CMIntPut 

	;// Посылка завершена
	call   _v#v(DOWN)_PIO_SETdw_I2CMIntStop 
	;/// i2c send

	;// Запись в EEPROM полученного ослабления
	lfsr	0, Buffer_In_00+3	;// может излишне, но пусть будет
	movf	INDF0, 	w
	call 	_v#v(HERE)_EC_SaveValAtt
	
	;// Состояние <- не получали
	movlw 	NO_OBTAINED
	movwf	State_setGainAtt
	
	;// Возвращаем указатель чтения обратно, что возможно и не нужно
	;//   но пусть пока будет
	lfsr	0,	Buffer_In_00+2

_skipOut:	;// В любом случае выходим. Дальше идти смысла нет
	return  
	
_bypass2:  ;// продолжаем анализировать тип сообщения
;///
;///
;/// /// ///

;/// Тип сообщения - комманда
	movlw	TYPE_MSG_CMD	
	xorwf	INDF0,w
	btfss	STATUS,Z
	retlw	VOID
	lfsr	0,Buffer_In_00+3

;// igor 170412
;// Пришла ли комманда подготовки к записи ослабления в атт.?
;// Если да :
;//   ждем сообщения со значение ослабления
;// 0x03 0x40 wait.. 0x03 value
;// Cама комманда хранится по INDF0
	movlw	TYPE_MSG_CMD_SET_ATT_STAGE1	
	xorwf	INDF0,w
	;// если ноль (Z = 1), то это она
	;// Z=0, результат не нулевой - значит нет и выходим
	bnz 	_bypassSetState
	;// Действия по приходу комманды ожидания смены ослабления
	;// Состояние <- Получена
	;// Можно и инкремент, но тогда нужно инициализировать переменную
	movlw 	OBTAINED 
	movwf	State_setGainAtt
	return
_bypassSetState:	;// продолжаем
;// igor 170412
	
;// Обработка уже конкретной комманды (не признака)
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

	;// запереть МИП
	movlw	0x1F
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Lock;(void/void) *

	;// Отпереть МИП
	movlw	OPEN_MIP
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_UnLock;(void/void) *

	;// сбросить параметры
	movlw	RST_PARAMETERS
	xorwf	INDF0,w
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_SETuw_Reset;(void/void) *
	

; Здесь будет выявление команды номера канал
;// в новой версии частота?
	movlw	0x6B-1
	cpfsgt	INDF0
	bra		_Tune
	movf	INDF0,w
	addlw	d'21'-0x6B
	mSlideTo	_v#v(UP)_TASK_SETuw_wChannelCom;(byte/void) 			


_Tune:	;// обработка прочих содержаний комманд
	movf	INDF0,w
	mSlideTo	_v#v(UP)_TASK_SETuw_wTuneCom;(byte/void) *
;/// Анализатор принятого байта
;///
;/// /// ///

end