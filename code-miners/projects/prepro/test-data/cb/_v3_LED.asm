;************************************************************
; file : _v3_led.asm
; 
; abs. : операции с индикацией?

;************************************************************
#include <../headers/led.inc>

mObject_var	_v3_LED

	LedByte	res	1
	MipsLedMode		res	1
	WorkLedMode		res	1
	
	AlrmLedMode		res	1	; alr - один байт
	FlashCounter	res	1

object	code
_v#v(HERE)_LED_INI
	mObject_sel	THIS
	movlw	0xFF
	movwf	LedByte
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_ComSendOn;(byte W/void)
	mObject_sel	THIS
	bcf		bComSend
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_ComSendOff;(byte W/void)
	mObject_sel	THIS
	bsf	bComSend
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_ReqSendOn;(byte W/void)
	mObject_sel	THIS
	bcf		bReqSend
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_ReqSendOff;(void/void)
	mObject_sel	THIS
	bsf		bReqSend
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_BumLock;(void/void)
	mObject_sel	THIS
	bsf		bBumWork;bBumLocking
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_BumUnLock;(void/void)
	mObject_sel	THIS
	bcf		bBumWork;bBumLocking
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)
	

_v#v(HERE)_LED_SETdw_AlarmOff;(void/void)
	mObject_sel	THIS
	bsf		bBumFault;bBumAlarm
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_AlarmOn;(void/void)
	mObject_sel	THIS
	bcf		bBumFault;bBumAlarm
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

; первая реакция на комманду 0x01
_v#v(HERE)_LED_SETdw_ExchOn;(void/void)
	mObject_sel	THIS
	bcf		bBumExch
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)


_v#v(HERE)_LED_SETdw_ExchOff;(void/void)
	mObject_sel	THIS
	bsf		bBumExch
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_MipOn;(void/void)
	mObject_sel	THIS
	bcf		bBumMip
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_MipOff;(void/void)
	mObject_sel	THIS
	bsf		bBumMip
	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)

_v#v(HERE)_LED_SETdw_fLedMode;(*FSR0/void)
	mObject_sel	THIS
	movff	POSTINC0,MipsLedMode
	movff	POSTINC0,WorkLedMode
	movff	POSTINC0,AlrmLedMode
	
	incf	FlashCounter,w
	andlw	b'01111111'
	iorlw	b'00000001'
	movwf	FlashCounter

	movf	FlashCounter,w
	andwf	MipsLedMode
	bsf		bBumMip
	btfss	STATUS,Z
	bcf		bBumMip

	movf	FlashCounter,w
	andwf	WorkLedMode
	bsf		bBumWork
	btfss	STATUS,Z
	bcf		bBumWork

	movf	FlashCounter,w
	andwf	AlrmLedMode
	bsf		bBumFault
	btfss	STATUS,Z
	bcf		bBumFault

	movf	LedByte,w
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wLedControl;(byte W/void)
	mRETURN
;/// /// /// 
	end