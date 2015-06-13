; 
#include "../headers/user_modes.inc"
#include "../headers/protocol_exchange.ink"
#define bTermAlrmLocal g_DSFlag, 7

;; Import
extern hot_GetTemperature;(void/w)
extern sdr_LockAndShiftOff;(?/?)

; data
extern	g_summaryDataArray, g_DSFlag


;; Export
global task_CorrectionShift;(void/void)
global task_TermoProtection;(?/?)
global task_IntHAL;(?/?)

; RAM
task idata_acs
	_task	res	0;
	_tmp_w	res	1;
	
	; код до коррекции
	;_shiftCodeSrc	res	2

object code
task_IntHAL;(?/?)
	; кварц?
	movlw	b'01101100'
	movwf	OSCCON,0
	movlw	b'01000000'
	movwf	OSCTUNE,0
	
; Конфигурируем IO порты
#ifdef	MODE_4U	
	movlw	b'00000000'
#endif	
#ifdef	MODE_3U	
	; Почему здесь ифдефы других режимов!?
	movlw	b'10000000'

	;#define	MODE_OLD	; ! вот это как понимать
		; закомменитл igor

	movwf	PORTA

	movlw	b'01101111'	;0:iiii_oiio:7
	movwf	TRISA,0

	clrf	PORTB
	movlw	b'10111111'
	movwf	TRISB,0

	movlw	b'00100001'
	movwf	PORTC
		
	#ifdef		MODE_4U	; ! вот это как понимать
		movlw	b'11011000';0xD8	
	#endif		
		
	#ifdef		MODE_3U_old	; ! вот это как понимать
		movlw	b'11011000';0xD8	old	
	#endif
	#ifdef		MODE_3U_NEW_ALU		;+091110 ; ! вот это как понимать
		movlw	b'01011000'		
	#endif		
	movwf	TRISC,0
#endif	;MODE_OLD

#ifdef	MODE_NEW_033	;реализованно "быстрое отключение каналов МИП"
;	movlw	b'10000000'	
; ! что пишем-то
	movwf	PORTA

	movlw	b'00101111'	;0:iiii_oioo:7
	movwf	TRISA,0

	movlw	b'00100000'
	movwf	PORTB
	movlw	b'10011111'
	movwf	TRISB,0

	movlw	b'00100101'
	movwf	PORTC

	movlw	b'01011000'	
	movwf	TRISC,0

	bcf	INTCON,INT0IF
	bcf	INTCON,INT0IE 	;alu in irq OFF !!!
	bsf	INTCON2,INTEDG0	;=1-interrupt RB0 is triggered by a rising edge;
#endif	;MODE_NEW_033

	;_timerInit	;?
	movlw	b'00000111'				;
	movwf	T0CON
	movlw	0x00
	movwf	TMR0L
	movlw	0x00
	movwf	TMR0H
	bcf		INTCON,TMR0IF

	; IRQ's initialize
	bcf		PIE1,CMIE	;comp_IRQ disable
	bsf 	INTCON,GIE	;enable irq
	bsf		INTCON,PEIE

	;  COMParators initialize 
	movlw	b'00110110'	;оба компаратора в инверсии
	movwf	CMCON,0

	movlw	b'10001111'	;возможный максимум 0.75Пит т.е. 12.5А
	movwf	CVRCON,0

	bsf		PIE1,SSPIE
	bsf		PIE2,CMIE	;надо включить прерывание по компаратору
		; все-таки обработка отказа по токам происходит по прерыванию?
	retlw	VOID
	

; задача коррекции смещения
; есть тюнеры, лучше менять не значение некой переменной, а запускать 
;   всю задачу
task_CorrectionShift;(void/void)
	; разрешена ли установка смещения
		; получаем температуру и сохраняем здесь
		call hot_GetTemperature;(void/w)
		banksel _task
		movf	_tmp_w
		
		; Immediate setting of shift
		; Attantion! deadline
		;bool irqStateOld;
		;irqStateOld = _atomic_lock;()		
		; Разрешена ли установка смещения
			; Запускаем установку
;_lbl_setSiftDisabled
		; if( irqStateOld )
			;_atomic_unlock;()
	return

; проверка температуры	
task_TermoProtection;(?/?)
	movlw ONE_THRESH
	cpfslt	g_summaryDataArray+12, 0	; 0 - куда сохраняем
		bra		lbl_protect_alrmT;(?/?)
	btfss	bTermAlrmLocal 	; была уже авария?
		; нет
		return	
	;да
	movlw	TWO_THRESH 
	cpfslt	g_summaryDataArray+12, 0	; снизилась темп ниже XX oС ?
		;нет
		bra		lbl_protect_alrmT	
	;да
	;сброс флага авар по Т
#ifdef		MODE_3U
	bcf		bTermAlrmLocal	
#endif
	return
	
lbl_protect_alrmT;(?/?)			
	bsf		bTermAlrmInfo	; устанавливаем флаг отказа по температуре, в информационном сообщении
	bsf		bTermAlrmLocal	; H - флаг авар по Т	
	call	sdr_LockAndShiftOff;(?/?)	; запирание атт с платы (ДЛЯ 4U c АРУ по Оконеч) и откл смещ 
	return
end
