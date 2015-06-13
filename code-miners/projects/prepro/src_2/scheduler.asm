#include "../headers/user_modes.inc"
#include "../headers/BoardMapping.h"
#define	g_bCommandReceived	g_kFlag,5			; H-Command received
#define aliasAlrmByte	g_summaryDataArray+11		; байт отказов
#define	aliasStateByte 	g_summaryDataArray+10		; байт состояния

; Data
extern g_summaryDataArray
extern g_kFlag

; Code
extern eeprom_Read;(?/?)
extern eeprom_CheckState;(?/?)
extern eeprom_Save;(?/?)

extern dac_SetChannalA;(?/?)
extern dac_SetChannalB;(?/?)
extern dac_SetChannalC;(?/?) 
extern dac_SetChannalD;(?/?)

extern lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)

; Data
global g_LAShiftValue, g_HAShiftValue, D4BL, D4BH, ILIM, DAL, DAH
; Уже потенциально опасные
global g_recievedCmd 
global g_ownI2CAddress	; безликие названия и еще и с ошибкой

; Code
global sdr_LockAndShiftOff;(?/?)
global sdr_Init;(?/?)
global sdr_Exec;(?/?)
	
mydata_i2c		idata_acs
	g_recievedCmd		res	1	;Lava-Lava command
	tmp		res	1

	DAL			res	1	;for DAC'S registers
	DAH			res 1
	DAA			res	1	;g_ownI2CAddress for D4
	Temp_DAL	res 1
	Temp_DAH	res 1
	temp_DA		res 1

	g_LAShiftValue	res	1	;D4 SM1-Value X5
	g_HAShiftValue	res	1
	D4BL		res	1	;D4 SM2-Value X6
	D4BH		res	1
	
	ILIM		res	1

	bitts		res 1
	ctc			res	1	;arifmetic Counter
	g_ownI2CAddress		res	1
	cta			res	1

	coeff 	res	1		
		;bit0-5  -макс (грубый) шаг рег смещ (резерв)
		;bit7 - флаг: H-вкл "грубо" шаг рег/L- "точно" шаг рег

Obj_I2C		code

; инициализация чего?
sdr_Init;(?/?)
	;макс шаг рег смещ (резерв)	здесь не устанавливается
	;bit7 = L "точно" рег.
	movlw	b'00100000'
	movwf	coeff		
		
	; определяем свой адрес?
	call	_sdr_GetOwnAddr;(void/void)

	; I2C initialisation
	call	_sdc_InitI2CExcange;(void/void)

	; Устанавливить порог по току
	call	dac_SetChannalA;(?/?)
	
	; Установить порог по напряжению МИП
	call	dac_SetChannalD;(?/?)

	rcall	sdr_LockAndShiftOff;(?/?)
	
	call	_sdr_ShiftOff;(?/?)
	return
	
;
_sdr_GetOwnAddr;(void/void)
#ifdef	MODE_OLD
	movlw	0x72
	btfsc	PORTB,0
#endif
#ifdef	MODE_NEW_033
	movlw	0x72
	btfsc	PORTB,2
#endif
		movlw	0x78
	btfsc	PORTB,3
		movlw	0x76
	btfsc	PORTB,4
		movlw	0x74
	movwf	g_ownI2CAddress
	return
	
_sdc_InitI2CExcange;(void/void)
	bcf		SSPCON1,SSPEN
	clrf	SSPCON2
	bcf		PIR1,SSPIF
	
	; load slave address
	movff	g_ownI2CAddress,SSPADD	;g_ownI2CAddress
 	movlw	b'00000000'
	movwf	SSPSTAT
	movlw	b'00000000'
	movlw	b'00110110'		;slave
	movwf	SSPCON1
	return
	
; Декодирует принятую от платы управления комманду
sdr_Exec;(?/?)
	; комманду приняли - сбросили флаг
	bcf		g_bCommandReceived
	movf	g_recievedCmd,w	; читаем комманду
	btfsc	STATUS,Z
		return
	addlw	-1
	btfsc	STATUS,Z
		goto	_Minus		;0x01
	addlw	-1
	btfsc	STATUS,Z
		goto	_Plus		;0x02
	addlw	-1
	btfsc	STATUS,Z
		goto	_ON	;0x03
	addlw	-1
	btfsc	STATUS,Z
		goto	sdr_LockAndShiftOff;(?/?)		;0x04
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4AMinus	;0x05
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4APlus	;0x06
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4BMinus	;0x07
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4BPlus	;0x08
	addlw	-1
	
	; комманда сохранения настроек приходит извне
	btfsc	STATUS,Z
		goto	_CurrentLimitSave		;0x09
	addlw	-1
	btfsc	STATUS,Z
		goto	_ShiftOneSave		;0x0A
	addlw	-1
	btfsc	STATUS,Z
		goto	_ShiftTwoSave		;0x0B
	addlw	-1
	
	btfsc	STATUS,Z
		goto	_S1Rest		;0x0C
	addlw	-1
	btfsc	STATUS,Z
		goto	_S2Rest		;0x0D
	addlw	-1
	btfsc	STATUS,Z
		goto	_ResAlr		;0x0E
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4APlusxK		;0x0F		шаг 1х32
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4AMinusxK		;0x10		шаг 1х32
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4BPlusxK		;0x11		шаг 1х32
	addlw	-1
	btfsc	STATUS,Z
		goto	_D4BMinusxK		;0x12		шаг 1х32
	addlw	-1
	btfsc	STATUS,Z
		goto	_ONxK		;0x13		вкл шаг 1х32 ("грубо")
	addlw	-1
	btfsc	STATUS,Z
		goto	_OFFxK		;0x14		выкл шаг 1х32 ("точно")
	return

; Интерфейсная
_sdr_ShiftOff;(?/?)
	bsf		g_bLockAtt_leg, 0	;VT2,4 open
	return

; Что-то закрывается
sdr_LockAndShiftOff;(?/?)
	bsf		g_bLockAtt_leg,0		; VT2,4 open
	call	_clearShift;(?/?)	; сброс смещения
	bcf		aliasStateByte,0
	return
	
;
_Open:
_ON:
	movf	aliasAlrmByte,w
	andlw	b'00011111'		;bit4- авар Т ! не включаем
	btfss	STATUS,Z
		return
	call	_loadShiftA;(?/?)
	call	_loadShiftB;(?/?)
	DelayUs	20		;+++1803
		bcf		g_bLockAtt_leg,0	;VT2,4 close	-отпустили атт.
	bsf		aliasStateByte,0
	return
_Plus
	movf	ILIM,w
	iorlw	0xF0
	movwf	tmp
	incf	tmp,w
	btfsc	STATUS,Z
		return
	movwf	ILIM
	goto	_PMout
	
_Minus
	movf	ILIM
	btfsc	STATUS,Z
		return
	decf	ILIM,f
	
_PMout
	bcf		CVRCON,0
	bcf		CVRCON,1
	bcf		CVRCON,2
	bcf		CVRCON,3
	movf	ILIM,w
	iorwf	CVRCON,f
	return
	
_S1Rest
	movlw	0x16
	call	eeprom_Read;(?/?)
	movwf	g_LAShiftValue

	movlw	0x17
	call	eeprom_Read;(?/?)
	movwf	g_HAShiftValue

	nop
	call	_loadShiftA;(?/?)
	return
	
_S2Rest
	movlw	0x18
	call	eeprom_Read;(?/?)
	movwf	D4BL

	movlw	0x19
	call	eeprom_Read;(?/?)
	movwf	D4BH

	nop
	call	_loadShiftB;(?/?)
	return

_ResAlr
	clrf	aliasAlrmByte		;сбросили байт отказов
	
	;сбросили триггер I?
#ifdef	MODE_4U
	bsf		PORTA,7
	nop						;сбросили триггер
	bcf		PORTA,7
#endif
#ifdef	MODE_3U
	bcf		PORTA,7
	nop						;сбросили триггер I
	bsf		PORTA,7
#endif
#ifdef	MODE_3U_NEW_ALU			;+091110
	bcf		PORTC,7
	nop						;сбросили триггер U
	bsf		PORTC,7
#endif

	;сбросили удержание в сост "откл" канала мип
#ifdef	MODE_NEW_033			
	bsf	PORTB,5	;reset OFF2
	bsf	PORTC,2	;reset OFF1
#endif

#ifdef	MODE_4U
	movlw	b'00000111'	;включение таймера для проверки дуги
	movwf	T2CON,0
	bcf		PIR1,TMR2IF
	bsf		PIE1,TMR2IE
#endif
	bsf		PIE2,CMIE
	return

_D4PlusX
	movlw	0x20	;1x32раза
	movwf	ctc
_PlusX
	call	_D4Plus
	dcfsnz	ctc,f
		return
	bra		_PlusX

_D4Plus
	movff	DAL,Temp_DAL
	incfsz	Temp_DAL,f	;DAL is 0xFF?
		bra		_PlusL	;No!, 8bit plus is possible
	btfss	bitts,0		;8bit?
		bra		_Plus8c	;yes for time!!!!!!!!!
	movf	DAH,w		;16bit op
	iorlw	0xF0		;bits 0-3 set
	movwf	Temp_DAH
	incfsz	Temp_DAH,f
		bra		_PlusH
	bra		_Plus16c		;For Test!!!!!!!
	return

_Plus8c
	bcf		g_kFlag,3
	return

_Plus16c
	bcf		g_kFlag,4
	return

_PlusL
	movff	Temp_DAL,DAL
	return

_PlusH
	clrf	DAL
	movf	Temp_DAH,w
	andlw	0x0F	;bits 0-3 clear
	movwf	DAH
	return

_D4MinusX
	movlw	0x20		;1X32раза
	movwf	ctc
_MinusX
	call	_D4Minus
	dcfsnz	ctc,f
		return
	bra		_MinusX
_D4Minus
	movf	DAL
	btfsc	STATUS,Z
	bra		_MinusH
	decf	DAL,f
	bra		_Finomat
_MinusH
	btfss	bitts,0		;8bit?
		bra		_Minus8c		;For test!!!
	movf	DAH	;16bit op
	btfsc	STATUS,Z
		bra		_Minus16c
	decf	DAH,f
	movlw	0xFF
	movwf	DAL
_Finomat
	return

_Minus8c
	bsf		g_kFlag,3
	return
_Minus16c
	bsf		g_kFlag,4
	return

; тюнер смещения
_D4APlus
	movff	g_HAShiftValue,DAH
	movff	g_LAShiftValue,DAL
	bsf		bitts,0			;16bit set
	btfss	aliasStateByte,0		;смещение подано?
		call	_D4PlusX	;нет, можем делать "грубо" рег
	btfsc		coeff,7		;|при использ комманд _ONxK/_OFFxK |	; "грубо" регулировка (шаг =1хК)bit7=H ?
		call	_D4PlusX	;|при использ комманд _ONxK/_OFFxK |	; да, была команда (шаг =1хК), можем делать "грубо" рег
	call	_D4Plus
	movff	DAH,g_HAShiftValue
	movff	DAL,g_LAShiftValue
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftA;(?/?)
		nop
	return
_D4AMinus
	movff	g_HAShiftValue,DAH
	movff	g_LAShiftValue,DAL
	bsf		bitts,0	;16bit set
	btfss	aliasStateByte,0
		call	_D4MinusX		;
	btfsc		coeff,7		;|при использ комманд _ONxK/_OFFxK |	; "грубо" регулировка (шаг =1хК)bit7=H ?
		call	_D4MinusX	;|при использ комманд _ONxK/_OFFxK |	; да, была команда (шаг =1хК), можем делать "грубо" рег
	call	_D4Minus
	movff	DAH,g_HAShiftValue
	movff	DAL,g_LAShiftValue
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftA;(?/?)
	nop
	return
; тюнер смещения
	
_D4BPlus
	movff	D4BH,DAH
	movff	D4BL,DAL
	bsf		bitts,0		;16bit set
	btfss	aliasStateByte,0
		call	_D4PlusX		;
		btfsc		coeff,7		;|при использ комманд _ONxK/_OFFxK |	; "грубо" регулировка (шаг =1хК)bit7=H ?
		call	_D4PlusX	;|при использ комманд _ONxK/_OFFxK |	; да, была команда (шаг =1хК), можем делать "грубо" рег
	call	_D4Plus
	movff	DAH,D4BH
	movff	DAL,D4BL
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftB;(?/?)
	nop
	return
	
_D4BMinus
	movff	D4BH,DAH
	movff	D4BL,DAL
	bsf		bitts,0	;16bit set
	btfss	aliasStateByte,0
		call	_D4MinusX			;
	btfsc		coeff,7			;|при использ комманд _ONxK/_OFFxK |	; "грубо" регулировка (шаг =1хК)bit7=H ?
		call	_D4MinusX	;|при использ комманд _ONxK/_OFFxK |	; да, была команда (шаг =1хК), можем делать "грубо" рег
	call	_D4Minus
	movff	DAH,D4BH
	movff	DAL,D4BL
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftB;(?/?)
	nop
	return

	
; смещения
_loadShiftA;(?/?)	; много где вызывается
	movff	g_LAShiftValue,DAL
	movff	g_HAShiftValue,DAH
	call 	lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)
	goto	dac_SetChannalB;(?/?)

_loadShiftB;(?/?)
	movff	D4BL,DAL
	movff	D4BH,DAH
	call 	lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)
	goto	dac_SetChannalC;(?/?)	; ссылка за пределами модуля, а вызывается.

_clearShift;(?/?)
	clrf	DAL
	clrf	DAH
	lfsr	0,DAL
	call	dac_SetChannalB;(?/?)
	lfsr	0,DAL
	goto	dac_SetChannalC;(?/?)
; смещения

;
_D4APlusxK
	movff	g_HAShiftValue,DAH
	movff	g_LAShiftValue,DAL
	bsf		bitts,0		;16bit set

#ifdef		MODE_4U
	btfss	aliasStateByte,0
		call	_D4PlusX
#endif
#ifdef		MODE_3U
	call	_D4PlusX
#endif

	movff	DAH,g_HAShiftValue
	movff	DAL,g_LAShiftValue
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftA;(?/?)
	nop
	return
	
_D4AMinusxK
	movff	g_HAShiftValue,DAH
	movff	g_LAShiftValue,DAL
	bsf		bitts,0			;16bit set

#ifdef MODE_4U
	btfss	aliasStateByte,0
		call	_D4MinusX		;_Minus_xK
#else
  #ifdef MODE_3U
	call	_D4MinusX
  #else
	;[Error]
  #endif
#endif

	movff	DAH,g_HAShiftValue
	movff	DAL,g_LAShiftValue
		btfsc	aliasStateByte,0		;нет смещения
	call	_loadShiftA;(?/?)
	nop
	return
	
;;
_D4BPlusxK
	movff	D4BH,DAH
	movff	D4BL,DAL
	bsf		bitts,0		;16bit set
#ifdef MODE_4U
	btfss	aliasStateByte,0
		call	_D4PlusX		;_D4Plus_xK
#else
  #ifdef MODE_3U
	call	_D4PlusX
  #else
	;[Error]
  #endif
#endif
	movff	DAH,D4BH
	movff	DAL,D4BL
	btfsc	aliasStateByte,0		;нет смещения
		call	_loadShiftB;(?/?)
	nop
	return
	
;;
_D4BMinusxK
	movff	D4BH,DAH
	movff	D4BL,DAL
	bsf		bitts,0	;16bit set
#ifdef	MODE_4U
	btfss	aliasStateByte,0
		call	_D4MinusX
#endif
#ifdef MODE_3U
	call	_D4MinusX
#endif
	movff	DAH,D4BH
	movff	DAL,D4BL
	btfsc	aliasStateByte,0		;нет смещения
		call	_loadShiftB;(?/?)
	nop
	return

; обработчик
_OFFxK
	bcf		coeff,7		; "точно" регулировка (шаг =1)
	bcf		g_summaryDataArray+10,3	; 
	return
	
_ONxK
	bsf		coeff,7		; "грубо" регулировка (шаг =1хК)
	bsf		g_summaryDataArray+10,3
	return
	
;; Операции с EEPROM
; сохранение настроек
_CurrentLimitSave
	call	eeprom_CheckState;(?/?)
	movlw	0x15
	movwf	EEADR
	movf	ILIM
	movwf	EEDATA
	call	eeprom_Save;(?/?)
	return

_ShiftOneSave
	call	eeprom_CheckState;(?/?)
	movlw	0x16
	movwf	EEADR
	movff	g_LAShiftValue,EEDATA
	call	eeprom_Save;(?/?)

	call	eeprom_CheckState;(?/?)
	movlw	0x17
	movwf	EEADR

	movlw	b'00001111'			;маска для защиты g_HAShiftValue от превышения макс разреш числового значения
	andwf	g_HAShiftValue
	
	movff	g_HAShiftValue,EEDATA
	call	eeprom_Save;(?/?)
	nop
	return

_ShiftTwoSave
	call	eeprom_CheckState;(?/?)
	movlw	0x18
	movwf	EEADR
	movff	D4BL,EEDATA
	call	eeprom_Save;(?/?)

	call	eeprom_CheckState;(?/?)
	movlw	0x19
	movwf	EEADR

	movlw	b'00001111'			;маска для защиты g_HAShiftValue от превышения макс разреш числового значения
	andwf	D4BH

	movff	D4BH,EEDATA
	call	eeprom_Save;(?/?)
	nop
	return
;сохранение настроек
end
