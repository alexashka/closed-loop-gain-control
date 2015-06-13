;>>..\headers\user_modes_p.inc

;rev...1 добав обрабока отказа по Т., если есть отк по темпер - то ничего не сбрасываем и RETURN
;		Сброс отк по T выкл пит блока. отпускание атт только по комманде  _ON. Введена задержка отпускания атт. после 
;		загрузки смещения 20мкс. откл авар при отсутствии обмена с DS, но остался байт состояния -(Закоментир)  
;rev.1.2 Добавлена поддержка срабатвания по аварии МИП с выходов компараторов. Многопроход измер температуры (HOT)
;        Номер версии ПО в начале (00-04) нулевой строки EEPROM -не применяется!!!
;
;rev.1.3	???ЖЯ7150990/2
;rev.1.4	ЖЯ7150990/3
;	в проект введены 2-е конфигурации плат 033. Старая(MODE_OLD033) и новая (MODE_NEW_033)- в новой 
;	введено быстрое отключение аварийного канала МИП-а непосредственно с 033 платы. Сброс 
;	аварии, включение остаётся от 032. 
;NOTE: в строке 202 мигаем 1ms светодиодом (PORTB,1)для
;индикации приёма команды от ПУ.

;>>p18f2520.inc


;<<p18f2520.inc
radix dec
;>>..\headers\init_data.inc

#define _cinit 0x2a
	extern	copy_init_data

;<<..\headers\init_data.inc

#define _TEST
#ifdef _TEST
	#define SHIFT_CORRECTION_TEST
	#define NO_ALRMS
	;#define CURRENT_MOCK_VALUE	; проверено
	#ifdef CURRENT_MOCK_VALUE
		#define TEST_MOCK_CURRENT 0x01FE	;48.0 V; bits - 10
	#endif
	;#define VOLTAGE_MOCK_VALUE	; проверено
	#ifdef VOLTAGE_MOCK_VALUE
		#define TEST_MOCK_VOLTAGE 0x01FE	;48.0 V; bits - 10
	#endif
#endif
;#define bootloader
	;no implement
	
#define PATHES
#ifdef PATHES
	#define PATH_UKV_ALRMS	; не совпадали ноги 
	;#define LOCAL_DATA_PROC
#endif ;PATH

;/// /// ///
;///
;/// Modes - не конфликтуют ли между собой. Не должен ли быть один, а все остальные закомм?
;#define MODE_4U ; лучше заглавными, иначе, если быстро читать похожа на переменную
#define MODE_3U

;Режим Авария МИП по измерениям (MODE_3U_OLD)
;#define MODE_3U_OLD

;Режим Авария МИП из компараторов D12-D13 (MODE_3U_NEW_ALU
#define	MODE_3U_NEW_ALU
	; в I2C.asm исключена строка (167),актуальная для 1-ых плат 089  :	НЕТ!!!!! ВКЛ!!!03122010	
	; bcf	P ORTA,7,0	
	; RS activate		
	; -10112010,  for only old ver 089 !!! 

; все платы 3U, кроме новой 033, с функцией "быстрого отключения каналов МИП"

;#define MODE_OLD
#define	MODE_NEW_033
;///
;///
;/// /// ///

; Для 033 введене пороги по напряжению
#ifdef MODE_NEW_033
	;#define MIP_42V
		; пороги защиты по мип 42V (+13%/-15%)
	
	#define MIP_48V
		; пороги защит по мип 48V (+13%/-15%)
	;#define MODE_CONTROL_CH_MIP - управление каналами мип для 3U (new033)
#endif

; Порог по напряжению
#ifdef	MIP_42V 
	#define POWER_SOURSE_THR 0x0DA5 ;ref=3,89V
#endif
#ifdef	MIP_48V
	;#define POWER_SOURSE_THR 0x0F9C ;ref=4,45V
	#define POWER_SOURSE_THR d'3864' ;ref=4,45V
	;#define ZERO_VOLTAGE_CORRECT 0x0000	;0 V; bits - 10
	;const double TA_VOLTAGE_MUL = 0.0941176470588;
#endif

; Порог по току
#define HALL_SENSORS
#ifdef MODE_4U
#ifdef HALL_SENSORS
		#define CURRENT_THR 0x075D
#else
		#define CURRENT_THR 0x075D
#endif
#endif

#ifdef MODE_3U
#ifdef HALL_SENSORS
	#define ZERO_HALL_CORRECT 0x005C	;0 A; bits - 10
	;#define CURRENT_THR 0x0B17	;16 A  bits - 12
	;#define CURRENT_THR 0x0D77	;20 A  bits - 12
	#define CURRENT_THR 0x0EA8	;22 A  bits - 12
;const double TA_CURRENT_MUL = 0.028818443804;
#endif ;HALL_SENSOR

	;#define CURRENT_THR 0x08E3
#endif


; Еще какие-то пороги по напряжению - не удалось заменить, так как режимы не искл. друг друга
;#ifdef	MODE_4U
	;#define U_HEIGHT d'235'	; 46V - для 4U;   4,9V	(d'251') - для 3U   (итого: +2%/- 10%) было d'189'
;#endif
;#ifdef	MODE_3U_OLD
	;#define U_HEIGHT d'251'	; 49V	(d'251') - для 3U 
;#endif
;#ifdef	MODE_4U
	;#define U_LOW	d'194'		; 38v 4U,	43V ( d'220' -3U )     было d'189'; 37V
;#endif
;#ifdef	MODE_3U
	;#define U_LOW	d'220'		; 43V ( d'220' -3U )
;#endif
;#define U_LOW	d'220'		; 43V ( d'220' -3U )
;#define U_HEIGHT d'251'	; 49V	(d'251') - для 3U 

; какие-то темпаратурные пороги
#define ONE_THRESH 90 ;84;80 
#define TWO_THRESH 80 ;75;70

; этому здесь не место, здесь место для конфигурации всей системы
#define		LENGTH	13
#define		VOID 0
;>>..\pic18_mc_asm_lib\headers\DELAY14.INC


	ifndef	DefMacroDelay
	extern	DelayUs20MHz, DelayMs20MHz, delay10s, delay1s
	endif



DelayMs	macro	T_ms
	movlw	low	T_ms
pagesel		DelayMs20MHz
	call	DelayMs20MHz
pagesel	$
	endm

DelayUs	macro	T_us
	movlw	low	T_us
pagesel		DelayMs20MHz
	call	DelayUs20MHz
pagesel	$
	endm

Delay1s	macro
pagesel		DelayMs20MHz
	call	delay1s
pagesel	$
	endm

Delay10s	macro
pagesel		DelayMs20MHz
	call	delay10s
pagesel	$
	endm











;<<..\pic18_mc_asm_lib\headers\DELAY14.INC

	

;<<..\headers\user_modes_p.inc

extern	g_LAShiftValue, g_HAShiftValue, D4BL, D4BH, ILIM
extern g_kFlag;

;; Export
global eeprom_Read;(?/?)
global eeprom_ReadAll;(?/?)
global eeprom_CheckState;(?/?)
global eeprom_Save;(?/?)

mydata_eeprom		idata_acs
	EE_Counter	res	1

Obj_Eeprom	code

; читать все
eeprom_ReadAll;(?/?)
	movlw	0x15
	call	eeprom_Read;(?/?)
	movwf	ILIM

	movlw	0x16
	call	eeprom_Read;(?/?)
	movwf	g_LAShiftValue

	movlw	0x17
	call	eeprom_Read;(?/?)
	movwf	g_HAShiftValue

	movlw	0x18
	call	eeprom_Read;(?/?)
	movwf	D4BL

	movlw	0x19
	call	eeprom_Read;(?/?)
	movwf	D4BH
	retlw	VOID

;
eeprom_Read;(?/?)
	clrwdt
	movwf 	EEADR		;to read from
	bcf 	EECON1,EEPGD
	bcf 	EECON1,CFGS
	bsf 	EECON1,RD	;start read
	movf 	EEDATA,W	;w=EEDATA
	return
	
;
eeprom_CheckState;(?/?)	
	btfsc EECON1,WR
		goto $-2		;wait to write finish
	return
;
eeprom_Save;(?/?)
	bcf 		EECON1,EEPGD	;point to data memory,not programm!
	bcf			EECON1,CFGS
	bcf 		INTCON,GIE		;disable irq
	bsf 		EECON1,WREN		;enable writes
	movlw 0x55
	movwf 		EECON2
	movlw 0xAA
	movwf 		EECON2
	bsf 		EECON1,WR		;start write
	bsf 		INTCON,GIE		;enable irq
	bcf 		EECON1,WREN		;disable write
	bcf			g_kFlag,3
	return
;

end



