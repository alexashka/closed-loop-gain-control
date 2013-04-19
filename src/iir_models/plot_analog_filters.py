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

def run(tau, freq, freq_sampling):
    freq_sampling = float(freq_sampling)
    w = 2*pi*freq  
    w_complex = 1j*w
    
    # Abs
    y1 = plot_AFC(w_complex, tau)  
    subplot(2, 1, 1); 
    plot(imag(w_complex)/freq_sampling, y1); grid()
    
    # Angle
    y2 = plot_PFC(w_complex, tau)
    subplot(2, 1, 2); plot(imag(w_complex)/freq_sampling, y2); 
    
    grid()
    show()  

if __name__ == "__main__":
    freq = arange(1000) # Hz 
    tau = .01
    freq_sampling = 500  # Hz

    run(tau, freq, freq_sampling)
    
    
    
    
    