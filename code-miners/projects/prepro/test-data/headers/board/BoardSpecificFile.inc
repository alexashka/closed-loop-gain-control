;#ifndef BOARD_SPECIFIC_FILE
;#define BOARD_SPECIFIC_FILE
#include <../headers/board/ProtocolExchange.inc>
; coding : UTF-8
;
; file : #include <../headers/BoardSpecificFile.inc>
;
; abs. : сводный файл определющий конфигурацию платы(IO and enveroment)
;   1. Порты ввода вывода
;   2. Адреса устройств на интерфейсах
;   3. Адреса сохранения настроек
;   4. xUxARTi конфигурации - если не меняются динамически
; Регистр - API к железу. Separating the Hardware from the Action
;

; 1-Wire

; PORTi
;/// /// ///
;///
;/// Cоответствие линий и портов побитно
;// A
#define		bRSPI		PORTA,4	; 091110
;// B
#define		bRST		PORTB,0
#define 	bLENREGD27	PORTB,1
#define		bZP			TRISB,2
#define 	bZP_PORT	PORTB,2
#define		bZAP		PORTB,3
#define		bRSB1		PORTB,3

;// C
#define		bDE			PORTC,0
;// D
#define		bRB			PORTD,0
#define		bLDB		PORTD,2
#define		bCS1		PORTD,3
#define		bSDI2		PORTD,4
#define		bSDO2		PORTD,5
#define		bSCK2		PORTD,6
;// E
#define		bCS3		PORTE,0
#define		bLD			PORTE,1
#define 	bLENREGD24	PORTE,4
#define		bCS2		PORTE,5
#define		bDC3		PORTE,6 ; 091110 PORTB,5
;// H
#define		bALMP		PORTH,2
#define 	bSELREGD24	PORTH,3
#define 	bSELREGD27	PORTH,3
#define		bCS4		PORTH,4	; 091110
#define		bUALR		PORTH,5	; 091110
#define		bRSU		PORTH,6	; 091110
#define		bD_A		PORTH,7	; 091110 PORTF,4

;#endif ;BOARD_SPECIFIC_FILE