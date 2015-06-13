; Этот модуль делает...
; IRQs list 
;	отказ - компаратор
;	I2C request
;	timer - что он делает?

#include "../headers/user_modes.inc"
#include "../headers/BoardMapping.h"
#define byteAlrms	g_summaryDataArray+11	;байт отказов
#define	g_bCommandReceived	g_kFlag,5		;H-Command received
#define	bArrayTransmitted	g_kFlag,0		;H-Massive transmitted
#define	MASK_COMPARER b'11000000'	;маска битов компараторов	
;#define	MASK_COMPARER b'01000000'	;маска битов компараторов	

mSlideTo macro link
	goto link
endm

; Danger!! возможны data racing!!!
;; Import
; Data
extern g_recievedCmd	; wr only
extern g_summaryDataArray	; массив для отправки и указатель для передвижению по нему
extern g_ownI2CAddress

; Code
extern sdr_LockAndShiftOff;(?/?)

;; Export
global g_kFlag
global g_arrayFlags
; Danger!!

; Code
global	irq_UniISR;(?/?)

; RAM
onIRQs_ram	idata_acs
	g_kFlag		res	1
	g_arrayFlags		res	1
		;	g_arrayFlags,0 - H-Memo of Usm is needed 
		;	g_arrayFlags,1 
		;	g_arrayFlags,2 
		;	g_arrayFlags,3 - H D4A - SM1
		;	g_arrayFlags,4 - H D4B - SM2
		;	g_arrayFlags,5
		;	g_arrayFlags,6	

	count		res 1
	channalSum		res 1
	tempAddr		res	1
	sspFlags		res	1				;0x76
		; bit0 	H-receive is active(g_ownI2CAddress was received)
		;		L-receive is unactive(g_ownI2CAddress is not received before)
	first			res	1
	ctm				res	1	; Вот что она хранит!?
	danger_Name0	res	1	; Вот что она хранит!?
	ptrMainData	res	1	; pXXX указатель? на что? зачем? и тут еще не испльзуется!
Obj_inter	code

;проверка разрешения прерывания по компаратору
; Функция похоже в этом модуле одна, но большая
irq_UniISR;(?/?)
	btfsc	PIR1,TMR2IF	; TMR - timer?
		bra		_lbl_CompOutCheck
 
	; Переход к проверка флага компаратора
	btfss	PIR2, CMIF
		bra		_lbl_ISRSlaveI2C

	;Проверка уровня на выходе компаратора
	; CMCON = xx00_0000 xx not null - значит авария? 10/01/11
	movf	CMCON,w
	andlw	MASK_COMPARER 
	btfsc	STATUS,Z	; поднялся ли флаг нуля? 
		bra		_lbl_CompRst

_lbl_AlrmOccure
	; ! Решение об отказе
#ifndef NO_ALRMS
	; запираем все
	bsf		g_bLockAtt_leg			; заперли аттенюатор
	call	sdr_LockAndShiftOff;(?/?)	; сняли смещение
	
	; Отключение прерывания по компаратору
	bcf		PIE2,CMIE

#ifndef PATH_UKV_ALRMS
	bsf		byteAlrms,0
	bsf		byteAlrms,1
	sublw	d'128'
	bn		_lbl_endLock
	btfss	STATUS,Z		
		bcf		byteAlrms,1	;отказ по току I1
	btfsc	STATUS,Z
		bcf		byteAlrms,0	;отказ по току I2	
#else
	bsf		byteAlrms,0 ; Установка флага отказа по току
	bsf		byteAlrms,3	; по напряжению
	movf	CMCON,w
	andlw	0x40
	btfsc	STATUS,Z		
		bcf		byteAlrms,0	;отказ по току I1
	movf	CMCON,w
	andlw	0x80
	btfsc	STATUS,Z
		bcf		byteAlrms,3	;отказ по напряжению	
#endif
		
; Инициализация таймера с прерыванием - почему инициализация? почему зовется Lock
_lbl_endLock
#ifdef	MODE_3U
	movlw	b'00000111'
	movwf	T2CON,0
	bcf		PIR1,TMR2IF
	bsf		PIE1,TMR2IE
#endif
; ! Решение об отказе
#endif ; NO_ALRMS

; сброс флага компаратора ! вот как эта метка связана с вызовом i2c!!!!!!!!???????????
_lbl_CompRst
	bcf		PIR2,CMIF
	bra		_lbl_ISRSlaveI2C			;переход к обработке I2C

; проверка выхода компаратора
_lbl_CompOutCheck
#ifdef	MODE_4U
	movf	CMCON,w
	andlw	MASK_COMPARER
	btfsc	STATUS,Z
#endif
	btfsc	g_bAlrmVoltage_leg
		bra		_lbl_SuperCurrentAlrm
	btfsc	PORTC,7 
		bra		_lbl_SuperCurrentAlrm
	bra		_lbl_TimerOff

;установка флага экстренной аварии по току	
_lbl_SuperCurrentAlrm
	bsf		byteAlrms,2,0
#ifdef	MODE_4U	
	bsf		g_bLockAtt_leg			;заперли аттенюатор
	call	sdr_LockAndShiftOff;(?/?);_OFF		;сняли смещение
#endif

#ifdef	MODE_NEW_033
_lbl_clouseAlrmCurrChMip
	btfss	g_summaryDataArray+10,0		;проверка запертости смещения
		bra		_lbl_next7654			;переход если заперто				
	bsf		g_bLockAtt_leg				;заперли аттенюатор
	call	sdr_LockAndShiftOff;(?/?)		;_OFF

_lbl_next7654							;управление ключом МИПа
#ifdef	MODE_CONTROL_CH_MIP
	movlw	0x72
	SUBWF	g_ownI2CAddress,0
	btfsc	STATUS,Z
		bra		_lbl_clouseMIP2_4
	
	movlw	0x78
	SUBWF	g_ownI2CAddress,0
	btfsc	STATUS,Z
		bra		_lbl_clouseMIP1_3

	movlw	0x76		;мип(УО1)- for 3U block
	SUBWF	g_ownI2CAddress,0
	btfsc	STATUS,Z
		bra		_lbl_clouseMIP1_3 ;clouseMIP1/3

	movlw	0x74
	SUBWF	g_ownI2CAddress,0
	btfsc	STATUS,Z
		bra		_lbl_clouseMIP2_4

; обработчики запирания
_lbl_clouseMIP2_4 ;clouseMIP2/4
	bcf	PORTB,5			;OFF2
	bra	_lbl_next33

_lbl_clouseMIP1_3 ;clouseMIP1/3
	bcf	PORTC,2			;OFF1
#endif
_lbl_next33
#endif

; отключение таймера и его прерываания
_lbl_TimerOff
	movlw	b'00000000'
	movwf	T2CON,0
	bcf		PIR1,TMR2IF
	bcf		PIE1,TMR2IE

; обработка приема запроса по i2c?
_lbl_ISRSlaveI2C
	btfss	PIR1,SSPIF
		goto	_lbl_exit
	btfsc	SSPSTAT,P		;2.07.2007
		goto	_lbl_exit
	btfsc	SSPSTAT,D_A		; адрес? данные?
		bra		_lbl_Choice		; данные
	btfsc	SSPSTAT,R_W		; Приемник или передатчик?
		bra		_lbl_Prado		; Передатчик
	movf	SSPBUF,w		; Приемник, g_ownI2CAddress read
	bsf		sspFlags,0		; Ready for receive!!! а почему выходи?
	movwf	tempAddr
	bra		_lbl_exit

_lbl_Prado
	bcf		sspFlags,0
	movlw	g_summaryDataArray	;Передатчик
	movwf	ptrMainData
	movlw	LENGTH+2		;1- for Checksumm 2- for LENGTH and checksumm
	movwf	count
	movwf	channalSum
	bra		_lbl_Transiver

; передаем или принимаем?
_lbl_Choice
	btfss	SSPSTAT,R_W		;Приемник или передатчик?
		bra		_lbl_Reciever			;Приемник
	bra		_lbl_Transiver				;Передатчик

; принимаем комманду
_lbl_Reciever
	btfss		sspFlags,0
		bra			_lbl_exit
	movf		SSPBUF,w
	
	; запись комманды
	movwf	g_recievedCmd

	; event to event loop
	bsf		g_bCommandReceived	;Command detect Flag
	bcf		sspFlags,0
	
	; дергает какие-то ноги - похоже на моргание диодами?
	bsf		PORTB,6,0
	bcf		PORTB,6,0
	
	; выходим
	bra		_lbl_exit

; отправляем данные - похоже на за раз!
_lbl_Transiver
	movf	count,w
	xorlw	LENGTH+2			;(count-( DATA+2 ))
	btfss	STATUS,Z			;First byte?
		bra		_lbl_common1		;No, not first
	movlw	LENGTH+2			;Yes LENGTH of message loading for _lbl_transate
	movwf	first
	bra		_lbl_trans

_lbl_common1
	movf	count,w 
	btfsc	STATUS,Z			;Last Byte?
		goto	_lbl_exit 		;Yes, it works when the Mistake is found?
	xorlw	1
	btfss	STATUS,Z			;Prelast Byte?
		bra		_lbl_MsgBodyProcessing				;No, its a Message Body
	movf	channalSum,w		;Yes, channalSum loading for _lbl_transate
	bsf		bArrayTransmitted
	bra		_lbl_trans

; переливаем данные
_lbl_MsgBodyProcessing
	lfsr 	1, g_summaryDataArray
	movff	ptrMainData, FSR1L
	incf	ptrMainData,f
	movf	INDF1,w
	addwf	channalSum,f

_lbl_trans	
	movwf	SSPBUF,0
	decfsz	count,f
		bra		_lbl_exit
	bsf		g_kFlag,2				;Massive transmitted Flag set
	decf	ctm
	
; Общий выход
_lbl_exit
	bcf		PIR1,SSPIF
	nop

	movlw	0xFF				;13.08.2007
	movwf	danger_Name0

	bcf		SSPCON1,SSPOV
	nop
	bsf		SSPCON1,CKP

	; итоковый выход
	retlw	VOID
end
