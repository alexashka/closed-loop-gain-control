#-*- coding: utf-8 -*-
""" 
    Хранит историю изменений по имени
    Y% - (82-N/2)/127
    
    255 - (82-164/2)/127
    x - (82-N/2)/127
    
    N = (Y*127.0-82)*2
"""
# Sys
import sys
sys.path.append('D:/home/lugansky-igor/github-dev')
sys.path.append('D:/home/lugansky-igor/github-dev/py-bale')
import random

# Other
# View
from matplotlib import pyplot
import pylab
# Calc engines
import numpy
import scipy.interpolate as interpolators

# Dev
import uasio.os_io.io_wrapper as iow
import convertors_simple_data_types.xintyy_type_convertors as tc
#import AirCurvesDB as airDB  # хранилище кривых

kMaxSpeed_ = 164.0  # важно!

""" Метод разбивки входных данных """
def _process_in_data(inCurve, Hex):
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
    for i in range(len(CurveSplit)/2):
        # если хекс формат, то нужно удалить 0x
        if Hex:
            xAt = int(tc.hexByte2uint(CurveSplit[2*i]))
            yAt = int(tc.hexByte2uint(CurveSplit[2*i+1])*100/kMaxSpeed_)  
        else :
            xAt = int(int(CurveSplit[2*i])) 
            yAt = int(int(CurveSplit[2*i+1])*100/kMaxSpeed_) 
        
        # заполняют
        xData.append(xAt)
        yData.append(yAt)    # %
    
    # возвращаем результаты
    return xData, yData
    
def plot_src_curves(rpt, curveNames):
    """ входные данные - интерполированные """
    """# Model
    curveNames = curveNames
    CurvesSet, hex = airDB.getDataFromDb(curveNames[0])

    # Офформление
    CurvesSetMark = { curveNames[0] : 'g-' }
    
    # обрабатываем
    for at in CurvesSet:
        xData, yData = _process_in_data(CurvesSet[at], hex[at])
        yData = yData
        pylab.hold(True)
        pylab.plot(xData, yData, CurvesSetMark[at], label=at, linewidth=2)"""
    
    # добавляем интерполированные данные
    pyplot.hold(True)
    xData, yData = _process_in_data(rpt, True)
    pyplot.plot(xData, yData, 'y^-', label='src', linewidth=2)
    
    # показываем график
    pyplot.legend()
    pyplot.grid(True)
    pyplot.show()

def _rpt_curve(xDataSrc, yDataSrc):
    """ Набирает строку для записи в файл """
    result = '    db '
    resultList = list('')    # итоговая кривая
    proc2shim = kMaxSpeed_/100.0
    for i in range(len(xDataSrc)):
        value = int(xDataSrc[i])
        resultList.append(value)
        # читаем проценты и переводим в значения шим
        value = int(proc2shim*yDataSrc[i])
        resultList.append(value)    # %
        
    # сформировать строку
    for i in range(len(resultList)):
        at = resultList[i]
        result += tc.byte2strhex(at)
        # дополнительное форматирование
        if (i+1)%12 == 0 :
            result += '\n    db '
            
        else :
            result += ', '
            if (i+1)%4 == 0 :
                result += ' '
        # еще пробел
        
    # добавляем конец строки
    result += '0x00\n'
    return result

def lin_interpol_fan_curve(x, y):
    """ linear interp. air curve"""
    # Линейная
    f = interpolators.interp1d(x, y)

    # Новая ось
    xDataSrc = numpy.linspace(1, x[-1], x[-1])
    yDataSrc = f(xDataSrc)
    
    # htp
    rpt = _rpt_curve(xDataSrc, yDataSrc)
    fname = 'curve.asm'
        
    sets = { 'name': fname, 'howOpen': 'w', 'coding': 'cp1251'}
    sensorSettings = iow.list2file(sets, rpt.split('\n'))
    print 'Curve print in file '+fname
   
    return rpt

# Run 
if __name__ == '__main__':
    # линейная интерполяция
    # входные данные
    #"""
    y = [
        40, 40, # началное 
        70,     # конторольная точка
        100, 100, # максиальная скорость в обычным
        100, 100    # максимальная
   ]    # %
    x = [1, 26,   42,   50, 85,   86, 99]
    rpt = lin_interpol_fan_curve(x, y)
    
    # обработка кривой из кода
    plot_src_curves(rpt, ['VIRTUAL_ONE'])
    
    """
    # Обновляем кривую
    curveNames = ['VIRTUAL_ONE']
    airDB.showDB()
    Err = airDB.addCurveIntoDB(curveNames[0], True, rpt)
    
    # запись существует?
    if not Err:
        pass
    airDB.showDB()"""

