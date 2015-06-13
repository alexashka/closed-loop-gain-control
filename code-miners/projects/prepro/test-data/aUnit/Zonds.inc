; #include <../headers/Zonds.ink>
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