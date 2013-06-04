# coding: utf-8
'''
test_iir_filters

'''
# coding: utf8
from pylab import show
from pylab import grid
from numpy import arange

# App
from iir_models import af_order1
from iir_models import af_order2_sym
from visualisers import plot_normalize_analog
     


def analog_filter_plot():
    num_points = 1024
    freq = arange(num_points) # Hz 
    freq = 
    settings = (1.7, 2.0)
    freq_sampling = 10.0  # Hz
    #af_function = af_order1
    
    #plot_normalize_analog(settings[0], af_function, freq, freq_sampling)
    #plot_normalize_analog(settings[1], af_function, freq, freq_sampling)
    
    af_function = af_order2_sym
    plot_normalize_analog(settings, af_function, freq, freq_sampling)
    grid()
    show() 
    print 'Done'
    
if __name__ == "__main__":
    
    analog_filter_plot()
    pass
    