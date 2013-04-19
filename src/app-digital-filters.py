# coding: utf-8

"""

Характеристики для цифрового фильтра

"""

# Other
import numpy as np
from scipy import signal
from numpy import arange

# App
from visualisers import mfreqz
from visualisers import impz
from pylab import *
# Analog
#from iir_models import plot_AFC
#from iir_models import plot_PFC
from visualisers import plot_normalize_analog

# Runner
if __name__=='__main__':
    tau = 2.0
    # Сперва строим аналоговые графики
    freq = arange(10000)*0.01 # Hz 
    freq_sampling = 5  # Hz

    #plot_normalize_analog(tau, freq, freq_sampling, plot_AFC, plot_PFC)
    
    # Синтез цифрового фильта
    b_analog = np.array([1.0]) 
    a_analog = np.array([tau, 1.0]) 
    
    from numpy.polynomial import Polynomial as P
    p = P([1,2])
    ans = p*p
    a_analog = ans.coef
    # TODO(): перемножение полиномов
    
    b, a = signal.bilinear(b_analog, a_analog, fs=freq_sampling)
    #print b, a
    
    #impz(b, a)
    mfreqz(b, a)
    show()

    print 'Done'


    
