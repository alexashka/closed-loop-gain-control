# coding: utf8
from numpy import random
from numpy import exp
from numpy import sin
from numpy import arange
from scipy.optimize import leastsq

def ht_2level_del_full(t, T1, T2, dt=0.0, k=1.0, dy=0.0):
    k *= 1.0
    dt *= 1.0
    d = T1/T2
    y = (1+d/(1-d)*exp(-(t-dt)/T1)-1/(1-d)*exp(-(t-dt)/T2))
    ptr = 0
    while True:
        if t[ptr]-dt > 0.0:
            break
        y[ptr] = 0
        ptr += 1
    return y*k+dy

    
def wrapper_for_finding_2l(v, x):
    return ht_2level(x, v[0], v[1])

def wrapper_for_finding_2l_del(v, x):
    return ht_2level_del_full(x, v[0], v[1], v[2])

def wrapper_for_finding_2l_del_full(v, x):
    return ht_2level_del_full(x, v[0], v[1], v[2], v[3], v[4])

    
def ht_2level(t, T1, T2, dt=0):
    d = T1/T2
    return 1+d/(1-d)*exp(-t/T1)-1/(1-d)*exp(-t/T2)

def ht_2level_del(t, T1, T2, dt=0.0):
    dt *= 1.0
    d = T1/T2
    y = 1+d/(1-d)*exp(-(t-dt)/T1)-1/(1-d)*exp(-(t-dt)/T2)
    ptr = 0
    while True:
        if t[ptr]-dt > 0.0:
            break
        y[ptr] = 0
        ptr += 1
        
    return y



    
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

def get_axis(Fs, num_points):
    Fs *= 1.0
    x = arange(0,num_points)
    return x*1.0/Fs

""" Функыии ошибок для оптимизации """
def e(v, x, y):
    """ Error function. Очень важная. """
    return (wrapper_for_finding_2l(v,x)-y)

def e_del(v, x, y):
    return (wrapper_for_finding_2l_del(v, x)-y)

def e_del_full(v, x, y):
    return (wrapper_for_finding_2l_del_full(v, x)-y)
    
if __name__=="__main__":
    #main()
    #plot_ht()
    print 'Done'
    pass


