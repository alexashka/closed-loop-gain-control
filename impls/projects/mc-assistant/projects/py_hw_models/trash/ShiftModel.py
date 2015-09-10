#!/usr/bin/python
#-*- coding: utf-8 -*-
import ui
import api_convertors.float32_conv as f32_conv
import api_convertors.type_conv as tc
import math
from api_dbg.doColoredConsole import co

def hexWordToInt( hexWord ):
	sum = 0
	for pos in range( 0, len( hexWord ) ):
		oneIt =  tc.hex2int( hexWord[ pos ] )*math.pow( 16, len( hexWord )-pos-1 )
		sum += oneIt
	return sum
	
def intWordToHex( intWord ):
	sum = ''

# Расчет для УКВ ЧМ
T = 0	# Температура 8 бит бит/градус

# температурный коэффициент
corrected_mult = 4.9 * 5 * 1e-3	# V/oC

# поправка
mult = 4.9/1000*5*4000.0/4.6	# V/oC положительная!
delta_U = mult*T	# deltaU V

# конкретное значение смещения
hexWord = '0F99'
Usm_src = hexWordToInt( hexWord ) 
Usm_src -= delta_U	# вычитание вот здесь!

# Report
'''
msg = 'T oC :'
ui.plot(msg, T)
msg = 'mult V/oC :'
ui.plot(msg, mult)
msg = 'deltaU, ue LH:'
ui.plotWord(msg, delta_U)
msg = 'deltaU ue :'
ui.plot(msg, delta_U)
msg = 'Usm src, ue LH:'
ui.plotWord(msg, Usm_src)
msg = 'Usm src, ue float32:'
ui.plot(msg, Usm_src)
ui.rout()'''


#print f32_conv.hexMCHIPfloat32toFloat("80 33 D7 0A")
#f32_conv.hexMCHIPfloat32toFloat("81 0A EC 08")

''' '''
def shift2Code( fShift ):
	Usm_needed = fShift

	# 2. Переводим в код
	V_test = 1.433	# V - на транзисторе при коде 0xFFF
	V_test_code = '0FFF'
	V_test_code = hexWordToInt( V_test_code ) # вид для расчета
	K_V2code = V_test_code / V_test
	Code =K_V2code * Usm_needed
	
	# Report
	co.printE( 'U : ' + str( Usm_needed )+'\n') 
	co.printW( 'Code : ' + str( int(Code) )+'\n')
	msg = 'Hex code, LH: : '
	ui.plotWord(msg, Code)
	
	# Выходные параметры
	return Code

# Перобразование смещения
T = 26.0	# Температура 8 бит бит/градус

# температурный коэффициент
corrected_mult = 4.9 * 5 * 1e-3	# V/oC

# расчет
dUsm = T * corrected_mult

# В виде кода
dUsm_code = shift2Code( dUsm )
K_oC2Code = dUsm_code / T
# переводим в плавающую точку
msg = 'T to code, float32:'
ui.plot(msg, K_oC2Code)
co.printW( 'T to code : '+str(K_oC2Code)+'\n' )

# нулевое приближение в коде
#U = 1.433
#U_code = shift2Code( U )



