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
import signal_generator as generator



def e(v, x, y):
    """ Error function. Очень важная. """
    return (generator.real_relation(v,x)-y)



""""def main():
    # Plot
    def plot_fit(nun_points):
        print 'Estimater parameters: ', v
        print 'Real parameters: ', v_real
        x_precise = get_ox(nun_points)
        plot(x, y,'ro', x_precise, real_relation(v, x_precise))
    
    # Поучаем ось
    n = 50
    x = get_ox(n)
    
    # Параметры функции и начальная точка поиска
    v0 = [1.5, .1, 2.3]  # Initial parameter value
    v_real = [1.5, 0.1, 2.]  # Реальная наша функция
    #v0 = v_real  # TODO(you): взять поближеа
    
    # Зашупленная функция
    for i in range(10):
        sigma = 0.01
        noise = random.normal(0, sigma, size=n)
        y = real_relation(v_real, x)+noise
        v, success = leastsq(e, v0, args=(x,y), maxfev=10000)
        plot_fit(n*5)
    
    #
    show()"""
    
def decimate_ox(ox, metro_signal):
    result_x = []
    result_y = []
    for i in range(len(ox)): 
        if i%90 == 0:
            result_x.append(ox[i])
            result_y.append(metro_signal[i])
    return  result_x, result_y

  

def plot_ht():
    def lin_interpol_fan_curve(x, y):
        """ linear interp. air curve"""
        # Линейная
        f = interpolators.interp1d(x, y, kind='cubic')
    
        # Новая ось
        #generator.get_ox(num_points, minmax)
        xDataSrc = linspace(0, x[-1], num_points)
        yDataSrc = f(xDataSrc)
       
        return xDataSrc,  yDataSrc   
    """ """
    T1 = 15
    T2 = 20.0
    
    num_points = 1000
    sigma = 0.03
    minmax = [0, 100]
    
    # Begin()    
    main_x_axis = generator.get_ox(num_points, minmax)
    ht = generator.ht_2level(main_x_axis, T1, T2)
    plot(main_x_axis, ht, color='#000000', lw=4)
    noise = generator.get_gauss_noise(sigma, num_points)
    metro_signal = ht+noise  # Как бы померенный сигнал
    
    # Смотрим что вышло
    plot(main_x_axis, metro_signal,'b')

    
    # Нужно найти точку нулевого приближения
    # Выделим некотороые отсчеты
    decimated_x, decimated_y = decimate_ox(main_x_axis, metro_signal)
    plot(decimated_x, decimated_y,'rv')
    
    # Сгладить
    xDataSrc, yDataSrc = lin_interpol_fan_curve(decimated_x, decimated_y)  
    plot(xDataSrc, yDataSrc,'r')
    
    # Продиффиренцировать
    diff_first_order = diff(yDataSrc)
    #plot(xDataSrc[:-1], diff_first_order,'r^')
    
    diff_two_order = diff(diff_first_order)
    #plot(xDataSrc[:-2], diff_two_order,'bv')
    
    roots_d_two = []
    # Если меняется знак - первое корень
    for j in range(len(diff_two_order)):
        if j < len(diff_two_order)-1:
            mult_ = diff_two_order[j]*diff_two_order[j+1]*1e+12
            if mult_ < 0:
                roots_d_two.append(j)
       
    print roots_d_two  
    for at in roots_d_two:    
        plot(xDataSrc[at], 0,'go')
        
    # Находим параметы кривой производной
    k_tan_alpha = []
    x0 = []
    y0 = []
    for at in roots_d_two:
        k_tan_alpha.append(diff_first_order[at])
        x0.append(main_x_axis[at])
        y0.append(yDataSrc[at])
        
   #tanget_line =  k_tan_alpha*ox
    print k_tan_alpha
    plot(x0, y0,'go')
    

if __name__=="__main__":
    #main()
    for at in range(1):
        plot_ht()
    grid(); show() 



