# coding: utf8
from pylab import plot
from pylab import show
from pylab import grid
from numpy import random
from scipy.optimize import leastsq

# App
from dsp_modules.signal_generator import wrapper_for_finding_2l
from dsp_modules.signal_templates import get_metro_and_axis

def e(v, x, y):
    """ Error function. Очень важная. """
    return (wrapper_for_finding_2l(v,x)-y)

def run_approximation(metro_signal, axis, v0):
    x = axis.get_axis()
    n = axis.get_num_points()
    
    # Параметры функции и начальная точка поиска
    
    #v_real = [1.5, 0.1]  # Реальная наша функция
    #v0 = v_real  # TODO(you): взять поближеа
    
    # Зашумленная функция
    y = metro_signal
    v, success = leastsq(e, v0, args=(x,y), maxfev=10000)
    print v

def main():  
    # Поучаем ось
    metro_signal, axis, ideal = get_metro_and_axis()
    T1 = 7
    T2 = 20.0
    v0 = [T1, T2]  # Initial parameter value
    run_approximation(metro_signal, axis, v0)
    
    # Plotting
    plot(x, y,'b')
    #plot(x, wrapper_for_finding_2l(v0, x),'r')
    plot(x, ideal,'y')
    plot(x, wrapper_for_finding_2l(v, x),'g')

    #
    show(); grid()

if __name__=="__main__":
    main()
    pass


