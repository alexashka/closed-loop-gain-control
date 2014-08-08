# coding: utf-8
from numpy import angle
from numpy import conj
from numpy import real
from numpy import exp
from numpy import abs

from pylab import *

from app_math import to_dB

def af_order1(w_complex, settings_tuple):
    T = float(settings_tuple)
    y = 1/(1+w_complex*T)
    return y


def af_order2_sym(w_complex, settings_tuple):
    T1 = settings_tuple[0]
    T2 = settings_tuple[1]
    y = af_order1(w_complex, T1)*af_order1(w_complex, T2)
    return y

def af_order2_asym(w_complex, settings_tuple):
    T1 = settings_tuple[0]
    T2 = settings_tuple[1]
    K = settings_tuple[3]  # Коэффициент усиления
    y = K*af_order1(w_complex, T1)*af_order1(w_complex, T2)
    return y

def af_order2_asym_delay(w_complex, settings_tuple):
    T1 = settings_tuple[0]
    T2 = settings_tuple[1]
    t0 = settings_tuple[2]  # фазовый сдвиг
    K = settings_tuple[3]  # Коэффициент усиления
    y = K*af_order1(w_complex, T1)*af_order1(w_complex, T2)*exp(-w_complex*t0)
    return y

def calc_analog_filter_curves(params, freq_axis, af_action):
    total_samples = len(freq_axis)
    w_complex = 1j*2*pi*freq_axis 
    h, phi, h_complex = calc_afc(w_complex, params, af_action), \
        calc_pfc(w_complex, params, af_action), calc_complex_h(w_complex, params, af_action)
    
    # Нужно подправить ФЧХ
    phi_copy = arange(total_samples)
    adder = 0
    
    for i in range(total_samples-1):
        if abs(phi[i]-phi[i+1]) > 180:
            adder += abs(phi[i]-phi[i+1])
        phi_copy[i+1] = phi[i+1]-adder
        
    return (h, phi_copy, freq_axis, to_dB(h), h_complex)

def get_cut_position(h_db):
    cut_position = 0
    for i in range(len(h_db)-1):
        cut_position += 1
        if h_db[i]*h_db[i+1] < 0:
            break
    return cut_position

def calc_afc(w, params, af_action):
    y = af_action(w, params)
    y = real(conj(y)*y)**0.5
    return y

def calc_complex_h(w, params, af_action):
    y = af_action(w, params)
    return y

def calc_pfc(w, params, af_action):
    h = af_action(w, params)
    y = angle(h, deg=True) 
    return y
    
def correct_pfc(h):
    return unwrap(arctan2(imag(h),real(h)))