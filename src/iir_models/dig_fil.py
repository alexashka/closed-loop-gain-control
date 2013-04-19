# coding: utf-8

"""

Характеристики для цифрового фильтра

"""
import numpy as np
from scipy import signal
from numpy import exp

from pylab import *


def mfreqz(b,a):
    w, h = signal.freqz(b,a)
    
    h_dB = 20 * log10 (abs(h))
    h_dB = abs(h)
    subplot(211)
    plot(w, h_dB)
    print min(h_dB), max(h_dB)
    ylim(min(h_dB), max(h_dB))
    ylabel('Magnitude (db)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Frequency response')
    subplot(212)
    h_Phase = unwrap(arctan2(imag(h),real(h)))
    plot(w/max(w),h_Phase)
    grid()
    ylabel('Phase (radians)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Phase response')
    subplots_adjust(hspace=0.5)
    grid()
    show()
    
"""def impz(b,a=1):
    impulse = repeat(0.,50); impulse[0] =1.
    x = arange(0,50)
    response = signal.lfilter(b,a,impulse)
    subplot(211)
    stem(x, response)
    ylabel('Amplitude')
    xlabel(r'n (samples)')
    title(r'Impulse response')
    subplot(212)
    step = cumsum(response)
    stem(x, step)
    ylabel('Amplitude')
    xlabel(r'n (samples)')
    title(r'Step response')
    subplots_adjust(hspace=0.5)
    show()"""


"""Fd = 440.0
T1 = 0.005
a1 = -exp(-1/T1/Fd)
print a1"""

#a = [1.0, a1]
#b = [1.0*(1+a1)]

B = np.array([1.0]) 
A = np.array([3.0, 1.0]) 
b, a = signal.bilinear(B, A)

#impz(b, a)
mfreqz(b, a)


    
