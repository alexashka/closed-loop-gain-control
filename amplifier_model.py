# coding: utf8

# Other
from pylab import *
from numpy import *
from scipy.optimize import leastsq

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

def plot_ht():
    """ """
    T1 = 15
    T2 = 20.0
    
    num_points = 1000
    sigma = 0.03
    minmax = [0, 100]
    
    # Begin()    
    ox = generator.get_ox(num_points, minmax)
    ht = generator.ht_2level(ox, T1, T2)
    noise = generator.get_gauss_noise(sigma, num_points)
    metro_signal = ht+noise  # Как бы померенный сигнал
    
    # Смотрим что вышло
    plot(ox, metro_signal,'b')

    
    # Нужно найти точку нулевого приближения
    # Выделим некотороые отсчеты
    def decimate_ox(ox, metro_signal):
        result_x = []
        result_y = []
        for i in range(len(ox)): 
            if i%100 == 0:
                result_x.append(ox[i])
                result_y.append(metro_signal[i])
        return  result_x, result_y  
    
    decimated_x, decimated_y = decimate_ox(ox, metro_signal)
    plot(decimated_x, decimated_y,'rv')
    grid()
    show()      

if __name__=="__main__":
    #main()
    plot_ht()


