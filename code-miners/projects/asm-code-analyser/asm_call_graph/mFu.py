#-*- coding: utf-8 -*-
def mRETURN( args ): 
	i =  args[0]
	return '\n\
	return'
def mSlideTo( args ): 
	Link = args[0]
	i =  args[1]
	return '\n\
	goto	'+Link+''
def mCall( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call '+link+''
def mObject_end( args ): 
	klass = args[0]
	i =  args[1]
	return '\n\
	ifdef	'+klass+'\n\
	messg В модуле '+klass+' найдено:\n\
	messg 1. Статических переменных____#v(Number_Static)\n\
	messg 2. Открытых переменных_______#v(Number_Ext_Variables)\n\
	messg 3. Глобальных переменных_____#v(Number_Public) \n\
	messg 4. Открытых функций__________#v(Number_Ext_Functions)\n\
	endif'
def mRetIfF( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+'\n\
	xorlw	TRUE\n\
	btfss	STATUS,Z\n\
	retlw	FALSE'
def mASK( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+''
def mUART2TX_int( args ): 
	label = args[0]
	i =  args[1]
	return '\n\
	btfsc	PIE3,TX2IE	\n\
		btfss	PIR3,TX2IF \n\
	bra		metka'+i+'\n\
		call	'+label+'\n\
metka'+i+':\n\
	'
def mSSP1_int2( args ): 
	i =  args[0]
	return '\n\
	btfsc	PIE1,SSP1IE\n\
		btfss   PIR1,SSP1IF	\n\
	bra		metka'+i+'\n\
metka'+i+':\n\
	'
def mSSP1_int( args ): 
	label = args[0]
	label2 = args[1]
	i =  args[2]
	return '\n\
	btfsc	PIE1,SSP1IE\n\
		btfss   PIR1,SSP1IF	\n\
	bra		metka'+i+'\n\
		call	'+label+'\n\
metka'+i+':\n\
	'
def mReturnSave( args ): 
	i =  args[0]
	return '\n\
	return	FAST'
def mFunction( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+''
def mObject_var( args ): 
	klass = args[0]
	i =  args[1]
	return '\n\
	'+klass+'		idata\n\
	'+klass+'#v(0)	res	0'
def mRUN( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+''
def mCallSave( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+', FAST'
def mSET( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+''
def mEXTENDS( args ): 
	klass_s = args[0]
	klass_d = args[1]
	name = args[2]
	i =  args[3]
	return '\n\
	ifdef	'+klass_s+'\n\
		global	'+name+'\n\
Number_Ext_Functions++\n\
	endif\n\
	ifdef	'+klass_d+'\n\
		extern	'+name+'\n\
	endif'
def mObject_sel( args ): 
	klass = args[0]
	i =  args[1]
	return '\n\
	ifdef	'+klass+'\n\
		banksel	'+klass+'#v(0)\n\
	endif'
def mGET( args ): 
	link = args[0]
	i =  args[1]
	return '\n\
	call	'+link+''
macDictFu = {
'mRETURN' : mRETURN,
'mSlideTo' : mSlideTo,
'mCall' : mCall,
'mObject_end' : mObject_end,
'mRetIfF?' : mRetIfF,
'mASK' : mASK,
'mUART2TX_int' : mUART2TX_int,
'mSSP1_int2' : mSSP1_int2,
'mSSP1_int' : mSSP1_int,
'mReturnSave' : mReturnSave,
'mFunction' : mFunction,
'mObject_var' : mObject_var,
'mRUN' : mRUN,
'mCallSave' : mCallSave,
'mSET' : mSET,
'mEXTENDS' : mEXTENDS,
'mObject_sel' : mObject_sel,
'mGET' : mGET,
}
