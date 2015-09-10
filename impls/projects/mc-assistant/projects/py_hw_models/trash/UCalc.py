#-*- coding: utf-8 -*-

import ui
import api_convertors.float32_conv as f32cnv
import api_convertors.type_conv as tc
import math

# Constants
R1 = 27.4
R4 = 1.5
Splitter = R4/(R1+R4)

Umax = 5.0 	#mV
Resol = 1024.0
toDigital = Resol/Umax
toAnalog = 1/toDigital

''' '''
def calcKuu(U):
	# calc
	print ''
	print '>>> U to U dig. metro'
	print 'U V : '+str(U)
	Usplitted = U*Splitter
	print 'Usplitted V : '+str(Usplitted)
	Usplitted10bit = toDigital*Usplitted
	print 'Usplitted10bit ue : '+str(int(Usplitted10bit))

	# inv
	print ''
	print '>>> U dig. metro to U'
	hexStep = tc.bitFormattedArr2hex("0100")
	print '0x0'+hexStep
	Usplitted10bit = tc.hex2int(hexStep)#8#Usplitted10bit
	Usp = toAnalog*Usplitted10bit
	print 'Usp, V : '+str(Usp)
	U = Usp/Splitter
	print 'U V : '+str(U)
	
	# На что нужно умножать
	'''Kuu = U/Usplitted10bit
	msg = 'Kuu : '
	ui.plot(msg, Kuu)
	msg = 'Kuu *10: '
	ui.plot(msg, Kuu*10)'''
	
''' Расчет поправки к коду '''
def dUTodUADCcode(dU):
	# после делителя - коэфф. дел. как бы наклон прямой
	dUsrc = dU*Splitter
	print 'dUsrc, V : '+str(dUsrc)
	# Переводим в код
	dUSplit10bit = int(dUsrc*toDigital)
	print 'dUSplit10bit, ue : '+str(dUSplit10bit)
	print 'dUSplit10bit, ue : '+str(tc.byte2strhex(dUSplit10bit))
	

# Run 
if __name__ == '__main__':
	# Рассчитать коэффицниет передачи
	U = 42		# V
	calcKuu(U)
	
	# Рассчитать поправку на измеренное значение
	print ''
	print '>>> Correcting '
	dU = 0.5	# V
	dUTodUADCcode(dU)


