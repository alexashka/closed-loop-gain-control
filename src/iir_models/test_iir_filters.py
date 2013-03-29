# coding: utf-8
'''
test_iir_filters

'''
# coding: utf8
from pylab import plot
from pylab import subplot
from pylab import show
from pylab import grid
from numpy import log
from numpy import ndarray
from numpy import arange
from numpy import arctan

from numpy import angle
from numpy import conj
from numpy import real
from numpy import imag
from numpy import exp
from numpy import pi

def plot_AFC(w, T1):
    y = 1/(1+w*T1)
    y = 1/(1+w*T1)
    y = real(conj(y)*y)**0.5
    return y

def plot_PFC(w, T1):
    y = angle(1/(1+T1*w), deg=True) 
    #y = angle((w), deg=True)
    return y
   # pass

def main(w, w_full):
    #run   
    T1 = .01
    K = 1#0
    x = w
    y1 = plot_AFC(x, T1)  
    subplot(2, 1, 1); plot(imag(w_full)/2/pi, y1*K); grid()
    y2 = plot_PFC(x, T1)
    subplot(2, 1, 2); plot(imag(w_full)/2/pi, y2); grid();
    show()  

# Ось должна быть e(-jwT)
 
if __name__ == "__main__":
    F = arange(1000)
    w = 2*pi*F
    Fs = 500.0  # Hz
    T = 1/(Fs)
    
    z = exp(-1j*w*T)
    print z
    main(z, w*1j)  
    
   # a = 1+1j
    #print real(conj(a)*a)**0.5
    