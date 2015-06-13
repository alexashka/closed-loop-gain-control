#include "../headers/user_modes.inc"
#include "../headers/spi.inc"

; SPI Lib	
global _ADT7516_SET_wDataPointer
global _ADT7516_SET_wCharIn
global _ADT7516_SET_wfBlockIn;(w, fsr0/void)
global	dac_Init;(?/?)
mSel macro
	banksel AddressPointer
endm

LocalDataArray idata_acs
	AddressPointer	res	1
	Temp			res	1
	SPI_Temp		res	1
	
 ADT code
 ;Инициализатор
dac_Init;(?/?):
	bsf		bLD
	bcf		TRISC,LD
	bsf		bCS	
	bcf		TRISC,CS
	bcf		bCLK
	bcf		TRISC,CLK
	bcf		bSDI
	bcf		TRISC,SDINP
	bsf		TRISB,SDOUT
	
	;три импульса для перевода в режим SPI
	bcf		bCS
		nop
	bsf		bCS
		nop
	bcf		bCS
		nop
	bsf		bCS
		nop
	bcf		bCS
		nop
	bsf		bCS

	movlw	CONTROL2
	call	_ADT7516_SET_wDataPointer
		mSel
	movlw	b'10000000'
	call	_ADT7516_SET_wCharIn	;software reset
		mSel

	movlw	INT_MASK1
	call	_ADT7516_SET_wDataPointer
		mSel
	movlw	b'11111111'
	call	_ADT7516_SET_wCharIn	;Disable interrupts
		mSel

	movlw	CONTROL1
	call	_ADT7516_SET_wDataPointer
		mSel
	movlw	b'01000000'
	call	_ADT7516_SET_wCharIn	;INT - active high
		mSel

	movlw	LDAC_CONFIG
	call	_ADT7516_SET_wDataPointer
		mSel
	movlw	b'00110000'
	call	_ADT7516_SET_wCharIn	;DAC internal Vref
		mSel

	movlw	DAC_CONFIG
	call	_ADT7516_SET_wDataPointer
		mSel
	movlw	b'00001111'
	call	_ADT7516_SET_wCharIn	;DAC output 2Vref, but DACA output 1xVref !!!
		mSel
	return
	
 ; SPI обмен?
_ADT7516_GET_DataPointerW:
	movf	AddressPointer,w
	return
_ADT7516_SET_wDataPointer:
	mSel
		movwf	AddressPointer
		return

;
_ADT7516_SET_wCharIn:
	mSel
		movwf	Temp
		bcf		bCS
		movlw	WRITECOMMAND
		call	_SPI_SET_wByteIn
		movf	AddressPointer,w
		call	_SPI_SET_wByteIn
		movf	Temp,w
		call	_SPI_SET_wByteIn
		bsf		bCS
		incf	AddressPointer,w
		andlw	0x3F
		movwf	AddressPointer
		return

_ADT7516_SET_wfBlockIn;(fsr0+0+N)
	mSel
		movwf	Temp
		bcf		bCS
		movlw	WRITECOMMAND
		call	_SPI_SET_wByteIn
		movf	AddressPointer,w
		call	_SPI_SET_wByteIn
_Loop3:
		movf	POSTINC0,w
		call	_SPI_SET_wByteIn
		incf	AddressPointer,w
		andlw	0x3F
		movwf	AddressPointer
		decfsz	Temp
		bra		_Loop3
		bsf		bCS
		return

_ADT7516_GET_CharOutW:
	bcf		bCS
	movlw	WRITECOMMAND
	call	_SPI_SET_wByteIn
	movf	AddressPointer,w
	call	_SPI_SET_wByteIn
	bsf		bCS
	bcf		bCS
	movlw	READCOMMAND
	call	_SPI_SET_wByteIn
	call	_SPI_GET_ByteOutW
	movwf	Temp
	bsf		bCS
	incf	AddressPointer,w
	andlw	0x3F
	movwf	AddressPointer
	movf	Temp,w
	return

_ADT7516_GET_wfBlockOut:
	movwf	Temp
	bcf		bCS
	movlw	WRITECOMMAND
	call	_SPI_SET_wByteIn
	movf	AddressPointer,w
	call	_SPI_SET_wByteIn
	bsf		bCS
	bcf		bCS
	movlw	READCOMMAND
	call	_SPI_SET_wByteIn
_Loop4:
	call	_SPI_GET_ByteOutW
	movwf	POSTINC0
	incf	AddressPointer,w
	andlw	0x3F
	movwf	AddressPointer
	decfsz	Temp
	bra		_Loop4
	bsf		bCS
	return


_SPI_SET_wByteIn:
	movwf	SPI_Temp
	movlw	8
_Loop1:
	bcf		bCLK
	rlcf	SPI_Temp,f
	btfsc	STATUS,C
	bsf		bSDI
	btfss	STATUS,C
	bcf		bSDI
	bsf		bCLK
	addlw	-1
	bnz		_Loop1
	return

_SPI_GET_ByteOutW:
	movlw	8
_Loop2:
	bcf		bCLK
	btfsc	bSDO
	bsf		SPI_Temp,0
	btfss	bSDO
	bcf		SPI_Temp,0
	bsf		bCLK
	rlcf	SPI_Temp,f
	addlw	-1
	bnz		_Loop2
	movf	SPI_Temp,w
	return
end