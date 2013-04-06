# coding: utf-8
'''
test_iir_filters

'''
# coding: utf8
from pylab import plot
from pylab import subplot
from pylab import show
from pylab import grid

from numpy import ndarray
from numpy import arange
from numpy import angle
from numpy import conj
from numpy import real
from numpy import imag
from numpy import exp
from numpy import pi

def plot_AFC(w, T1):
      y = 
    return y

def plot_PFC(w, T1):
    y = angle(1/(1+T1*w), deg=True) 
    #y = angle((w), deg=True)
    return y
    # pass

#run   
T1 = .01
K = 1#0
x = arange(100)/100.0
y1 = plot_AFC(x, T1)  
subplot(2, 1, 1); plot(x, y1); grid()
y2 = plot_PFC(x, T1)
subplot(2, 1, 2); plot(x, y2); grid()
show()  

# Ось должна быть e(-jwT)
 

