import numpy as np
from scipy import signal
from numpy import exp
from pylab import *

def mfreqz(b,a):
    w, h = signal.freqz(b,a)
    h_dB = 20 * log10 (abs(h))
    h_dB = abs(h)
    
    # Plot
    subplot(211)
    plot(w, h_dB)
    print min(h_dB), max(h_dB)
    ylim(min(h_dB), max(h_dB))
    ylabel('Magnitude (db)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Frequency response')
    
    # Plot
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
    
def impz(b,a=1):
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
    show()
    
    
def plot_normalize_analog(T1, w_complex, Fs):
    
    pass
    