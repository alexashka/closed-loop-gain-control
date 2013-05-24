# coding: utf8

from pylab import plot
from pylab import show
from pylab import grid


# Other
import dals.os_io.io_wrapper as dal

# App
import dsp_modules.signal_generator as gen
from app_math.simple_math_operators import XAxis
from dsp_modules.signal_generator import wrapper_for_finding_2l_del_full
from dsp_modules.signal_templates import get_metro_and_axis
from dsp_modules.signal_generator import e_del_full
from opimizers import run_approximation

def get_list_curves(
                    axis, 
                    noise, 
                    count_iteration_metro):
    temperature_ref = 70  # DEVELOP
    curves = []
    for metro in range(count_iteration_metro):
        dt = 2.0*(metro+1)  # рандомное реально, но сперва нужно проверить алгоритм оценивания
        max_dtemperature = 3  # фиктивный       
        
        T1 = 1.4  # sec.
        T2 = 2.0  # sec.
        t = axis.get_axis()
        curve = gen.ht_2level_del(t, T1, T2, dt)*max_dtemperature

        # Добавляем шум
        curve += noise+temperature_ref

        # Сохраняем кривую
        curves.append(curve)
    return curves

def get_notes(curves, axis):
    params = []
    for curve in curves:
        T1 = 5.0
        T2 = 1.0
        dt = 0.0
        k = 3.0
        t0 = 70.0
        v0 = [T1, T2, dt, k, t0]  # Initial parameter value
        v_result = run_approximation(curve, axis, v0, e_del_full)
        print v_result
        params.append(v_result)
    return params
    
if __name__=='__main__':
    def main():
        # rpt
        #coeff_decimation = 10;
        #num_column_in_rpt = 20;
        #rpt = []
        
        #
        voltage_agc_ref = 1.2  # V - AGC - auto gain control
        dv_ref = 0.1  # V - тестовый скачек
        #temperature_ref = 60  # oC
        
        # Задаем начальные параметры
        # Постоянные времени измеряются секундами, поэтому частота дискретизации
        #   должна быть в районе одного Гц. Применим oversampling пусть частота будет 100 Гц.
        #
        # 15 секунда - отрезок времени. Предполагается, что переходные процессы завершаются за
        # время 3tau = 3*5
        tau = 8.0  # оценочное врем переходный процессов
        window_metro = tau*3  # sec.
        Fs = 100.0  # freq. sampling - Hz ; with oversampling
    
        num_points = window_metro*Fs
        print "num_points: ", num_points
        count_iteration_metro = 2
        sigma = 0.05  # зашумленность сигнала
        
        axis = XAxis(num_points, 1/Fs)
        noise = gen.get_gauss_noise(sigma, num_points)
        curves = get_list_curves(axis, noise, count_iteration_metro)
        
        # Оцениваем все параметры кривых
        params = get_notes(curves, axis)
        
        # DEVELOP
        x = axis.get_axis()
        for curve in curves:
            plot(x, curve,'b')
        for record in params:    
            plot(x, wrapper_for_finding_2l_del_full(record, x),'g')
        grid(); show()
    
           
        
        # Рассчитываем незашумленную кривую
        
        """
        # Для каждого из опытов
        sum = ''
        first_line_rpt = ''
        for i in range(num_points+1):
                sum += str(i)+' , '
        print sum
        rpt.append(sum)   
            
            
        for idx in range(count_metro):
            one_line_rpt = ''
            
            # Generate noize
            y = gen.get_gauss_noise(sigma, num_points)
            
            acum = ''
            for sample in y:
                tmp = int(sample*1000)/1000.0
                acum += str(tmp)+', '
            
            one_line_rpt += str(idx+1)+' , '+acum
            #print idx
            # Зашумляем одну
            
            # Пишем в отчет *.csv 
            # 1, 2, 8
            # 3, 8, ...
            rpt.append(one_line_rpt)
         
         
        def printer(msg):
            print msg
        #map(printer, rpt)
        
        sets = {}
        #dal.
        sets['name'] = 'source_rpt.csv'
        sets['howOpen'] = 'w'
        sets['coding'] = 'utf8'
        dal.list2file(sets, rpt)
            
        """
        
    main()
    print 'Done'
