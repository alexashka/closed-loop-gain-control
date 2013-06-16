# coding: utf-8
'''
Created on 07.06.2013

@author: кей
'''
from scipy import signal
from numpy import array
from numpy.polynomial import Polynomial as P
from numpy import ones
from numpy import pi
from numpy import abs
from numpy import angle

# App
from iir_models import get_cut_position
from app_math import to_dB

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
    #print a_analog
    
    b, a = signal.bilinear(b_analog, a_analog, fs=freq_sampling)
    return b, a, freq_sampling

def get_dfilter_axises(b, a):
    w, h = signal.freqz(b,a, worN=1024, whole=False)
    return h, w

def get_stability_notes(h, w, count_points):
    from app_math import find_first_zero_idx
    """ По Найквесту """
    # Сперва запас по фазе 
    cut_position = find_first_zero_idx(to_dB(abs(h)))
    phase_margin = angle(h[cut_position])*180/pi
    print 'Phase rest (digital) =', 180-abs(phase_margin)
    
    # По амплитуде
    phases_rad = angle(h)
    print phases_rad+pi
    pass

def mult_chapters():
    pass
