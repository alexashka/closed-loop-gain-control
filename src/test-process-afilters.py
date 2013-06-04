# coding: utf-8
'''
Считает характеристики аналоговых фильтров и выводи их

'''
from pylab import show
from pylab import plot

# App
from iir_models import af_order2_asym
from iir_models import af_order2_asym_delay
from iir_models import calc_analog_filter_curves

from visualisers import plot_normalize_analog
from visualisers import calc_half_fs_axis
     
def analog_filter_plot():
    freq_sampling = 4.0  # Hz
    num_points = 1024
    freq_axis = calc_half_fs_axis(num_points, freq_sampling)
    params = (1.7, 1.0, 0.5, 3.0)
    #h, phi, freq_axis = calc_analog_filter_curves(params, freq_axis, af_order2_asym)
    #plot_normalize_analog(h, phi, freq_axis, freq_sampling)

    h, phi, freq_axis, h_db = calc_analog_filter_curves(params, freq_axis, af_order2_asym_delay)
    cut_position = 0
    for i in range(len(h)-1):
        cut_position += 1
        if h_db[i]*h_db[i+1] < 0:
            print h_db[i], phi[i], freq_axis[i]
            #plot(freq_axis[i]/freq_sampling, phi[i], 'v')
            break
        
    # Рисуем
    plot_normalize_analog(h, phi, freq_axis, freq_sampling, cut_position)
    
    
    
    show() 
    
    
if __name__ == "__main__":
    analog_filter_plot()
    print 'Done'
    