# coding: utf8
from pylab import *
from numpy import *
from scipy.optimize import leastsq

def get_ox(num_points, minmax):
    """ Генератор осей Ох """
    xmin = minmax[0]
    xmax = minmax[1]
    x = linspace(xmin, xmax, num_points)
    return x

def wrapper_for_finding_2l(v, x):
    return ht_2level(x, v[0], v[1])
    
def ht_2level(t, T1, T2):
    d = T1/T2
    return 1+d/(1-d)*exp(-t/T1)-1/(1-d)*exp(-t/T2)
    
def get_gauss_noise(sigma, num_points):
    """ Белый гауссовский центрированный шум с заданной сигмой."""
    noise = random.normal(0, sigma, size=num_points)
    return noise

def real_relation(v, x):
    """ Известная зависимость 
    
    Args: 
        Параметры кривой
        Ось Ox
    
    Returns:
        Массив отсчетов y = real_relation(v, x)
    """
    y = v[0]*v[1]*sin(v[2]*x)
    return  y 
    
if __name__=="__main__":
    #main()
    #plot_ht()
    pass


