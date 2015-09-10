#-*- coding: utf-8 -*-
import math
''' 
	About : Модели цифрованалогового и наоборот преобразования 
	file : import ModelADDAC as adda
'''

''' '''
def calcZeroDisplacmentX( y, zeroDisplacementY, converter ):
	# сдвигаем ноль если нужно
	valueDisplacemented = y + zeroDisplacementY
	
	# преобразуем 
	valueDisplAndConverted = valueDisplacemented * converter
	
	# выходим
	return valueDisplacemented, valueDisplAndConverted

''' [dist] = [value]/[conv] '''
def calcZeroDisplacmentY( y, zeroDisplacementX, converter ):
	# приводим смещение
	valueDisplacemented = y + zeroDisplacementX / converter
	
	# преобразуем 
	valueDisplAndConverted = valueDisplacemented * converter
	
	# выходим и забираем с собой
	return valueDisplacemented, valueDisplAndConverted
	
''' линейная записимость с возможным сдвигом и масштабирование
на выходе код заданной точность
'''
def modelADC( valueDict, printRpt, calcZeroDisplacment ):	# also
	value = valueDict[ 'value' ]
	zeroDisplacement = valueDict['displacement'] 
	converter = valueDict['converter' ] 
	scale = valueDict['scale'] 
	capacity = valueDict['capacity'] 
	Vmax = valueDict['Vmax'] 
	
	# печатаем
	print '\n>> Input values:'
	for at in valueDict:
		print at+' :\t'+str( valueDict[ at ] )
	
	# смещаем ноль по одной из осей, по какой передается указателем на функцию
	# модель - U = Kvu * Value + dU
	# сдвигаем ноль если нужно
	valueDisplAndConverted = converter * value + zeroDisplacement
	
	# корректируем
	valueDisplacemented = valueDisplAndConverted - zeroDisplacement

	# масштабируем перед АЦП
	valueScaled = valueDisplAndConverted * scale
	
	# Переводим в цифровой код
	toDigital = math.pow(2,capacity) / Vmax	# коэффициент преобразования
	valueCode = int( toDigital * valueScaled )
	
	# Коэффициент передачи аналогового сигнала(скорр.) в код
	Kda = valueDisplacemented / valueCode
	
	# печать отчета
	# callback
	printRpt( value, valueDisplacemented, valueScaled, valueCode, Kda )
	return valueCode, Kda

''' DAC считаемтся что код уже скорректирован! '''
def modelDAC( valueDict, printRpt ):
	value = valueDict[ 'value' ]
	zeroDisplacement = valueDict['displacement'] 
	converter = valueDict['converter' ] 
	scale = valueDict['scale'] 
	capacity = valueDict['capacity'] 
	Vmax = valueDict['Vmax'] 
	
	# считаем - на входе код
	toAnalog = Vmax / math.pow(2,capacity)
	valueAnalog = toAnalog * value
	
	# обратное масштабирование
	valueAnalogScaled = valueAnalog / scale
	
	# преобразуем в исходную величину
	valueConverted = valueAnalogScaled / converter

	#printRpt( value, valueDisplacemented, valueScaled, valueCode, Kda )
	return valueConverted
''' '''
if __name__ == '__main__':
	pass
