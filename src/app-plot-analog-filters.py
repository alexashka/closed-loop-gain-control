# coding: utf-8
'''
test_iir_filters

'''
# coding: utf8
from pylab import plot
from pylab import subplot
from pylab import show
from pylab import grid
from numpy import ndarray
from numpy import arange

from numpy import imag
from numpy import exp
from numpy import pi

# App
from iir_models import af_order1
from iir_models import af_order2_sym
from visualisers import plot_normalize_analog
     

if __name__ == "__main__":
    freq = arange(1000) # Hz 
    settings = (.01)
    freq_sampling = 500  # Hz
    af_function = af_order1

    plot_normalize_analog(settings, af_function, freq, freq_sampling)
    
    af_function = af_order2_sym
    plot_normalize_analog(settings, af_function, freq, freq_sampling)
    grid()
    show() 
    print 'Done'
    
    
    
    