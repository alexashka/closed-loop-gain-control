# coding: utf-8
'''
Created on 07.06.2013

@author: кей
'''
from scipy import signal
from numpy import array
from numpy.polynomial import Polynomial as P
from numpy import ones

# Runner
def calc_digital_characteristics(params, freq_sampling): 
    """ Model """  
    (T1, T2, t0, K) = params
    # Синтез цифрового фильта
    b_analog = array([K]) 
  
    # Судя по всему это повышение порядка фильтра
    p1 = P([T1, 1])
    p2 = P([T2, 1])
    ans = p1*p2
    a_analog = ans.coef
    print a_analog
    
    b, a = signal.bilinear(b_analog, a_analog, fs=freq_sampling)
    return b, a, freq_sampling