;  rev...1 добав обрабока отказа по Т., если есть отк по темпер - то ничего не сбрасываем и RETURN
;		Сброс отк по T выкл пит блока. отпускание атт только по комманде  _ON. Введена задержка отрускания атт. после 
;		загрузки смещения 20мкс. откл авар при отсутствии обмена с DS, но остался байт состояния -(Закоментир)  
;  rev.1.1 Добавлена поддержка срабатвания по аварии МИП с выходов компараторов. Многопрхрод измер температуры (HOT)

; Trouble:
	;  Есть задача, в ней корректируется смещение (DSR-procedure = task code)
	;    планирование просто по кругу в main_loop
	;  Есть обработчик прерывания. Он сбрасывает смещение в случае отказа(ISR-routine)
	;  Есть обработчик прерывания. Управление смещением по i2c(ISR-routine)
	;  Проблема(Shared Data Problem) - есть общие переменные, и возможный одновременный доступ к устройству(DAC)
	;  Возможные решения
	;    1. Запретить прерывания при установке смещения в результате коррекции - but it result in big deadline, 
	;      and as interrupt is important - BAD! - вопрос - хранит ли событие-превывание на вермя деедайна?
	;        ! but происходит обращение к устройству, значить время deadline переменчиво?
	;		 можно ли оценит время работы? поможет ли симулятор? может разделить на преоритеты? например
	;		 заперать по прерыванию, а снять смещение в задачах
	;    2. Установить какой-нибудь флаг - хотя тоже... булевские типы небезопасны
	
	; ISR must be small!!!
	; нужно ли на время ее работы запрещать прерывания?
	
	; на компаратор сигнал идет с триггеров - зачем? с чем сравнивается?

#include "../headers/user_modes.inc"
#define	bArrayTransmitted	g_kFlag,0			;H-Massive transmitted
#define	g_bCommandReceived	g_kFlag,5			;H-Command received

;; Engine
extern task_CorrectionShift;(void/void)
extern sdr_Exec;(?/?)
extern sdr_Init;(?/?)
extern irq_UniISR;(?/?) 
extern task_TermoProtection;(?/?)

;; Other
extern hot_Ini;(?/?)
extern hot_DoMeasureTemperature;(?/?)
extern eeprom_ReadAll;(?/?)

extern dac_Init;(?/?)
extern adc_Measure;(?/?)
extern ddp_SetArrayMaker;(?/?) 
extern task_IntHAL;(?/?)
extern adc_Init;(?/?)  

; Data
extern	g_kFlag

main idata_acs
	temp_STATUS		res	1
	temp_FSRL		res	1
	temp_FSRH		res	1
	temp_PCLATH		res	1
	temp_WREG		res	1

#ifndef	bootloader
StartCode code	0x0000
			goto	_lbl_init
#else
StartCode code
_start
			goto	_lbl_init
global		_start
#endif
; Карта памяти
HP_IRQ		code	0x0008
	bra		_irqs
LP_IRQ		code	0x0018

; ISR "table"
_irqs
	movff	FSR1L,temp_FSRL   	;save copy of FSR1
	movff	FSR1H,temp_FSRH   	;save copy of FSR1

	; Обработчик прерывания
	call	irq_UniISR;(?/?)

	movff	temp_FSRL,FSR1L
	movff	temp_FSRH,FSR1H    ;restore FSR1		
	retfie	FAST

; main()
MAIN	code
_lbl_init
	call	task_IntHAL;(?/?)
	call	adc_Init;(?/?)
	call	dac_Init;(?/?)
	call	sdr_Init;(?/?)
	call	hot_Ini;(?/?)
	call	eeprom_ReadAll;(?/?)
	
_lbl_loop
	clrwdt
	btfss	bArrayTransmitted			;Massive transmitted?
		goto	_lbl_step		;No
	call 	adc_Measure;(?/?)	;Yes
	call 	ddp_SetArrayMaker;(?/?)
	
	; моргнуть диодом?
	call 	_main_BlinkDiode;(void/void)
	
_lbl_step
	; снимаем темперетурные данные
	call 	hot_DoMeasureTemperature;(?/?);(?/?)
	
	; защита по температуре
	call 	task_TermoProtection;(?/?)
	
	; делаем температурную коррекцию смещения
	call 	task_CorrectionShift;(void/void)

	; Exe()?
	btfsc	g_bCommandReceived
		call	sdr_Exec;(?/?)
	goto	_lbl_loop
	
_main_BlinkDiode;(void/void)
	bsf		PORTB,6
	DelayMs	5
	bcf		PORTB,6
	return
END
