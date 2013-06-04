# coding: utf-8
from numpy import angle
from numpy import conj
from numpy import real

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
