#-*- coding: utf-8 -*-
''' 
	Хранит историю изменений по имени
	Y% - (82-N/2)/127
	
	255 - (82-164/2)/127
	x - (82-N/2)/127
	
	N = (Y*127.0-82)*2
'''
# View
from matplotlib import pyplot
import pylab


# Calc engines
from scipy.interpolate import interp1d
import random
import numpy

# my
import usaio.io_wrapper as iow
import simpleDataTypesConvertors.IntTypeConvertors as tc

# хранилище кривых
import AirCurvesDB as airDB

MAX_SPEED = 164.0

''' Метод разбивки входных данных '''
def processInData( inCurve, Hex ):
	Curve = inCurve
	Curve = Curve.replace('db',',')
	Curve = Curve.replace('\t','')
	Curve = Curve.replace('\r','')
	Curve = Curve.replace('\n','')
	Curve = Curve.replace(' ','')
	
	# разбиваем на отдельные числа
	CurveSplit = Curve.split(',')
	
	# убираем нулевой детерминатор
	del CurveSplit[-1]
	del CurveSplit[0]

	# Данные идут парами и их четное число
	xData = list()
	yData = list()
	for i in range( len(CurveSplit)/2 ):
		# если хекс формат, то нужно удалить 0x
		if Hex:
			xAt = int( tc.hexByte2uint( CurveSplit[ 2*i ] ) )
			yAt = int( tc.hexByte2uint( CurveSplit[ 2*i+1 ])*100/MAX_SPEED )  
		else :
			xAt = int( int(CurveSplit[ 2*i ]) ) 
			yAt = int( int(CurveSplit[ 2*i+1 ])*100/MAX_SPEED ) 
		
		# заполняют
		xData.append( xAt )
		yData.append( yAt )	# %
	
	# возвращаем результаты
	return xData, yData
	
''' входные данные - интерполированные '''
def plotSrcCurves( rpt, curveNames ):
	'''# Model
	curveNames = curveNames
	CurvesSet, hex = airDB.getDataFromDb(curveNames[0])

	# Офформление
	CurvesSetMark = { curveNames[0] : 'g-' }
	
	# обрабатываем
	for at in CurvesSet:
		xData, yData = processInData( CurvesSet[ at ], hex[ at ] )
		yData = yData
		pylab.hold(True)
		pylab.plot( xData, yData, CurvesSetMark[ at ], label=at, linewidth=2)'''
	
	# добавляем интерполированные данные
	pyplot.hold(True)
	xData, yData = processInData( rpt, True )
	pyplot.plot( xData, yData, 'y^-', label='src', linewidth=2)
	
	# показываем график
	pyplot.legend()
	pyplot.grid(True)
	pyplot.show()

''' Набирает строку для записи в файл '''
def rptCureve(xDataSrc, yDataSrc):
	result = '\tdb '
	resultList = list('')	# итоговая кривая
	proc2shim = MAX_SPEED/100.0
	for i in range( len(xDataSrc) ):
		value = int(xDataSrc[ i ])
		resultList.append( value )
		# читаем проценты и переводим в значения шим
		value = int( proc2shim*yDataSrc[ i ] )
		resultList.append( value )	# %
		
	# сформировать строку
	for i in range( len(resultList) ):
		at = resultList[i]
		result += tc.byte2strhex(at)
		# дополнительное форматирование
		if (i+1)%12 == 0 :
			result += '\n\tdb '
			
		else :
			result += ', '
			if (i+1)%4 == 0 :
				result += ' '
		# еще пробел
		
	# добавляем конец строки
	result += '0x00\n'
	return result

''' linear interp. air curve'''
def linInterpolAirCurve(x, y):
	# Линейная
	f = interp1d(x, y)

	# Новая ось
	xDataSrc = numpy.linspace(1, x[-1], x[-1])
	yDataSrc = f(xDataSrc)
	
	# htp
	rpt = rptCureve(xDataSrc, yDataSrc)
	fname = 'curve.txt'
		
	sets = { 'name': 'curve.txt', 'howOpen': 'w', 'coding': 'cp1251'}
	sensorSettings = iow.list2file( sets, rpt.split('\n') )
	
	#os_w.printStrToNamedFile(rpt, fname)
	
	# выводим данные
	return rpt

# Run 
if __name__ == '__main__':
	# линейная интерполяция
	# входные данные
	#'''
	y = [
		40, 40, # началное 
		70, 	# конторольная точка
		100, 100, # максиальная скорость в обычным
		100, 100	# максимальная
	]	# %
	x = [1, 26,   42,   50, 85,   86, 99]
	rpt = linInterpolAirCurve(x, y)
	
	# обработка кривой из кода
	plotSrcCurves( rpt, ['VIRTUAL_ONE'] )
	
	'''
	# Обновляем кривую
	curveNames = ['VIRTUAL_ONE']
	airDB.showDB()
	Err = airDB.addCurveIntoDB( curveNames[0], True, rpt )
	
	# запись существует?
	if not Err:
		pass
	airDB.showDB()'''

