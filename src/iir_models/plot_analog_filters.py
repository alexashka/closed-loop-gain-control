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
    y = 1/(1+w*T1)
    y = real(conj(y)*y)**0.5
    return y

def plot_PFC(w, T1):
    h = 1/(1+T1*w)
    y = angle(h, deg=True) 
    return y

def main(T1, K, w):
    # Abs
    y1 = plot_AFC(w, T1)  
    subplot(2, 1, 1); 
    plot(imag(w), y1); grid()
    
    # Angle
    y2 = plot_PFC(w, T1)
    subplot(2, 1, 2); plot(imag(w), y2); 
    grid();
    show()  

if __name__ == "__main__":
    F = arange(1000) # Hz 
    w = 2*pi*F  
    w_complex = 1j*w
    T1 = .001
    K = 1
    main(T1, K, w_complex)
    
    
    
    
    