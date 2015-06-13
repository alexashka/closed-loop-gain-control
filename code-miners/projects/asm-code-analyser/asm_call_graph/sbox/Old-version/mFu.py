#-*- coding: utf-8 -*-
def mSSP1_int2( args ): 
	i = str( args[0] )
	return '\n \
	btfsc	PIE1,SSP1IE\n \
		btfss   PIR1,SSP1IF	\n \
	bra		metka'+i+'\n \
		call	label\n \
metka'+i+':\n \
	'
def mSSP1_int( args ): 
	label = args[0]
	label2 = args[1]
	i = str( args[2] )
	return '\n \
	btfsc	PIE1,SSP1IE\n \
		btfss   PIR1,SSP1IF	\n \
	bra		metka'+i+'\n \
		call	'+label+'\n \
metka'+i+':\n \
	'
def mUART2TX_int( args ): 
	label = args[0]
	i = str( args[1] )
	return '\n \
	btfsc	PIE3,TX2IE	; TX2IE - используется как номер бита?\n \
		btfss	PIR3,TX2IF ; проскакиваем и вызываем функцию?\n \
	bra		metka'+i+'\n \
		call	'+label+'\n \
metka'+i+':\n \
	'
macDict = {
'mSSP1_int2' : mSSP1_int2,
'mSSP1_int' : mSSP1_int,
'mUART2TX_int' : mUART2TX_int,
}
