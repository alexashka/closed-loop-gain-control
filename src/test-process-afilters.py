# coding: utf-8
'''
Считает характеристики аналоговых фильтров и выводи их

'''
from pylab import show

# App
from iir_models import af_order2_asym
from iir_models import calc_analog_filter_curves

from visualisers import plot_normalize_analog
from visualisers import calc_half_fs_axis
     
def analog_filter_plot():
    freq_sampling = 4.0  # Hz
    num_points = 1024
    freq_axis = calc_half_fs_axis(num_points, freq_sampling)
    params = (1.7, 2.0, None, 3.0)
    h, phi, freq_axis = calc_analog_filter_curves(params, freq_axis, af_order2_asym)
    plot_normalize_analog(h, phi, freq_axis, freq_sampling)
    show() 
    
    
if __name__ == "__main__":
    analog_filter_plot()
    print 'Done'
    