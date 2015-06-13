#include "../headers/user_modes.inc"
#include "../headers/spi.inc"

global dac_SetChannalA;(?/?)
global dac_SetChannalB;(?/?)
global dac_SetChannalC;(?/?)
global dac_SetChannalD;(?/?)
extern	DAL, DAH

; SPI Lib	
extern _ADT7516_SET_wDataPointer
extern _ADT7516_SET_wCharIn
extern _ADT7516_SET_wfBlockIn;(w, fsr0/void)

; Code
extern lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)

mSetThreshold macro ADDRESS
	movlw	2
	movwf	Temp
	movlw	ADDRESS
	call	_ADT7516_SET_wDataPointer
	mSel
	
	movf	Temp,w
	call	_ADT7516_SET_wfBlockIn
	mSel
	bcf		bLD
	bsf		bLD
	return
endm

mInitThreshold macro HL
	movlw	LOW HL
	movwf	DAL
	movlw	HIGH HL
	movwf	DAH
endm

mSel macro
	banksel AddressPointer
endm

mydata_DAC	idata_acs
	AddressPointer	res	1
	Temp			res	1
	SPI_Temp		res	1

Obj_DAC	code
; ��������� ������ �� ����������
dac_SetChannalD;(?/?)
	mInitThreshold POWER_SOURSE_THR
	call lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)
	mSetThreshold DAC_D_LSB

; ����� �� ����
dac_SetChannalA;(?/?)
	mInitThreshold CURRENT_THR
	call lib_corrWordBeforLoadDAC;(DAL, DAH/fsr0+0+1)
	mSetThreshold DAC_A_LSB
	
; � ������� ������������? ������ �� ��������� ��������
dac_SetChannalB;(?/?);(fsr0+1)
	mSetThreshold DAC_B_LSB
	
; ��������� ��������
dac_set_shift;(2-fsr0/void)
	mSetThreshold DAC_B_LSB
	
	
;
dac_SetChannalC;(?/?):
	mSetThreshold DAC_C_LSB
end

