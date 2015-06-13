; format - Ok
#include 	P18F8722.inc
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


#include <../headers/g_consts.inc>
#include <../headers/objects_macro.inc>
#include <../headers/registry.inc>


