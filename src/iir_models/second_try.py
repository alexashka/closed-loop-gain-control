# coding: utf-8
'''
test_iir_filters

'''
# coding: utf8

from scipy import signal
from pylab import *
import numpy as np



def plot_AFC(t):
    y, x = 1/(1+(t)**2)**0.5
     
    x_dB = 20 * log10 (abs(x))
    x_dB = abs(x)
    subplot(211)
    plot(y, x_dB)
    print min(x_dB), max(x_dB)
    ylim(min(x_dB), max(x_dB))
    ylabel('Magnitude (db)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Frequency response')
    subplot(212)
    x_Phase = unwrap(arctan2(imag(x),real(x)))
    plot(y/max(y),x_Phase)
    grid()
    ylabel('Phase (radians)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Phase response')
    subplots_adjust(hspace=0.5)
    grid()
    show()

#run   
B = np.array([1.0]) 
A = np.array([3.0, 1.0]) 
t=0.01
# Ось должна быть e(-jwT)
 
plot_AFC(t)
