# coding: utf8

from pylab import *
from numpy import *
from scipy.optimize import leastsq
#import synteser_fir as generator

def real_relation(v, x):
    """ Известная зависимость 
    
    Args: 
        Параметры кривой
        Ось Ox
    
    Returns:
        Массив отсчетов y = real_relation(v, x)
    """
    y = v[0]*x+v[1]
    return  y 

def e(v, x, y):
    """ Error function. Очень важная. """
    return (real_relation(v,x)-y)

def get_ox(scale, num_points):
    n = num_points
    xmin = scale[0]
    xmax = scale[1]
    x = linspace(xmin,xmax,n)
    return x

def main():
    # Plot
    
    # Поучаем ось
    scale = [0, 9]
    n = 10
    x = get_ox(scale, n)
    print x
    
    x = arange(n)  # raw Ox
    dx = 1/2.0
    x_axis = x*dx
    
    
    k = 2
    b = -2
    y = k*x_axis+b
    plot(x_axis, y,'ro')

    
    diff_first_order = diff(y, 1)
    print "Difference" , diff_first_order/dx
    
    #
    grid(); show() 

if __name__=="__main__":
    main()
    pass
