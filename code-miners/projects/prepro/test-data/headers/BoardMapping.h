; #include <BoardMapping.h>

; !! Это лучше отражать в директивах, а не в тексте - т.к. директивы это уже реальный
;   и проверяемый код
;	*********************************************
;	* PORTA,0 < comp input I1                  	*
;	* PORTA,1 < comp input I2          			*
;	* PORTA,2 <	AN1 I1			           		*
;	* PORTA,3 <	AN2 I2		 		   			*
;	* PORTA,4 > ZAP SM VT2 VT4 output          	*
;	* PORTA,5 < AN3 Umip input	               	*
;	* PORTA,6 < 	 							*ALU-Alarm Umip (NEW rev.!)   		               	*
;	* PORTA,7 > 10D4 RST		               	*
;	*********************************************
;	* PORTB,0 < A0 input	                   	*
;	* PORTB,1 > LD H4		                   	*
;	* PORTB,2 >	ZP on UP	           			*
;	* PORTB,3 < A1 input	           			*
;	* PORTB,4 < A2 input	           			*
;	* PORTB,5 < SM control from 14X11          	*
;	* PORTB,6 >< PGC ICD & H2 output	     	*прием команды по I2C
;	* PORTB,7 >< PGD ICD & H3 output	 		*
;	*********************************************
;	* PORTC,0 > CS D4							*
;	* PORTC,1 > CLK D4							*
;	* PORTC,2 > SDI D4							*
;	* PORTC,3 < SCL I2C							*
;	* PORTC,4 >< SDA I2C						*
;	* PORTC,5 > LDA LDB D4						*
;	* PORTC,6 > TX for Thermometer				*
;	* PORTC,7 < 								*SBU-RESET Trigger ALU-Alarm Umip (NEW rev.!)
;	*********************************************

;Super_NEW rev.:
;rev.1.3	в проект введены 2-е конфигурации плат 033. Старая(MODE_OLD033) и новая (MODE_NEW_033)- в новой 
;			введено быстрое отключение аварийного канала МИП-а непосредственно с 033 платы. Сброс аварии, включение остаётся
;			от 032. Изменено назначение отдельных выводов контроллера:
;		- обозначение - |	- old033 -	| - new033 -
;		--------------------------------------------
;		SDI			    |	RC2			|	RA6(osc2)	>
;		CLC				|	RC1			|	RC1			>
;		OFF1			|	нет			|	RC2		 	>
;		ALU				|	RA6			|	RB0			<
;		A0				|	RB0			|	RB2			<
;		OFF2			|	нет			|	RB5			>
;		----------------------------------------------

 #define bAlrmI1 PORTA, 0
 #define bAlrmU PORTB, 0
	 #ifdef	MODE_OLD	
		 ;+120312	
		 ;MODE_3U_NEW_ALU	
		 ;+091110
		#define g_bAlrmVoltage_leg PORTA,6	; по названию провода
	#endif
	#ifdef	MODE_NEW_033	;+120312
		#define g_bAlrmVoltage_leg PORTB,0
	#endif
 #define bAlrmU2 PORTA, 1
 #define g_bLockAtt_leg PORTA,4
  
;#ifdef	MODE_4U
;	#define bRstAlrms PORTA,7
;#endif
;#ifdef	MODE_3U	;!! конфликтует
	;#define bRstAlrms PORTA,7
;#endif
;#ifdef	MODE_3U_NEW_ALU	;+091110
;	#define bRstAlrms PORTC,7
;#endif
 
; Режимы опять не все, и дифайны выносить нельзя, хотя и дублируются
#ifdef	MODE_OLD
	constant	LD	=	5
	constant	CS	=	0
	constant	SDOUT	=	2
	constant	SDINP	=	2
	constant	CLK	=	1
	#define	bSDI	PORTC,SDINP
	
	#define	bLD		PORTC,LD
	#define	bCS		PORTC,CS
	#define	bSDO	PORTB,SDOUT
	#define	bCLK	PORTC,CLK
#endif	;MODE_OLD

#ifdef	MODE_NEW_033
	constant	LD	=	5
	constant	CS	=	0
	constant	SDOUT	=	1
	constant	SDINP	=	6
	constant	CLK	=	1
	#define	bSDI	PORTA,SDINP
	
	#define	bLD		PORTC,LD
	#define	bCS		PORTC,CS
	#define	bSDO	PORTB,SDOUT
	#define	bCLK	PORTC,CLK
#endif	;MODE_NEW_033

