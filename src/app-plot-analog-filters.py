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
    
    af_action = af_order2_asym
    h, phi, freq_axis = calc_analog_filter_curves(params, freq_axis, af_action)
    plot_normalize_analog(params, af_function, freq_axis, freq_sampling)
    show() 
    
    
if __name__ == "__main__":
    
    analog_filter_plot()
    print 'Done'
    