#include "../headers/user_modes_p.inc"

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
