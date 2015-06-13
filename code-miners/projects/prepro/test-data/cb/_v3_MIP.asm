;************************************************************

;************************************************************
#include <../headers/mip.inc>

mObject_var	_v3_MIP	
	MipControlByte		res	1

object	code
;------------------------------------------------------------
_v#v(HERE)_MIP_INI
	mObject_sel	THIS
;	clrf	MipControlByte
	movlw		b'10000000'
	movwf		MipControlByte
	mSlideTo	_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_ASKdw_ReadyW;(void/bool W)
	mSlideTo	_v#v(DOWN)_PIO_ASKdw_MipNormaW;(void/bool W)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_RUNdw_Pusk;(void/void)
	mObject_sel	THIS
	movlw		fMipPusk
	iorwf		MipControlByte,f
	movf		MipControlByte,w
	mSET		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mSlideTo	_v#v(UP)_TASK_HLTuw_Pusk;(void/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_RUNdw_MipStop;(void/void)
	mObject_sel	THIS
	movlw		~fMipPusk
	andwf		MipControlByte,f
	movf		MipControlByte,w
	mSET		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mSlideTo	_v#v(UP)_TASK_HLTuw_MipStop;(void/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_RUNdw_wChMipOn;(byte W/void)
	mObject_sel	THIS
	addlw	0
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_HLTuw_ChMipOn;(void/void)

	addlw	-1
	bnz		_OnCh1
	movlw	fMipCh1
	bra		_go_on
_OnCh1	
	addlw	-1
	bnz		_OnCh2
	movlw	fMipCh2
	bra		_go_on
_OnCh2
	addlw	-1
	bnz		_OnCh3
	movlw	fMipCh3
	bra		_go_on
_OnCh3	
	addlw	-1
	bnz		_OnCh4
	movlw	fMipCh4
	bra		_go_on
_OnCh4	
	addlw	-1
	bnz		_Return
	movlw	fMipCh5	
_go_on
	iorwf	MipControlByte,f
	movf	MipControlByte,w
	mSET		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mSlideTo	_v#v(UP)_TASK_HLTuw_ChMipOn;(void/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_RUNdw_wChMipOff;(byte W/void)
	mObject_sel	THIS
	addlw	0
	btfsc	STATUS,Z
	mSlideTo	_v#v(UP)_TASK_HLTuw_ChMipOff;(void/void)	
	
	addlw	-1
	btfss	STATUS,Z
	bra		_OffCh1
	movlw	~fMipCh1
	bra		_go_off
_OffCh1	
	addlw	-1
	btfss	STATUS,Z
	bra		_OffCh2
	movlw	~fMipCh2
	bra		_go_off
_OffCh2
	addlw	-1
	btfss	STATUS,Z
	bra		_OffCh3
	movlw	~fMipCh3
	bra		_go_off
_OffCh3	
	addlw	-1
	btfss	STATUS,Z
	bra		_OffCh4
	movlw	~fMipCh4
	bra		_go_off
_OffCh4	
	addlw	-1
	btfss	STATUS,Z
	retlw	VOID
	movlw	~fMipCh5	
_go_off	
	andwf	MipControlByte,f		
	movf	MipControlByte,w
	mSET		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mSlideTo	_v#v(UP)_TASK_HLTuw_ChMipOff;(void/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_RUNdw_AllChMipOff;(void/void)
	mObject_sel	THIS
	movlw	~fMipCh1
	andwf	MipControlByte,f
	movlw	~fMipCh2
	andwf	MipControlByte,f
	movlw	~fMipCh3
	andwf	MipControlByte,f
	movlw	~fMipCh4
	andwf	MipControlByte,f
	movlw	~fMipCh5
	andwf	MipControlByte,f	
	mSET		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mSlideTo	_v#v(UP)_TASK_HLTuw_AllChMipOff;(void/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_SETdw_ResetOtkazz;(void/void)
	mObject_sel	THIS
	movlw	fAlarm
	iorwf	MipControlByte,w
	movwf	MipControlByte
	mSlideTo		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mRETURN
;------------------------------------------------------------
_v#v(HERE)_MIP_SETdw_Otkazz;(void/void)
	mObject_sel	THIS
	movlw	~fAlarm
	andwf	MipControlByte,w
	movwf	MipControlByte
	mSlideTo		_v#v(DOWN)_PIO_SETdw_wMipControl;(byte W/void)
	mRETURN
;------------------------------------------------------------
_Return:
	mRETURN
end