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
from iir_models import plot_AFC
from iir_models import plot_PFC
from visualisers import plot_normalize_analog
     

if __name__ == "__main__":
    freq = arange(1000) # Hz 
    tau = (.01)
    freq_sampling = 500  # Hz

    plot_normalize_analog(tau, freq, freq_sampling,
                          plot_AFC, plot_PFC)
    show() 
    print 'Done'
    
    
    
    