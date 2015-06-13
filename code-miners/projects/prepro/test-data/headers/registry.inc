;/**
;  похоже зарегистрированы все используемые в проекте функции
;  нет, те что могут быть видемы из модулей другим модулям
; Ok
;*/
#include <../aUnit/Zonds.inc>
#include <../headers/registry_i2c.inc>

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


