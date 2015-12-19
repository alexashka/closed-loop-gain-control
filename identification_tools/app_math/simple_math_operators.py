# coding: utf8

from pylab import plot
from pylab import show
from pylab import grid
import numpy

class XAxis(object):
    _dx = None
    _axis = None
    _num_points = None
    def __init__(self, num_points, dx):
        self._dx = dx
        self._axis = numpy.arange(num_points)*self._dx
        self._num_points = num_points
        
    def get_dx(self):
        return self._dx
    
    def get_axis(self):
        return self._axis
    
    def calc_diff(self, y):
        return numpy.diff(y, 1)/self.get_dx()
    
    def get_num_points(self):
        return self._num_points
    
    
def main():
    # Plot
    
    # Поучаем ось
    n = 10
    dx = 0.1
    x_axis = XAxis(n, dx)
    x = x_axis.get_axis()
 
    k = 2
    b = -2
    y = k*x**2+b
    plot(x, y,'ro')
    
    print "Difference" , x_axis.calc_diff(y)
    
    #
    grid(); show() 

if __name__=="__main__":
    main()
    pass
