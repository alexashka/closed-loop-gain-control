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

from numpy import imag
from numpy import exp
from numpy import pi

# App
from iir_models import plot_AFC
from iir_models import plot_PFC


def run(T1, w):
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
    #K = 1
    run(T1, w_complex)
    
    
    
    
    