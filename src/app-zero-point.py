# coding: utf8
"""

  TODO(?): что будет есть характеристика колебательная?
"""

# Other
from pylab import *
from numpy import *
from scipy.optimize import leastsq
import scipy.interpolate as interpolators

# App 
import dsp_modules.signal_generator as generator
from app_math.simple_math_operators import XAxis
from dsp_modules.signal_templates import get_metro_and_axis

def e(v, x, y):
    """ Error function. Очень важная. """
    return (generator.real_relation(v,x)-y)
   
def decimate_ox(ox, metro_signal):
    result_x = []
    result_y = []
    for i in range(len(ox)): 
        if i%90 == 0:
            result_x.append(ox[i])
            result_y.append(metro_signal[i])
    return  result_x, result_y

def lin_line(x, k, b):
    y = k*x+b
    return y

def cut_tangent(y):
    ymax = 1
    y_result = []
    yes = False
    
    for yi in y:
        if yi < 0:
            y_result.append(0)
            yes = True
        elif yi > ymax:
            y_result.append(1)
        else:
            y_result.append(yi)
            
    return y_result, yes
    
def find_roots(diff_two_order):
    roots_d_two = []
    for j in range(len(diff_two_order)):
        if j < len(diff_two_order)-1:
            mult_ = diff_two_order[j]*diff_two_order[j+1]*1e+12
            if mult_ < 0:
                roots_d_two.append(j)
                
    return roots_d_two



def plot_ht():
    def lin_interpol_fan_curve(x, y, x_main):
        """ linear interp. air curve"""
        # Линейная
        f = interpolators.interp1d(x, y, kind='cubic')
    
        # Новая ось
        yDataSrc = f(x_main)
       
        return yDataSrc   
    """ """
    
    metro_signal, x_obj, x, ideal = get_metro_and_axis()
    # Смотрим что вышло
    plot(x, metro_signal,'b')
    return
    
    # Нужно найти точку нулевого приближения
    # Выделим некотороые отсчеты
    decimated_x, decimated_y = decimate_ox(x, metro_signal)
    decimated_x.append(x[-1])
    decimated_y.append(metro_signal[-1])
    #plot(decimated_x, decimated_y,'rv')
    
    
    # Сгладить
    y_smooth = lin_interpol_fan_curve(decimated_x, decimated_y, x)  
    plot(x, y_smooth,'r')
    
    
    # Продиффиренцировать
    diff_first_order = x_obj.calc_diff(y_smooth)
    #plot(x[:-1], diff_first_order,'r^')
    
    diff_two_order = x_obj.calc_diff(diff_first_order)
    #plot(x[:-2], diff_two_order,'bv')
    
    #"""
    roots_d_two = find_roots(diff_two_order)
    # Если меняется знак - первое корень

       
    #print roots_d_two  
    for at in roots_d_two:    
        plot(x[at], 0,'go')
        pass
     
    #
      
    # Находим параметы кривой производной
    k_tan_alpha = []
    x0 = []
    y0 = []
    for at in roots_d_two:
        k_tan_alpha.append(diff_first_order[at])
        x0.append(x[at])
        y0.append(y_smooth[at])
        
    print k_tan_alpha
    plot(x0, y0,'go')
    
     
    # Поиск Bi
    b = []
    for i in range(len(x0)):
        b.append(y0[i]-k_tan_alpha[i]*x0[i])
    print b
    for i in range(len(x0)):
        if k_tan_alpha[i] > 0:
            y = lin_line(x, k_tan_alpha[i], b[i])
            y, yes = cut_tangent(y)
            if yes:
                plot(x, y ,'b')#
        

if __name__=="__main__":
    #main()
    for at in range(1):
        plot_ht()
    grid(); show() 



