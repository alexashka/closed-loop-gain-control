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

#include "p18f2520.inc"
radix dec
#include	<../headers/init_data.inc>

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
#include	<../pic18_mc_asm_lib/headers/DELAY14.INC>

	
