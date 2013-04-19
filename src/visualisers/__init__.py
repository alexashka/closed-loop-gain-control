import numpy as np
from scipy import signal
from numpy import exp
from pylab import *

# App
from app_math import to_dB



def mfreqz(b,a):
    w, h = signal.freqz(b,a, worN=1000, whole=False)

    h_dB = to_dB(h)
    
    # Plot
    subplot(211)
    plot(w, h_dB)
    ylim(min(h_dB), max(h_dB))
    xlim(0, max(w))
    ylabel('Magnitude (db)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Frequency response')
    
    # Plot
    subplot(212)
    h_Phase = unwrap(arctan2(imag(h),real(h)))
    plot(w,h_Phase)
    grid()
    xlim(0, max(w))
    ylabel('Phase (radians)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Phase response')
    subplots_adjust(hspace=0.5)
    grid()
    
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
    
def plot_normalize_analog(coeff_tuple, freq, freq_sampling, afc_cb, pfc_cb):

    freq_sampling = float(freq_sampling)
    w = 2*pi*freq  
    w_complex = 1j*w
    
    # Abs
    y1 = afc_cb(w_complex, coeff_tuple)
    y_dB = to_dB(y1)
    subplot(2, 1, 1); 
    plot(imag(w_complex)/freq_sampling, y_dB); grid()
    xlim(0, pi)
    
    # Angle
    y2 = pfc_cb(w_complex, coeff_tuple)
    subplot(2, 1, 2); plot(imag(w_complex)/freq_sampling, y2); 
    xlim(0, pi)
    grid()
    