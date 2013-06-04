# coding: utf-8
from numpy import angle
from numpy import conj
from numpy import real

from pylab import *

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


def calc_analog_filter_curves(params, freq_axis, af_action):
    w_complex = 1j*2*pi*freq_axis 
    h, phi = calc_afc(w_complex, params, af_action), calc_pfc(w_complex, params, af_action)
    return (h, phi, freq_axis)

def calc_afc(w, params, af_action):
    y = af_action(w, params)
    y = real(conj(y)*y)**0.5
    return y

def calc_pfc(w, params, af_action):
    h = af_action(w, params)
    y = angle(h, deg=True) 
    return y
    