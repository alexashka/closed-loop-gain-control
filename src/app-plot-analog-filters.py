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
from iir_models import af_order2_asym
from visualisers import plot_normalize_analog
     


def analog_filter_plot():
    freq_sampling = 4.0  # Hz
    num_points = 1024
    freq_axis = arange(num_points)*freq_sampling/2/num_points # Hz 
    params = (1.7, 2.0, None, 3.0)
    
    #af_function = af_order1
    
    #plot_normalize_analog(settings[0], af_function, freq, freq_sampling)
    #plot_normalize_analog(settings[1], af_function, freq, freq_sampling)
    
    af_function = af_order2_asym
    h, phi = plot_normalize_analog(params, af_function, freq_axis, freq_sampling)
    show() 
    print 'Done'
    
if __name__ == "__main__":
    
    analog_filter_plot()
    pass
    