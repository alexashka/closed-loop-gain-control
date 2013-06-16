# coding: utf-8
import math

# Other
from numpy import random

# App
import dsp_modules.signal_generator as gen

def mock_curve(curve):
    result = curve
    for i in range(len(curve)):
        result[i] = math.floor(curve[i]*10.0)/10   
    return result

def get_list_curves(axis, 
                    noise=None, 
                    count_curves=0, 
                    add_multiplicate_noise=False,
                    base_params=None):
    curves = []
    if not base_params:
        max_dtemperature = 2.0  # высота ступеньки
        temperature_ref = 70  # смещение кривой по оси Оy
        T1 = 5.4  # sec.
        T2 = 3.0  # sec.
        dt = 1.0  # фазовый сдвиг кривой
        base_params = (T1, T2, dt, max_dtemperature, temperature_ref)
        print 'T1', T1
        print 'T2', T2
        
    if not noise:
        sigma = 0.03  # зашумленность сигнала
        noise = gen.get_gauss_noise(sigma, len(axis.get_axis()))
        
    T1, T2, dt, max_dtemperature, temperature_ref = base_params
    for metro in range(count_curves):
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

def get_list_art_curves(axis, 
                    noise=None, 
                    count_curves=0,
                    base_params=None):
    curves = []       
    T1, T2, dt, max_dtemperature, temperature_ref = base_params
    for i in range(count_curves):
        t = axis.get_axis()
        
        # Params
        num_points = 1
        curve = gen.ht_2level_del(t, T1, T2, dt)*max_dtemperature+temperature_ref

        # Добавляем шум
        curve += noise

        # Сохраняем кривую
        curves.append(mock_curve(curve))
    return curves