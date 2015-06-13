; #include <../headers/kpup.inc>

#ifndef	_v2_KPUP
#define		THIS	_v2_KPUP
constant	HERE=2
#define		_v2_KPUP	_v2_KPUP
#include <../headers/user_modes.inc>
#include <../headers/board/BoardSpecificFile.inc>

; Адреса записи 
#define ADDR_D8BL_A 0x08
#ifdef UKV_ARU
	#define ADDR_D8BL_D ADDR_D8BL_A
#else
	#define ADDR_D8BL_D 0x0B
#endif

; igor
;kpupStatus	res	1;
	; 0 - разрешена ли температурная коррекция(1/0 - да/нет)
	; ! нужно два бита!! иниче без перемычки не будет работать - не уст. второе смещение
	#define SHIFT_CORR_ENA_A	0
	#define bTermCorrEnaA	kpupStatus,	SHIFT_CORR_ENA_A	; 
	#define SHIFT_CORR_ENA_B	1
	#define bTermCorrEnaB	kpupStatus,	SHIFT_CORR_ENA_B	; запрещает махом оба
	
	; состояние перемычки. Она замкн., прин. бит = 1 - но 1 - разрешена, чтобы 
	;	если перемычки нет, то штатный режим - корректирующий
	#define GLOBAL_SHIFT_CORR_ENA 2	; 
		#define bGlobalTermCorrEna kpupStatus,	GLOBAL_SHIFT_CORR_ENA
	#define JUMPER_READED_BIT 4; факт чтений перемычки 0 - нет
		#define bJumperReaded	kpupStatus, JUMPER_READED_BIT
;KFLAG
	;	KFLAG,1	- H-Lava's Command detected
	;	KFLAG,2	- H-Massive is transmitted
	;	KFLAG,3	- 8 bit H-Plus is present L-Minus is present
	;	KFLAG,4	- 16 bit same like KFLAG,3
	;	KFLAG,5 - H-Memo of Usm is needed
	;	KFLAG,6 - H-Usm YP memo needed, L-Usm YCO memo needed
;MFLAG	res	1
;		;	MFLAG,0 - H-Memo of Usm is needed
;		;	MFLAG,1 - H-Usm YP memo needed D9A
;		;	MFLAG,2 - H-Usm YCO memo needed D9B
;		;	MFLAG,3 - H D8A
;		;	MFLAG,4 - H D8B
;		;	MFLAG,5
;		;	MFLAG,6
;S SPFLAGS	res	1	;0x76
			;bit0 	H-receive is ac tive(adress was received)
			;	L-receive is unac tive(adress is not received before)
		
;bitts	res 1
		;	bitts,0 - L-8bit operation H-16bit operation
;L avadata	res 22+2	; не ясно что-куда-откуда
		; L avadata+18 - отказы
