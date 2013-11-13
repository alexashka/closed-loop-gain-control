# coding: utf8
from pylab import plot
from pylab import show
from numpy import random
from scipy.optimize import leastsq

# App
import app
from dsp_modules.signal_generator import wrapper_for_finding_2l

def e(v, x, y):
    """ Error function. Очень важная. """
    return (wrapper_for_finding_2l(v,x)-y)


def curve_graph():  
    # Поучаем ось
    metro_signal, x_obj, x, real = app.get_metro_and_axis()
    n = x_obj.get_num_points()
    
    # Параметры функции и начальная точка поиска
    T1 = 0.007
    T2 = 0.02
    dt = 0.0
    v0 = [T1, T2, dt]  # Initial parameter value
    #v_real = [1.5, 0.1]  # Реальная наша функция
    #v0 = v_real  # TODO(you): взять поближе
    
    # Зашумленная функция
    y = metro_signal
    #plot(x, y,'b')
    #plot(x, wrapper_for_finding_2l(v0, x),'r')
    plot(x, real,'y')
    v, success = leastsq(e, v0, args=(x,y), maxfev=10000)
    #print v
    #plot(x, wrapper_for_finding_2l(v, x),'g')

    #
    show()
    return y, v[0], v[1]#, v[2]

if __name__=="__main__":
    curve_graph()
    pass


