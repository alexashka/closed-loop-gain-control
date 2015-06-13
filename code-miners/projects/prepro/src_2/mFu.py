#-*- coding: utf-8 -*-
def mRETURN( args ): 
	i = str( args[0] )
	return '\n \
	return'
def mSlideTo( args ): 
	Link = args[0]
	i = str( args[1] )
	return '\n \
	goto	'+Link+''
def mCall( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call '+link+''
def mObject_end( args ): 
	klass = args[0]
	i = str( args[1] )
	return '\n \
	ifdef	'+klass+'\n \
	endif'
def DelayUs( args ): 
	T_us = args[0]
	i = str( args[1] )
	return '\n \
	movlw	low	'+T_us+'\n \
Delay20MHzUs'+i+':\n \
	clrwdt\n \
	addlw	0xFF\n \
	btfss	STATUS,Z\n \
	goto	Delay20MHzUs'+i+'\n \
		'
def mASK( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+''
def mCallSave( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+', FAST'
def mReturnSave( args ): 
	i = str( args[0] )
	return '\n \
	return	FAST'
def mFunction( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+''
def mObject_var( args ): 
	klass = args[0]
	i = str( args[1] )
	return '\n \
	'+klass+'		idata\n \
	'+klass+'#v(0)	res	0'
def mRetIfF( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+'\n \
	xorlw	TRUE\n \
	btfss	STATUS,Z\n \
	retlw	FALSE'
def mRUN( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+''
def mSET( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+''
def mEXTENDS( args ): 
	klass_s = args[0]
	klass_d = args[1]
	name = args[2]
	i = str( args[3] )
	return '\n \
	ifdef	'+klass_s+'\n \
		global	'+name+'\n \
Number_Ext_Functions++\n \
	endif\n \
	ifdef	'+klass_d+'\n \
		extern	'+name+'\n \
	endif'
def mObject_sel( args ): 
	klass = args[0]
	i = str( args[1] )
	return '\n \
	ifdef	'+klass+'\n \
		banksel	'+klass+'#v(0)\n \
	endif'
def mGET( args ): 
	link = args[0]
	i = str( args[1] )
	return '\n \
	call	'+link+''
macDictFu = {
'mRETURN' : mRETURN,
'mSlideTo' : mSlideTo,
'mCall' : mCall,
'mObject_end' : mObject_end,
'DelayUs' : DelayUs,
'mASK' : mASK,
'mCallSave' : mCallSave,
'mReturnSave' : mReturnSave,
'mFunction' : mFunction,
'mObject_var' : mObject_var,
'mRetIfF' : mRetIfF,
'mRUN' : mRUN,
'mSET' : mSET,
'mEXTENDS' : mEXTENDS,
'mObject_sel' : mObject_sel,
'mGET' : mGET,
}
