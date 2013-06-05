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


# App
from iir_models import af_order1
from iir_models import af_order2_sym
from visualisers import plot_normalize_analog
from app_math.simple_math_operators import XAxis
     


def analog_filter_plot():
  
    freq = arange(1000) # Hz 
    settings = (1.833, 1.561)
    freq_sampling = 100  # Hz
    af_function = af_order1
    num_points = 5*freq
    print "num_points: ", num_points
    #plot_normalize_analog(settings[0], af_function, freq, freq_sampling)
    #plot_normalize_analog(settings[1], af_function, freq, freq_sampling)
    
    
    sigma = 0.03  # зашумленность сигнала
    
    axis = XAxis(num_points, freq)
    curves = plot_normalize_analog(settings, af_function, freq, freq_sampling)
    
    # Оцениваем все параметры кривых
    # DEVELOP
    x = axis.get_axis()
    plot(curves)
        
        
    af_function = af_order2_sym
    plot_normalize_analog(settings, af_function, freq, freq_sampling)
    grid()
    show() 
    print 'Done'
    
if __name__ == "__main__":
    
    analog_filter_plot()
    print 'Done'
    pass
    