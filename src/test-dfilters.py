# coding: utf-8

"""

Характеристики для цифрового фильтра

"""

# Other
from pylab import *
from numpy import arange
from numpy import ones

# App
from visualisers import mfreqz
from visualisers import impz
from iir_models.iir_digital import calc_digital_characteristics
   

if __name__=='__main__':
    mean_params = (5.32255626,   3.07633474,   0.88892465,   2.14692147,  69.83541651)
    (T1, T2, t0, K, dy) = mean_params
    #K = 1
    freq = arange(10000)*0.01 # Hz 
    freq_sampling = 1  # Hz
    
    """ Model """
    b, a, fs = calc_digital_characteristics((T1, T2, t0, K), freq_sampling)
    print b, a
    #b = ones(1)
    from numpy.polynomial import Polynomial as P
    a1 = P(b)
    a2 = P([0,0,0,1])
    b = (a1*a2).coef
    
    """ View """
    #plot_normalize_analog(tau, freq, freq_sampling, plot_AFC, plot_PFC)
    #impz(b, a)
    mfreqz(b, a)
    
    b, a, fs = calc_digital_characteristics((T1, T2, t0, K), freq_sampling)
    print b, a
    
    """ View """
    #plot_normalize_analog(tau, freq, freq_sampling, plot_AFC, plot_PFC)
    #impz(b, a)
    mfreqz(b, a)
    
    show()
    print 'Done'  


    
