# coding: utf-8
# std
import json

# Other
from pylab import plot
from pylab import xlabel
from pylab import ylabel
from pylab import show
from pylab import grid
from pylab import hist

from numpy import array
from numpy import append
from numpy import concatenate
from numpy import zeros
from numpy import ones
from numpy import arange
from numpy.polynomial import Polynomial as P

# App
from measure_processors import get_list_curves
from measure_processors import get_list_art_curves

from app_math.simple_math_operators import XAxis

import dsp_modules.signal_generator as gen

from dsp_modules.signal_generator import wrapper_for_finding_2l_del_full
from dsp_modules.signal_templates import get_metro_and_axis
from dsp_modules.signal_generator import e_del_full

from opimizers import run_approximation

from iir_models import get_cut_position
from iir_models import af_order2_asym_delay
from iir_models import calc_analog_filter_curves
from iir_models.iir_digital import calc_digital_characteristics
from iir_models.iir_digital import get_dfilter_axises
from iir_models.iir_digital import get_stability_notes

from visualisers import plot_normalize_analog
from visualisers import calc_half_fs_axis
from visualisers import mfreqz
from visualisers import impz


def get_notes(curves, axis, zero_point=None):
    params = []
    for curve in curves:
        v0 = zero_point  # Initial parameter value
        v_result = run_approximation(curve, axis, v0, e_del_full)
        print v_result
        params.append(v_result)
    return params
 
def main():
    # Исходные параметры
    voltage_agc_ref = 1.2  # V - AGC - auto gain control
    dVoltage = 0.6  # V - тестовый скачек
    tau = 15.0  # оценочное врем переходный процессов
    window_metro = tau*3  # sec.
    Fs = 30.0  # freq. sampling - Hz ; with oversampling
    num_points = window_metro*Fs  # сколько отсчетов берем
    # Задаем начальное приближение
    # Все времена порядка секунд
    T1 = 2.0
    T2 = 1.0
    dt = 0.0
    max_dtemperature = 3.0
    temperature_ref = 70.0
    zero_point = (T1, T2, dt, max_dtemperature, temperature_ref)
    axis = XAxis(num_points, 1/Fs)  # Общая временная ось

    # Получить измеренные кривые
    print 'Measures processing...'
    if False:
        print "num_points: ", num_points
        count_curves = 6
        curves = get_list_curves(axis=axis, count_curves=count_curves)
        
        # Оцениваем все параметры кривых
        params = get_notes(curves, axis, zero_point)
        
        if False:
            x = axis.get_axis()
            for curve in curves:
                #plot(x, curve,'b')
                pass
            for record in params:    
                #plot(x, wrapper_for_finding_2l_del_full(record, x),'r')
                pass
            #grid(); show()

    # Усредняем
    if False:
        # Предыдущее условие должно быть True
        # Рассчитываем
        mean_params  = mean_list_lists(params)
    else:
        
        # Используем уже полученные результаты
        mean_params = [  5.32255626,   3.07633474,   0.88892465,   2.14692147,  69.83541651]
    print 'Mean params =', mean_params 
    
    # Оценка стойкости к зашумленности исходных данных
    # Рассматривается только аддитивный белый гауссовский шум
    # Как показывают опыты, если шум мал, то все параметры оцениваются
    #   достаточно точно.
    #
    # Не будем использовать - слишком долго считает
    if False:
        count_curves= 100
        sigma = 0.03  # зашумленность сигнала
        curves = []
        for i in range(count_curves):
            noise = gen.get_gauss_noise(sigma, len(axis.get_axis()))
            curve = get_list_art_curves(
                    axis=axis, 
                    noise=noise, 
                    count_curves=count_curves, 
                    base_params=mean_params)
            curves.append(curve[0])
        x = axis.get_axis()
        for curve in curves:
            #plot(x, curve,'b')
            pass
        #show()
        params = get_notes(curves, axis, zero_point)
        T1_set = []
        for record in params:  
            T1_set.append(record[0])  
            pass
        print T1_set
        hist(T1_set, 20)  # Гистограмма
        show()
    
    # Рассчитываем незашумленную кривую
    work_freq = 3.0  # Hz
    T1, T2, dt, max_dtemperature, temperature_ref = mean_params
    params = T1, T2, dt, max_dtemperature/dVoltage, temperature_ref
    if True:
        # Аналоговая часть
        print '\nAnalog...'
        num_points = 1024
        freq_axis = calc_half_fs_axis(num_points, work_freq)
        h, phi, freq_axis, h_db, h_complex = calc_analog_filter_curves(
                params, 
                freq_axis, 
                af_order2_asym_delay)
        cut_position = get_cut_position(h_db)
             
        # Рисуем
        # Запас по фазе должен быть больше -180 (-120...)
        rest_phase, rest_ampl = get_stability_notes(h_complex)
        print 'Phase rest =', rest_phase
        print 'Phase magnitude =', 1/rest_ampl
        plot_normalize_analog(h, phi, freq_axis, work_freq, cut_position)
        #show()

    if True:
        # Цифровая часть
        print '\nDigital...'
        b, a, fs = calc_digital_characteristics(params[:-1], work_freq)
        
        # Моделирование сдвига сигнала во времени
        # Точность моделирования задержки - такт. Округляем в большую сторону
        delay = zeros(work_freq*dt+2)
        delay[-1] = 1
        b = (P(b)*P(delay)).coef
        
        print 'b =',b 
        print 'a =', a
        h, w = get_dfilter_axises(b, a)
        
        rest_phase, rest_ampl = get_stability_notes(h)
        print 'Phase rest =', rest_phase
        print 'Phase magnitude =', 1/rest_ampl
        
        
        """ View """
        #impz(b, a)
        mfreqz(h, w)
        show()
        
        if False:
            # Оценка точности
            pass
        
        if True:
            # Оценка устойчивости
            pass
        
        # Решение проблем, связанных с переходом 
        #   от дискретной системы к цифровой
        if False:
            # Исследование комбинации фильтра, сглаживающего
            #   сигнал ошибки и усилителя
            pass
        
if __name__=='__main__':
    main()
    print 'Done'
    
    
