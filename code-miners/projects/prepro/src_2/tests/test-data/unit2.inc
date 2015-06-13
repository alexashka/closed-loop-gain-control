;/**
;  HOT- жара
;
;  Вывода через Usart похоже нет
;*/
;NOTE:	закомментир блок исключения показаний T=85
;..\headers\hot.inc

	constant	HERE=2
#define		_v2_HOT	_v2_HOT
#define		THIS	_v2_HOT
;..\headers\user_modes.inc

; format - Ok
	radix dec
constant		UPNUM		=		1
; aUnit testing
;#define testI2C_INT
	; Минимальный тест.
	; Step0:
	;   1.Включить
	;   2. Попробовать отпереть
	;      потребует установить частоту
	;   3. Установить частоту
	;   4. Попытка отпереть должна пройти
	;     Point : Включено и отперт
	; Step1:
	;   1. Point
	;   2. Запереть и выключить
	; Step2:
	;   1. Point
	;   2. Отказ по напряжению сделать
#define ZOND
;#define ATT_6DB
;#define ATT_3DB

; aDebug directives
;#define DBG_USM	; вывод в окно УП смещения корр и некорр
;#define DBG_ACS
;#define DBG_U_MIP
;#define VUM_DBG	; подмена данных +igor
#define VUM_TEMPER_DBG	; подмена данных +igor заменяем порог отказа по темпер.
#ifdef VUM_TEMPER_DBG
	#define TERM_THRESHOLD 32 ; oC порог срабатывания отказа по темпертуре
#else
	#define TERM_THRESHOLD 86 ; oC порог срабатывания отказа по темпертуре
#endif
;#define otladka
;#define otladka_INFO_ASKdw_CurShiftedW	; одну из деректив отладки оставляем(отвечает за опрос устр. по i 2c)

;/// Главные настройки проекта
;#define bootloader
;#define WithDetector

#define	_2Ublock
;#define _3Ublock	;для половины 3U блока раскоментарить след строку!!! +180511
;#define _3U_polovina_block	; +180511 andrey +ifdef in _V3_INFO.asm
;#define PEEP_ON		; включение пиликанья

; Напряжение питания 
#define _Umip42V		;для перекл порога по МИП на +42(+13%/-15%) V	 +020312
;#define _Umip48V		;для перекл порога по МИП на +48(+13%/-15%) V	 +020312
;#define TM_500W		; мощности
#define TM_250W
;#define TM_100W

; Пороги по току
#ifdef TM_500W
	#define CURRENT_THRESHOLD 0xA9F	; порог по току
#endif
#ifdef TM_250W
	#define CURRENT_THRESHOLD 0x855	; 10 А
#endif
#ifdef TM_100W
	#define CURRENT_THRESHOLD 0x49B	; порог по току
#endif

#define TH_TATT 0xFFF;4095;

; Порог по напряжению
#ifdef	_Umip42V
	#define VOLTAGE_THRESHOLD 0xDA5
#endif
#ifdef	_Umip48V
	#define VOLTAGE_THRESHOLD 0xF9C
#endif

; виртуальность
#define VUM		; +igor
#define UKV_ARU		; пусть будет один тип сообщения - 

; /// Прочие! перенесены ниже
; модели передачи
;#define _Uniplex	; при активировании переключение Дупл/полудупл - внешней перемычкой.
					;   При деактивации режим Дупл/полудупл выбирается в _duplex
#define _duplex		; (при НЕактивной _Uniplex)при активировании контроллер на выв. 
					;   DUX устан. лог 0 (Дуплекс=const)/при деактивации на DUX лог 1(полудупл). 
					;   От внешних перемычек не зависит 
;#define DVBT2bred_		;задержка отпирания атт (около 6,0 с) при появлении Рвх (_V3_BUM)
#define	manyBUM_OFF_bDE		; активировать!!!, для многоблочных ПРД 
							;   (коммутируем передатчик485 для передатчиков, где >1 БУМа,а для 100вт - 
							;   MAX1485 вкл на передачу постоянно!
;#define NO_BOARD
;#define RawDetData

; связано с вентиляторами
;#define fullspeed
;#define liqiud600
;#define air600
#define air100

; пороги отказов по температуре


;..\headers\g_consts.inc


#ifdef		_3U_polovina_block
	constant	MINUMDOPTOON	=	3	
#endif	
#ifdef		_3Ublock
	constant	MINUMDOPTOON	=	2;1;5
#endif
#ifdef		_2Ublock
	constant	MINUMDOPTOON	=	2;1;2
#endif

	constant	DOWN			=	HERE-1;
	constant	UP				=	HERE+1;
	constant	VOID			=	0
	constant	TRUE			=	0x00
	constant	FALSE			=	0xFF
	constant	SLOMAN			=	0xFF
	constant	NORMA			=	0
	constant	YES				=	0
	constant	NO				=	0xFF
	constant	EOF				=	0x55
	constant	MAXNUMBERBYTE	=	88
;..\headers\objects_macro.inc

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

;/// просто вызов функции? Danger!!! не менять ничего
mSlideTo	macro	Link
	goto	Link
endm
;/// ///

;// вызовы прдпрограмм
;mRetIfF?	macro	link
mRetIfF	macro	link
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
;	i f s = 1
;		(W) > WS,
;		(STATUS) > STATUSS,
;		(BSR) > BSRS
;Syntax: RETURN {s}
;Operands: s ? [0,1]
;Operation: 
;	(TOS) > PC,
;	i f s = 1
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
; !! не менят ничего
mCall		macro 	link
	call link
			endm
#endif	;OBJ_MAC
;..\headers\registry.inc

;/**
;  похоже зарегистрированы все используемые в проекте функции
;  нет, те что могут быть видемы из модулей другим модулям
; Ok
;*/
;..\aUnit\Zonds.inc

; передачи интерйесов для зондирования
#ifdef	ZOND
	;#define Z_I2C	; отлаживаем i2c iface
	;#define Z_ROLL	; тестирование управления скоростью вентеляторов
	;#define Z_T_ALR	; 
	;#define Z_TERM_CORR
	;#define Z_T_ALR_FALL	; что происходит по заднему фронту аварии темп. есть ошибка
	;#define Z_ARU
	;#define Z_SION	; сигнализации включенности смещения
	;#define Z_FIND
	#define Z_I2C_ERR
#ifdef DBG_ACS
	#define Z_ADC_D	; отладка внешного асе
#endif
#ifdef DBG_U_MIP
	#define Z_U
	#define Z_U_OBS
#endif
	;#define Z_VUM
	;#define Z_STATE
	
	; куда шлется сообщение - вернее вместо какого
	#define M1_ZOND	; 
	;#define M2_ZOND	; 
#endif

#ifdef ZOND
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZfsr07z0;(FSR0(+0-+11)/void)
	; info
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_BUM,	getZ0;(void/W)
	
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ3;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ4;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ5;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ6;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	getZ7;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ3;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_INFO,	setZ0;(void/W)
	
	;mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0Z0;(FSR0(+0)/void)
	;mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0Z1;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0W0;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0W1;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0W2;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZFSR0W3;(FSR0(+0)/void)
	
	mEXTENDS 	IO_ZOND,	_v3_BUM,	setZFSR0W2;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZFSR0W2;(FSR0(+0)/void)
	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZFSR0W1;(FSR0(+0)/void)
	
	mEXTENDS 	IO_ZOND,	_v3_BUM,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_BUM,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_BUM,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_BUM,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	_v3_COMP,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_COMP,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_COMP,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v3_COMP,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_KPUP,	setZ3;(void/W)

	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_PIO,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	_v4_TASK,	setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	_v4_TASK,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v4_TASK,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v4_TASK,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	_v2_HOT,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_HOT,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	_v2_HOT,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	ON_IRQ_EVENTS,	setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	ON_IRQ_EVENTS,	setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	ON_IRQ_EVENTS,	setZ3;(void/W)
	
	mEXTENDS 	IO_ZOND,	IO_I2C,		setZ0;(void/W)
	mEXTENDS 	IO_ZOND,	IO_I2C,		setZ1;(void/W)
	mEXTENDS 	IO_ZOND,	IO_I2C,		setZ2;(void/W)
	mEXTENDS 	IO_ZOND,	IO_I2C,		setZ3;(void/W)
#endif
;..\headers\registry_i2c.inc

; функция потока
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntInit

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntReStart

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS	PRE_AMPLIFIER,	_v3_BUM,	pA_pub_setGainDigAtt; (W/void)
mEXTENDS	PRE_AMPLIFIER,	_v3_COMP,	pA_pub_setGainDigAtt; (W/void)
mEXTENDS	PRE_AMPLIFIER,	_v3_BUM,	pA_pub_initAttExchange;(void/void)
mEXTENDS	PRE_AMPLIFIER,	_v4_TASK,	pA_pub_setAttOpen;(void/void)

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntGet
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntSetGetCount
mEXTENDS 	_v2_PIO		,	IO_I2C		,	_v2_PIO_SETdw_I2CMIntGet
mEXTENDS 	_v2_PIO		,	IO_I2C		,	_v2_PIO_SETdw_I2CMIntSetGetCount


mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntDiscardBuf

mEXTENDS 	_v2_PIO,	_v3_COMP, 	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntReStart





; 
mEXTENDS 	IO_I2C,	_v3_BUM,	io_I2C_jumperReadNowBlinkDio;()
mEXTENDS 	IO_I2C,	_v3_BUM,	io_initI2cTxRxInBoard;()

; igor's
;mEXTENDS 	_v3_BUM,	_v4_TASK,	task_onEventShiftOn;(void/void)
;mEXTENDS 	_v3_BUM,	_v4_TASK,	task_onEventShiftOff;(void/void)
;mEXTENDS 	_v4_TASK,	_v2_KPUP,	_v4_TASK_HLTuw_wShiftOff;(void/void)
;mEXTENDS 	_v4_TASK,	_v2_KPUP,	_v4_TASK_HLTuw_wShiftOn;(byte W/void)
;mEXTENDS 	_v4_TASK,	_v3_BUM,	_v4_TASK_HLTuw_wShiftOff;(void/void)
;mEXTENDS 	_v4_TASK,	_v3_BUM,	_v4_TASK_HLTuw_wShiftOn;(byte W/void)

#define MOVE_CODE
#ifdef MOVE_CODE
	;mEXTENDS	_v2_PIO, KPUP_LOW_LEWEL, _ADT7516load
	;mEXTENDS	_v2_PIO, KPUP_LOW_LEWEL, _ADT7516_Dload
	mEXTENDS	_v2_PIO, KPUP_LOW_LEWEL, _SPI_SET_wByteIn;(w?/?)
	mEXTENDS	_v2_PIO, KPUP_LOW_LEWEL, _SPI_GET_ByteOutW;(?/w?)
	mEXTENDS KPUP_LOW_LEWEL, _v2_PIO,	pio_priv_confExternADC;()
	;messg compil Reg
	mEXTENDS 	_v2_KPUP,	PRE_AMPLIFIER,	_v0_SaveValAtt_IO_EEPR0M;(W/EEPROM[h01_00])
	mEXTENDS 	_v2_KPUP,	PRE_AMPLIFIER,	_v0_LoadValAtt_IO_EEPROM;
	mEXTENDS 	PRE_AMPLIFIER,	_v3_COMP,	pA_pub_saveGain;(w/void/[])
	mEXTENDS 	PRE_AMPLIFIER,	_v3_BUM,	pA_pub_loadGain;(w/void/[])
	;++++++++++++++270312 Andrey
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_INT32;(void/void)
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_FLO32;(void/void)
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_FPM32;(void/void)
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_fWord_to_Aarg;(*FSR0/void)
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_fK_to_Barg;(*FSR0/void)
	mEXTENDS 	_v2_MATH,	_v2_KPUP		,	_v2_MATH_SETdw_fAarg_toWord;(*FSR0,2/void)
	;++++++++++++++end 270312 Andrey
	mEXTENDS	_v2_MATH, _v2_KPUP,	math_pub_fAarg_toWord;(void/fsr0)
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_wADCstart;(byte W/void)
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516ReadStart;(void/void)
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516ReadAIN1F;(void/mass FSR0)	
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516ReadAIN2F;(void/mass FSR0)		
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516ReadAIN4F;(void/mass FSR0)	
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v3_BUM		,	_v2_PIO_SETdw_ADT7516ReadToF;(void/mass FSR0)
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516_DReadAIN1F;(void/mass FSR0)	
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516_DReadAIN2F;(void/mass FSR0)	
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v3_BUM		,	_v2_PIO_SETdw_ADT7516_DReadAIN4F;(void/mass FSR0)	
	mEXTENDS 	KPUP_LOW_LEWEL		,	_v2_KPUP		,	_v2_PIO_SETdw_ADT7516_DReadStart;(void/void)
	;mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_SETdw_RequestStatus;(void/void)
	;mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_SETdw_RequestAlarm;(void/void)
	mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_SETdw_wCom;(byte W/void)	
	mEXTENDS 	_v2_KPUP,	_v4_TASK 	,	kp_pub_UnLock;(void/void)
	mEXTENDS	_v2_KPUP,	_v4_TASK 	,	kp_pub_Lock;(void/void)
	mEXTENDS 	_v2_HOT,	_v2_KPUP,	_HOT_GET_DS1821
	mEXTENDS 	_v2_PIO		,_v2_KPUP		,	_v2_PIO_SETdw_UpAlrPinReset;(void/void)
	mEXTENDS 	_v2_KPUP,	_v3_BUM, kpup_prv_rstUP;(void/void/[])
	mEXTENDS 	_v2_KPUP,	_v3_BUM, kpup_prv_reqestToUP;(void/void/[])
	mEXTENDS 	_v4_TASK	,	_v2_KPUP		,	_v4_TASK_HLTuw_wReset;(byte W/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_wReset;(byte W/void)
	;mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_Lock;(void/void)
	;mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_UnLock;(void/void)
	mEXTENDS 	_v2_KPUP		,	_v4_TASK	,	_v3_BUM_SETdw_FastLock;(void/void)
#endif

mEXTENDS _v3_BUM, 	_v4_TASK, 	bum_pub_shiftOnI2C;(w/void)
mEXTENDS _v3_BUM, 	_v4_TASK, 	bum_pub_shiftOffI2C;(w/void)
mEXTENDS _v2_KPUP,	_v4_TASK,	kpup_pub_shiftOn;(void/void)	; верхние две вызывают косвенно нижние две
mEXTENDS _v2_KPUP,	_v4_TASK,	kpup_pub_shiftOff;(void/void)
mEXTENDS _v2_KPUP,	_v4_TASK,	Iv0_KPUP_ShiftOff;(void/void)
mEXTENDS _v2_KPUP,	_v4_TASK,	Iv0_KPUP_ShiftOn;(void/void)
;mEXTENDS _v3_INFO,	_v3_BUM,	_v3_INFO_GETdw_CurUmNumW;(void/byte W)
#ifdef VUM
	mEXTENDS 	ON_IRQ_EVENTS,	_v3_BUM,	onEv_MockI2CMIntISR;(void/void)
	mEXTENDS 	_v2_PIO,	ON_IRQ_EVENTS,	pio_pub_oneBuff2OKOneBuff;(fsr0/void)
	mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kpup_pub_resetAlrmsArrayUp;(void/void/[arrayUp])
	mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kpup_pub_getArrayUp;(void/fsr0)
	mEXTENDS 	_v2_PIO,	ON_IRQ_EVENTS,	pio_pub_getMockBuff;(void/fsr0)
	mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kp_pub_jumperReadYes;(void/w(bool)/[])
	mEXTENDS	_v2_KPUP,	_v3_BUM,	kpup_pub_getArrayUp;(void/fsr0)
	mEXTENDS	_v2_KPUP,	_v3_BUM,	kpup_pub_getNumRec;(void/fsr0)
#endif
; onEventsRef
mEXTENDS 	ON_IRQ_EVENTS,	_v1_IRQ,	onEv_ADCInt;(void/void)
mEXTENDS 	ON_IRQ_EVENTS,	_v1_IRQ,	onEv_I2CMIntISR;(void/void)
;mEXTENDS 	_v3_BUM		,	_v2_PIO,	_v3_BUM_HLTuw_fADC;(word fsr0/void)
mEXTENDS 	_v4_TASK,	ON_IRQ_EVENTS,	_v4_TASK_HLTuw_wRequest;(mass FSR0/void)

mEXTENDS 	_v3_BUM,	_v2_PIO,	_v3_BUM_HLTuw_Requested;(void/void)	; пока нужен - фиктивный опрос вызывает
mEXTENDS 	_v3_BUM,	ON_IRQ_EVENTS,	_v3_BUM_HLTuw_Requested;(void/void)

mEXTENDS 	_v3_BUM,	ON_IRQ_EVENTS,	_v3_BUM_HLTuw_NotRequested;(void/void)
mEXTENDS 	_v3_BUM,	ON_IRQ_EVENTS,	_v3_BUM_HLTuw_ErrorRequested;(void/void)	
mEXTENDS 	_v3_BUM,	ON_IRQ_EVENTS,	_v3_BUM_HLTuw_BusCollision;(void/void)	
mEXTENDS 	_v4_TASK,	_v3_BUM,	_v4_TASK_HLTuw_wRequest;(mass FSR0/void)
mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kpup_pub_arrayFormer;(?/?)
mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kpup_pub_runADCFromIRQ;(fsr0+0/void)
mEXTENDS	_v2_KPUP,	ON_IRQ_EVENTS,	kpup_pub_doOnIt;(fsr0+0+1/w)
; функции из нижнего уровня
mEXTENDS 	_v2_PIO,	ON_IRQ_EVENTS,	pio_pub_metroStep0;(void/fsr0+0+1)
mEXTENDS 	_v2_PIO,	ON_IRQ_EVENTS,	pio_i2c_request;(void/w, fsr0)

; Передаем функции из мат. файла в обертку
mEXTENDS	_v2_KPUP, 	_v3_BUM	,	kp_pub_processingByteFromBridge0;(w/kpupStatus)
mEXTENDS 	_v2_MATH, 	_v3_INFO,	_v2_MATH_SETdw_wByte_to_Aarg;(byte/void)
mEXTENDS 	_v2_MATH, 	_v3_INFO,	_v2_MATH_SETdw_FLO32
mEXTENDS 	_v2_MATH,	_v3_INFO,	_v2_MATH_SETdw_fWord_to_Aarg;(*FSR0/void)
mEXTENDS 	_v2_MATH,	_v3_INFO,	_v2_MATH_FPA32;(void/void)

mEXTENDS 	_v2_MATH, 	_MATH_WRAPPER,	_v2_MATH_SETdw_wByte_to_Aarg;(byte/void)
mEXTENDS 	_v2_MATH, 	_MATH_WRAPPER,	_v2_MATH_SETdw_FLO32
mEXTENDS 	_v2_MATH,	_MATH_WRAPPER,	_v2_MATH_SETdw_fWord_to_Aarg;(*FSR0/void)
mEXTENDS 	_v2_MATH,	_MATH_WRAPPER,	_v2_MATH_FPA32;(void/void)

mEXTENDS	_v2_MATH,	_MATH_WRAPPER,	getFullA_MATH;(io - FSR0 4 byte/)
mEXTENDS	_v2_MATH,	_MATH_WRAPPER,	get2LowBytesA_MATH;(io - FSR0 2 byte/)

; Из обертки для математической библиотеки в целевой модуль

mEXTENDS	_v2_KPUP, 		_v3_BUM	,	_v0_doCorrAUsmAndSetIt_KPUP;(w/send to DAC)
mEXTENDS	_v2_KPUP, 		_v3_BUM	,	_v0_doCorrBUsmAndSetIt_KPUP;(w/send to DAC)


mEXTENDS	_MATH_WRAPPER,	_v2_KPUP, 	_v0_doTemperCorrectUsm_MATH_WRAPPER;(w, FSR0(WORD = +0+1 = LH)/ FSR0(WORD = +0+1 = LH))

mEXTENDS 	_v3_INFO	,	_v3_BUM,	_v3_INFO_SETdw_fCurUmReqOk;(byte W/void)
mEXTENDS 	_v3_INFO	,	_v3_BUM,	_v3_INFO_NEWdw_NextUmRefshNum

; разслоенный KPUP
; выделение нижнего слоя в kpup
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fAD8402LoadCHA;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fAD8402LoadCHB;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fAD8522LoadCHA;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fAD8522LoadCHB;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHA;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHB;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHC;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHD;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHA;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHB;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHC;(mass FSR0/VOID)
;mEXTENDS	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHD;(mass FSR0/VOID)

mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fAD8402LoadCHA;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fAD8402LoadCHB;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fAD8522LoadCHA;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fAD8522LoadCHB;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHA;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHB;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHC;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516LoadCHD;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHA;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHB;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHC;(mass FSR0/VOID)
mEXTENDS	KPUP_LOW_LEWEL,	_v2_KPUP,	_v2_PIO_SETdw_fADT7516_DLoadCHD;(mass FSR0/VOID)

mEXTENDS 	_v3_BUM		,	_v4_TASK,	_v3_BUM_SETdw_WireCom;(void/void)
mEXTENDS 	_v3_BUM,		_v3_CLK,	_v3_BUM_SETdw_WireCom;(void/void)

; управления смещением в УП
mEXTENDS 	_v2_PIO,	_v2_KPUP,	_v2_PIO_SETdw_HMC542_wLoad;(byte/void)

mEXTENDS 	_v2_HOT,	_v2_KPUP,	_v0_hot_getTermAlrmMask;(void/w)
; 
mEXTENDS	_v2_HOT,	_v3_BUM,	hot_public_testTempFront;(void/w)
;mEXTENDS	_v4_TASK,	_v3_BUM,	onDisappearTemperAlrm;(void/void) ; после некоторый странностей
mEXTENDS	_v4_TASK,	_v2_HOT,	onDisappearTemperAlrm;(void/void)

; другой аттенюатор
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AttLockWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	task_onAttLockWait_Temper;(void/void)
	; другой аттенюатор
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AttLockWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	clk_runAttLockWait_Temper;(void/void)
	

	
mEXTENDS	_v4_TASK,	_v3_CLK,	task_prv_onShiftOned;(void/void)
mEXTENDS	_v3_CLK,	_v4_TASK,	clk_delayEventShuftOned;(void/void)


mEXTENDS	_v2_KPUP,	_v3_INFO,	kp_pub_testOnShift;(void/w)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v1_IRQ		,	_v0_MAIN 	,	_v1_IRQ_SETuw_ResetInt;(void/void)
	mEXTENDS 	_v1_IRQ		,	_v0_MAIN 	,	_v1_IRQ_SETuw_LowPriorInt;(void/void)
	mEXTENDS 	_v1_IRQ		,	_v0_MAIN	,	_v1_IRQ_SETuw_HighPriorInt;(void/void)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v2_PIO		,	_v1_IRQ 	,	_v2_PIO_INI

	
;/// UART's
	mEXTENDS 	_v2_PIO	, _v1_IRQ, _v2_PIO_SETuw_Uart1RxInt;(void/void)
	mEXTENDS 	_v2_PIO	, _v1_IRQ, _v2_PIO_SETuw_Uart2RxInt;(void/void)
	mEXTENDS 	_v2_PIO , _v1_IRQ, _v2_PIO_SETuw_Uart1TxInt;(void/void)
	mEXTENDS 	_v2_PIO , _v1_IRQ, _v2_PIO_SETuw_Uart2TxInt;(void/void)
;/// end UART's
	
	mEXTENDS 	_v2_PIO 	,	_v1_IRQ 	,	_v2_PIO_SETuw_Timer0Int;(void/void)
	mEXTENDS 	_v2_PIO 	,	_v1_IRQ 	,	_v2_PIO_SETuw_Timer1Int;(void/void)
	


	
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_Setlock;(void/void)
 	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_SetUnlock;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_ShiftUnlock;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_Shiftlock;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_ShiftReset;(void/void)

	
	
	;///
	;mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_P IO_SETdw_fAD8402LoadCHA;(mass FSR0/void)
	;mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_P IO_SETdw_fAD8402LoadCHB;(mass FSR0/void)
	;///
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_AdrLoadW;(void/byte W)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_ComLoadW;(void/byte W)  
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_AudioOn;(void/byte W)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_AudioOff;(void/byte W)
	;mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_GETdw_BumAlrW;(void/byte W)


	
;/// UART'
	mEXTENDS 	_v2_PIO		,	_v3_COMP 	,	_v2_PIO_SETdw_wUart2StartTx;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_COMP 	,	_v2_PIO_SETdw_wUart2NextTx;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_COMP 	,	_v2_PIO_SETdw_Uart2StopTx;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_COMP 	,	_v2_PIO_SETdw_Uart2Antifreeze;(void/void)	
	mEXTENDS 	_v2_PIO		,	_v3_BUPR 	,	_v2_PIO_SETdw_wUart1StartTx;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUPR 	,	_v2_PIO_SETdw_wUart1NextTx;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUPR 	,	_v2_PIO_SETdw_Uart1StopTx;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUPR  	,	_v2_PIO_SETdw_Uart1Antifreeze;(void/void)
;//
	
	mEXTENDS 	_v2_PIO		,	_v3_BUPR  	,	_v2_PIO_SETdw_AdrLoadW;(VOID/byte W)	
	mEXTENDS 	_v2_PIO		,	_v3_CLK		,	_v2_PIO_SETdw_Timer0Enable;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_CLK		,	_v2_PIO_SETdw_Timer1Enable;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_CLK		,	_v2_PIO_SETdw_Timer0Disable;(void/void)
	mEXTENDS 	_v2_PIO		,	_v3_CLK		,	_v2_PIO_GETdw_Timer0ReadF;(VOID/mass FSR0)	
	mEXTENDS 	_v2_PIO		,	_v3_MIP		,	_v2_PIO_SETdw_wMipControl;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_MIP		,	_v2_PIO_ASKdw_MipNormaW;(void/bool W)
	mEXTENDS 	_v2_PIO		,	_v3_LED		,	_v2_PIO_SETdw_wLedControl;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_LED		,	_v2_PIO_SETdw_wLedAlrOn;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_LED		,	_v2_PIO_SETdw_wLedAlrOff;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v2_HOT		,	_v2_PIO_SETdw_wLedAlrOff;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_wLedAlrOn;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_wLedAlrOff;(byte W/void)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_wFlowOn;(byte/byte W)
	mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_ComLoadW;(VOID/byte W)
	mEXTENDS 	_v2_PIO		,	_v3_BUPR	,	_v2_PIO_SETdw_wLedAlrOn;(byte W/void)
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_INI


	mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_SETdw_wSetChannel;(void/void)
	mEXTENDS 	_v2_KPUP,	_v3_BUM 	,	_v2_KPUP_SETdw_wSetMode;(byte/void)			
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mEXTENDS 	_v3_COMP	,	_v2_PIO 	,	_v3_COMP_SETuw_wByteIn;(byte W/void)
	mEXTENDS 	_v3_COMP	,	_v2_PIO 	,	_v3_COMP_SETuw_ByteOut;(void/void)
	mEXTENDS 	_v3_COMP	,	_v2_PIO 	,	_v3_COMP_SETuw_ByteError;(void/void)
	mEXTENDS 	_v3_COMP	,	_v2_PIO 	,	_v3_COMP_SETuw_BufFull;(void/void)	
	mEXTENDS 	_v3_COMP	,	_v4_TASK	,	_v3_COMP_INI
	mEXTENDS 	_v3_COMP	,	_v4_TASK 	,	_v3_COMP_SETdw_wfSendMessage1;(byte w,mass FSR0/void)
	mEXTENDS 	_v3_COMP	,	_v4_TASK 	,	_v3_COMP_SETdw_wfSendMessage2;(byte w,mass FSR0/void)
	mEXTENDS 	_v3_COMP	,	_v4_TASK 	,	_v3_COMP_SETdw_wfSendMessage3;(byte w,mass FSR0/void)
	mEXTENDS 	_v3_COMP	,	_v4_TASK 	,	_v3_COMP_SETdw_wfSendMessage4;(byte w,mass FSR0/void)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_INI
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_wReset;(byte W/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_wRequest;(byte W/void)


	
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_AllRes;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_BeepOn;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_BeepOff;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_wTune;(byte/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_wSetChannel;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_RUNdw_SetDetToCh;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_wAnDigMode;(byte W/void) 
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_ASKdw_NeedTemperTimeW;(void/bool) 
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_ClrTemperTime;(void/void) 
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_Temper;(void/void) 
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_TemperTimeOver;(void/void)
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_wFlowOn;(byte/void)	
	mEXTENDS 	_v3_BUM		,	_v4_TASK	,	_v3_BUM_SETdw_WireCom;(void/void)



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v3_BUPR	,	_v2_PIO 	,	_v3_BUPR_SETuw_wByteIn;(byte W/void)
	mEXTENDS 	_v3_BUPR	,	_v2_PIO 	,	_v3_BUPR_SETuw_ByteOut;(void/void)
	mEXTENDS 	_v3_BUPR	,	_v2_PIO 	,	_v3_BUPR_SETuw_ByteError;(void/void)
	mEXTENDS 	_v3_BUPR	,	_v2_PIO 	,	_v3_BUPR_SETuw_BufFull;(void/void)	
	mEXTENDS 	_v3_BUPR	,	_v4_TASK	,	_v3_BUPR_INI
	mEXTENDS 	_v3_BUPR	,	_v4_TASK 	,	_v3_BUPR_SETdw_wfSendMessage1;(byte w,mass FSR0/void)
	mEXTENDS 	_v3_BUPR	,	_v4_TASK 	,	_v3_BUPR_GETdw_AdrRequestW;(void/byte)
	mEXTENDS 	_v3_BUPR	,	_v4_TASK 	,	_v3_BUPR_SETdw_wAddress;(byte/void)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v3_CLK		,	_v2_PIO 	,	_v3_CLK_HLTuw_Tick;(void/void)
;	mEXTENDS 	_v3_CLK		,	_v2_PIO 	,	_v3_C LK_SETuw_TookEnd;(void/void)
;----------------------------------------------------------
	mEXTENDS 	_v3_CLK		,	_v4_TASK	,	_v3_CLK_INI
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_MipPuskWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_MIPchWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AmpResWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_DataReqWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ShiftOnComWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_DataReq2Wait;(void/void)
	
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_UmStopComWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AmpReqStopWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_MIPchOffWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AmpReq2StopWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_BumUnLockWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_BumLockWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_Tick;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_DataRefreshWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ComOn;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ComOff;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ComUnLock;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ComLock;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ComRes;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AlarmRefreshWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_FullOfMipWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_DataReadWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_DataRead2Wait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AmpReadStopWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AmpRead2StopWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_PeepOnWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_PeepOffWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ExchLedWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AlarmRefreshWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_LockAlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ResetAlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_Request1AlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_Request2AlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_ShiftOnAfterAlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_Request3AlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_Request4AlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_UnLockAlrWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_TuneWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_LedFlash;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_SetChannelWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_SetDetToChWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_TemperWait;(void/void)	
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_AlrInterWait;(void/void)
	mEXTENDS 	_v3_CLK		,	_v4_TASK 	,	_v3_CLK_RUNdw_WireComWait

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_INI
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ComSendOn;(byte W/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ComSendOff;(byte W/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ReqSendOn;(byte W/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ReqSendOff;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_BumLock;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_BumUnLock;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_AlarmOff;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_AlarmOn;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ExchOn;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_ExchOff;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_MipOn;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_MipOff;(void/void)
	mEXTENDS 	_v3_LED		,	_v4_TASK	,	_v3_LED_SETdw_fLedMode;( *FSR0/void)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v3_MIP		,	_v4_TASK	,	_v3_MIP_INI
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_ASKdw_ReadyW;(void/bool W)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_RUNdw_Pusk;(void/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_RUNdw_MipStop;(void/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_RUNdw_wChMipOn;(byte W/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_RUNdw_wChMipOff;(byte W/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_RUNdw_AllChMipOff;(void/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_SETdw_ResetOtkazz;(void/void)
	mEXTENDS 	_v3_MIP		,	_v4_TASK 	,	_v3_MIP_SETdw_Otkazz;(void/void)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v4_TASK	,	_v1_IRQ 	,	_TASK_INI_RESET

	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_On;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Off;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Lock;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_UnLock;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Reset;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Req1;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Req2;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Req3;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_Req4;(void/void) 
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_wTuneCom;(byte/void) *
	mEXTENDS 	_v4_TASK	,	_v3_COMP	,	_v4_TASK_SETuw_wChannelCom;(byte/void)
	mEXTENDS 	_v4_TASK	,	_v3_MIP		,	_v4_TASK_HLTuw_Pusk;(void/void)*
	mEXTENDS 	_v4_TASK	,	_v3_MIP		,	_v4_TASK_HLTuw_MipStop;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_MIP		,	_v4_TASK_HLTuw_ChMipOn;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_MIP		,	_v4_TASK_HLTuw_ChMipOff;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_MIP		,	_v4_TASK_HLTuw_AllChMipOff;(void/void)
	;mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_Task_Fast
	
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_MipPuskWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_MIPchWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AmpResWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_DataReqWait;(void/void)
 	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ShiftOnComWait;(void/void)
 	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_DataReq2Wait;(void/void)
	
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_UmStopComWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AmpReqStopWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_MIPchOffWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AmpReq2StopWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_BumUnLockWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_BumLockWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ComOff;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ComOn;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ComUnLock;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ComLock;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ComRes;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_Tick;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_DataRefreshWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AlarmRefreshWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_FullOfMipWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_DataReadWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_DataRead2Wait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AmpReadStopWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AmpRead2StopWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_PeepOnWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_PeepOffWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ExchLedWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_LockAlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ResetAlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_Request1AlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_Request2AlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_ShiftOnAlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_Request3AlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_Request4AlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_UnLockAlrWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_SETuw_fCpuLoad;(mass/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_SETuw_fCpu2Load;(mass/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_TuneWait;(void/void)	
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_LedFlash;(mass/void)<<<LedFlash
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_SetChannelWait;(byte/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_GoToUnLock;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_TemperWait;(void/void)	
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_AlrInterWait;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_CLK		,	_v4_TASK_HLTuw_WireComWait


	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_wNotRequest;(mass FSR0/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_UnLock;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_Lock;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_ErrorRequest;(mass FSR0/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_Tune;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_SetChannel;(byte/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_HLTuw_SetDetToCh;(byte/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_SETuw_On;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_SETuw_Off;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_SETuw_Lock;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUM		,	_v4_TASK_SETuw_UnLock;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUPR		,	_v4_TASK_SETuw_ReqBu;(void/void)
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_On;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_Off;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_Lock;(void/void) *
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_UnLock;(void/void) * 
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_Reset;(void/void) 
	mEXTENDS 	_v4_TASK	,	_v3_BUPR	,	_v4_TASK_SETuw_wChannelCom;(byte/void)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mEXTENDS 	_v3_INFO	,	_v4_TASK	,	_v3_INFO_INI
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToOnW;(void/bool W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ComOnAccept;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_MipPusked;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_MipReady;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_CurMipChOned;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_IniOning;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_CurUmNumW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_CurMipChReady;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ResetSend;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_CLRdw_CurUmExchOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_CurUmExchOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmExchOkW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ResetSendOk;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_RequestSendOk;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurBumNormaW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ShiftOnSendOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_Request2SendOk;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurShiftedW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_CurUmOned;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryMIPwaitW;(void/bool W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryResetW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqW;(void/bool W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryRes2W;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryShiftOnComW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReq2W;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryChkShiftedW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NeedTryNextOnW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_NextUmOnNum;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_EnoughToWorkW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_BumOned	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_fCurUmReqOk;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_CurUmOffed;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_MipStop;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_AllChOff;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToOffW;(void/bool W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_ComOffAccept;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumOffSet;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_IniCurUmStopNum;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_BumLockedW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ShiftOffSend;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ShiftOffSendOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ReqSendAfterOff;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurStopedW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ShiftOffed;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmOffedOkW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_Req2SendOff;(byte W/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurDispoweredW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NeedTryNextOffW;(void/byte W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_NextUmOffNum;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_EnoughToOffW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryComStopW;(void/byte W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqStopW;(void/byte W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryStopW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReq2StopW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryOffWaitW;(void/byte W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToUnLockW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqLockW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToLockW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToResetW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToRefreshW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmReqLockOkW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_IniTryReqLock;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumReseted;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ComResAccept;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_IniTryReset;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_IniCurUmRefNum;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ReqInfoForComp1WF;(void/byte W,FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ReqInfoForComp2WF;(void/byte W,FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ReqInfoForComp3WF;(void/byte W,FSR0) *
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ReqInfoForComp4WF;(void/byte,mass FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_NextUmRefshNum;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NextUmRefshNeed;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ShiftOnSendOkW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmOnResOkW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ShiftOffSendOkW;(void/byte W)
;unlock chain
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ComUnLockAccept;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumUnLockSend;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumUnLockSendOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_BumUnLockSendOkW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_UmUnLockedW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumUnLocked;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryUnLockSendW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqUnLockW;(void/byte W)
;lock chain
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_ComLockAccept;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumLockSend;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumLockSendOk;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_BumLockSendOkW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_UmLockedW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_BumLocked;(void/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryLockSendW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqLockW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ReadyToAlrRefrW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_NEWdw_Alarm;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_NextSoundF;(void/mass FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NeedPeepW;(void/bool W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ReqInfoForBuWF;(void/byte W,mass FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryLockAlrSendW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryAlrResetW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryAlrReqW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryShiftOnAlrComW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryAlrReq2W;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryUnLockAlrSendW;(void/byte)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmMipChOnedW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_TryReqAfterRefrW;(void/bool)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_fCpuLoad;(mass FSR0/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_fCpu2Load;(mass FSR0/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_fCurUmReqError;(mass FSR0/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_wTuneCom;(byte/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NeedTuneW;(void/bool)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_TuneComW;(void/byte)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_wClearTuneCom;(byte/void)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_WasUnLockedSave;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_WasUnLockedW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_CurUmFixAlr;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_CurUmNoAlr;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurUmWasAlrW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_LedModeF;(void/*FSR0)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_wChannel;(void/byte)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_ChannelW;(void/byte)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_ChannelBusy;(void/byte)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_CurAlrHotterW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_CLRdw_Channel;(void/void) 
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_AlrInterStart;(void/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_AlrInterOut;(void/void) 
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_AnDigitalW;(void/byte W)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_NeedTermW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_SpeedW;(void/byte)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ComUnLockAcceptedW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ComLockAcceptedW;(void/bool)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_ASKdw_ChannelLoadedW;(void/bool W)	
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_SETdw_wAdrSet;(byte/void)
	mEXTENDS 	_v3_INFO	,	_v4_TASK 	,	_v3_INFO_GETdw_AddressW;(void/byte)
	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mEXTENDS 	_v2_HOT	,	_v3_BUM 	,	_HOT_SET_Ini
	mEXTENDS 	_v2_HOT	,	_v3_BUM 	,	_HOT_SET_DS1821

	mEXTENDS 	_v2_HOT	,	_v3_BUM 	,	_HOT_ASK_DS1821NeedTime	
	mEXTENDS 	_v2_HOT	,	_v3_BUM 	,	_HOT_CLR_DS1821NeedTime
	mEXTENDS 	_v2_HOT	,	_v3_BUM 	,	_HOT_SET_DS1821TimeOver

;++++++++++++++++++++++++++++++++++++++++++++++++++++++

	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_INT32;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_FLO32;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_FPM32;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_FPD32;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_FXD3216U;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_mov_A_B;(void/void)
	
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_wByte_to_Aarg;(byte/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_fWord_to_Aarg;(* FSR0/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_fK_to_Barg;(*FSR0/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_fDig_separL;(*FSR0/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_fDig_separH;(*FSR0/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_shift_A;(void/void)
	mEXTENDS 	_v2_MATH,	_v3_INFO	,	_v2_MATH_SETdw_User1;(void/void)



;Trash






;..\headers\engine\events.inc

#define NO_EVENT 0		; 0000_0000
#define EVENT_UP 1		; 0000_0001
#define EVENT_DOWN 2	; 0000_0010



							
#define CRC_POLY 0x18
#define	TTX_tris TRISE,2	;++060910
#define TTX_port PORTE,2 	;++060910
global	hot_readOnly_zero	; условная конструкция
;..\headers\delay_lib.inc

;********************
;  WaitLib										
;********************
variable	i=0;
DelayUs	macro	T_us
	movlw	low	T_us
Delay20MHzUs#v(i):
	clrwdt
	addlw	0xFF
	btfss	STATUS,Z
	goto	Delay20MHzUs#v(i)
	i++	
endm
;********************************************************************************
;variable	j=0;
;DELAY_US	macro	T_us
;	movlw	low	T_us
;Delay20MHzUS#v(j):;
;	clrwdt
;	addlw	0xFF
;	btfss	STATUS,Z
;	goto	Delay20MHzUs#v(j)
;	j++	
;endm



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




