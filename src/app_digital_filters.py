# coding: utf-8

"""

Характеристики для цифрового фильтра

"""

# Other
from pylab import *
import numpy as np
from scipy import signal
from numpy import arange

# App
from visualisers import mfreqz
from visualisers import impz

# Analog
#from iir_models import plot_AFC
#from iir_models import plot_PFC
from numpy.polynomial import Polynomial as P
from visualisers import plot_normalize_analog


# Runner
def calc_digital_characteristics(T, freq_sampling): 
    """ Model """   
    # Синтез цифрового фильта
    b_analog = np.array([1.0]) 
    a_analog = np.array([T, 1.0]) 
    
    
    p = P([1,T])
    ans = p*p
    a_analog = ans.coef
    # TODO(): перемножение полиномов ???!!!
    
    b, a = signal.bilinear(b_analog, a_analog, fs=freq_sampling)
    return b, a, freq_sampling

    

if __name__=='__main__':
    T = 2
    freq = arange(10000)*0.01 # Hz 
    freq_sampling = 5  # Hz
    
    """ Model """
    b, a = calc_digital_characteristics(T, freq_sampling)
    
    """ View """
    #plot_normalize_analog(tau, freq, freq_sampling, plot_AFC, plot_PFC)
    #impz(b, a)
    mfreqz(b, a)
    show()
    print 'Done'  


    
