# coding: utf8

from pylab import plot
from pylab import show
from pylab import grid

from numpy import random
from numpy import array
from numpy import append
from numpy import concatenate
from numpy import zeros
import json


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
                    count_iteration_metro, add_multiplicate_noise=True,
                    base_params=None):
    curves = []
    (T1, T2, dt, max_dtemperature, t0) = base_params
    for metro in range(count_iteration_metro):
        t = axis.get_axis()
        
        # Params
        if add_multiplicate_noise:
            k = 0.000003
        else:
            k = 0.003
        num_points = 1
        
        temperature_ref += random.normal(0, temperature_ref*k/50, size=num_points)
        dt +=  random.normal(0, dt*k*2, size=num_points)
        #max_dtemperature += random.normal(0, max_dtemperature*k, size=num_points)  # фиктивный 
        curve = gen.ht_2level_del(t, T1, T2, dt)*max_dtemperature+temperature_ref

        # Добавляем шум
        curve += noise

        # Сохраняем кривую
        curves.append(curve)
    return curves

def get_notes(curves, axis, zero_point=None):
    params = []
    for curve in curves:
        v0 = zero_point  # Initial parameter value
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
        count_iteration_metro = 20
        sigma = 0.03  # зашумленность сигнала
        
        axis = XAxis(num_points, 1/Fs)
        noise = gen.get_gauss_noise(sigma, num_points)
        max_dtemperature = 3  # фиктивный 
        temperature_ref = 70  # DEVELOP
        T1 = 1.4  # sec.
        print 'T1', T1
        T2 = 2.0  # sec.
        print 'T2', T2
        dt = 4.0  # рандомное реально, но сперва нужно проверить алгоритм оценивания
        base_params = (T1, T2, dt, max_dtemperature, temperature_ref)
        curves = get_list_curves(axis, noise, count_iteration_metro, base_params)
        
        # Оцениваем все параметры кривых
        T1 = 5.0
        T2 = 1.0
        dt = 0.0
        k = 3.0
        t0 = 70.0
        zero_point = (T1, T2, dt, k, t0)
        params = get_notes(curves, axis, zero_point)
        
        # DEVELOP
        x = axis.get_axis()
        for curve in curves:
            plot(x, curve,'b')
            
        #metro_data = {'measure':curves_save}#, 'axis': list(axis.get_axis())}
        #print metro_data
        #string_json = json.dumps(curves, indent=4)
        #print string_json
        
        for record in params:    
            plot(x, wrapper_for_finding_2l_del_full(record, x),'g')
        grid(); show()
        
        def mean_list_lists(list_lists):
            count_lists = len(list_lists)
            result = zeros(len(list_lists[0]))
            for list_values in list_lists:
                result += list_values
            summary = [] 
            for value in result:
                summary.append(value/count_lists)
            return array(summary)
    
        print 'mean', mean_list_lists(params)  
        
        # Генерируем зашумленные данные 
        
        #get_list_curves() 
        
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
