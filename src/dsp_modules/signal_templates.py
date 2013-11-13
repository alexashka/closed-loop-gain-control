# coding: utf-8
'''
Created on 24.05.2013

@author: кей
'''

# App 
import dsp_modules.signal_generator as generator
from app_math.simple_math_operators import XAxis
def get_metro_and_axis():
    T1 = 5
    T2 = 20.0
    
    num_points = 1000
    sigma = 0.05  # вообще нужно бы ограничить
    frequency = 10.0  # Hz
    dx = 1/frequency
    x_obj = XAxis(num_points, dx)
    
    # Begin()    
    x = x_obj.get_axis()
    ht = generator.ht_2level(x, T1, T2)
    #plot(x, ht, color='#000000', lw=4)
    noise = generator.get_gauss_noise(sigma, num_points)
    metro_signal = ht+noise  # Как бы померенный сигнал
    return metro_signal, x_obj, ht 
