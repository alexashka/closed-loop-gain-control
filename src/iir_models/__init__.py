from numpy import angle
from numpy import conj
from numpy import real

def af_order1(w_complex, settings_tuple):
    T = float(settings_tuple)
    y = 1/(1+w_complex*T)
    return y

def af_order2_sym(w_complex, settings_tuple):
    y = af_order1(w_complex, settings_tuple)*af_order1(w_complex, settings_tuple)
    return y
