# coding: utf8

from pylab import plot
from pylab import xlabel
from pylab import ylabel
from pylab import show
from pylab import grid

import math

from numpy import random
from numpy import array
from numpy import append
from numpy import concatenate
from numpy import zeros
from numpy import arange
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

# App
from iir_models import get_cut_position
from iir_models import af_order2_asym_delay
from iir_models import calc_analog_filter_curves

from visualisers import plot_normalize_analog
from visualisers import calc_half_fs_axis

def get_list_curves(
                    axis, 
                    noise, 
                    count_iteration_metro, add_multiplicate_noise=True,
                    base_params=None):
    curves = []
    T1, T2, dt, max_dtemperature, temperature_ref = base_params
    for metro in range(count_iteration_metro):
        t = axis.get_axis()
        
        # Params
        if add_multiplicate_noise:
            k = 0.000003
        else:
            k = 0.03
        num_points = 1
        
        temperature_ref += random.normal(0, temperature_ref*k/30, size=num_points)
        dt +=  random.normal(0, dt*k*2*4, size=num_points)
        max_dtemperature += random.normal(0, max_dtemperature*k, size=num_points)  # фиктивный 
        curve = gen.ht_2level_del(t, T1, T2, dt)*max_dtemperature+temperature_ref

        # Добавляем шум
        curve += noise

        # Сохраняем кривую
        curves.append(mock_curve(curve))
    return curves

def mock_curve(curve):
    result = curve
    for i in range(len(curve)):
        result[i] = math.floor(curve[i]*10.0)/10
        #print math.floor(curve[i]*100)/100
    
    return result
    

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
        # 15 секунд - отрезок времени. Предполагается, что переходные процессы завершаются за
        # время 3tau = 3*5
<<<<<<< HEAD
        tau = 15.0  # оценочное врем переходный процессов
=======
        tau = 8.0  # оценочное время переходный процессов
>>>>>>> f05c58b765755759c21073a154f80dd688a0cc4f
        window_metro = tau*3  # sec.
        Fs = 30.0  # freq. sampling - Hz ; with oversampling
    
        num_points = window_metro*Fs
        print "num_points: ", num_points
        count_iteration_metro = 6
        sigma = 0.03  # зашумленность сигнала
        
        axis = XAxis(num_points, 1/Fs)
        noise = gen.get_gauss_noise(sigma, num_points)
        
        # Базовые параметры
        max_dtemperature = 2.0  # высота ступеньки
        temperature_ref = 70  # смещение кривой по оси Оy
        T1 = 5.4  # sec.
        T2 = 3.0  # sec.
        dt = 1.0  # фазовый сдвиг кривой
        base_params = (T1, T2, dt, max_dtemperature, temperature_ref)
        print 'T1', T1
        print 'T2', T2
        curves = get_list_curves(axis, noise, count_iteration_metro, False, base_params)
        
        # Оцениваем все параметры кривых
        T1 = 2.0
        T2 = 1.0
        dt = 0.0
        max_dtemperature = 3.0
        temperature_ref = 70.0
        zero_point = (T1, T2, dt, max_dtemperature, temperature_ref)
        params = get_notes(curves, axis, zero_point)
        
        # DEVELOP
        x = axis.get_axis()
        for curve in curves:
            #plot(x, curve,'b')
            pass

        for record in params:    
            #plot(x, wrapper_for_finding_2l_del_full(record, x),'r')
        #grid(); show()


        
        def mean_list_lists(list_lists):
            count_lists = len(list_lists)
            result = zeros(len(list_lists[0]))
            for list_values in list_lists:
                result += list_values
            summary = [] 
            for value in result:
                summary.append(value/count_lists)
            return array(summary)
    

        mean_params = [  5.32255626,   3.07633474,   0.88892465,   2.14692147,  69.83541651]#mean_list_lists(params)
        print 'mean', mean_params 
        
        # Генерируем зашумленные данные 
        
        #get_list_curves() 
        
        # Рассчитываем незашумленную кривую
        if True:
            T1, T2, dt, max_dtemperature, temperature_ref = mean_params
            freq_sampling = 3.0  # Hz
            num_points = 1024
            freq_axis = calc_half_fs_axis(num_points, freq_sampling)
            dVoltage = 0.6  # V
            params = T1, T2, dt, max_dtemperature/dVoltage, temperature_ref
            h, phi, freq_axis, h_db = calc_analog_filter_curves(
                                                                params, 
                                                                freq_axis, 
                                                                af_order2_asym_delay)
            cut_position = get_cut_position(h_db)
                
            # Рисуем
            print phi[cut_position]  # Запас по фазе должен быть больше -180 (-120...)
            plot_normalize_analog(h, phi, freq_axis, freq_sampling, cut_position)
            show()


    main()
    print 'Done'
    
    
