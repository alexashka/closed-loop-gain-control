# coding: utf8
from pylab import *
from numpy import *
from scipy.optimize import leastsq

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

def e(v, x, y):
    """ Error function. Очень важная. """
    return (real_relation(v,x)-y)

def get_ox(num_points):
    n = num_points
    xmin = 0.5
    xmax = 100
    x = linspace(xmin,xmax,n)
    return x

def main():
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
    show()

def plot_ht():
    """ """
    T1 = 10
    T2 = 20.0
    d = T1/T2
    def h(t):
        return 1+d/(1-d)*exp(-t/T1)-1/(1-d)*exp(-t/T2)
    
    num_points = 1000
    ox = get_ox(num_points)
    ht = h(ox)
    sigma = 0.05
    noise = random.normal(0, sigma, size=num_points)
    plot(ox, ht+noise,'b')
    grid()
    show()
    
    # Нужно найти точку нулевого приближения

if __name__=="__main__":
    #main()
    plot_ht()


