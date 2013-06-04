import numpy as np
from scipy import signal
from numpy import exp
from pylab import *

# App
from app_math import to_dB



def mfreqz(b,a):
    w, h = signal.freqz(b,a, worN=1000, whole=False)
    _plotter_angle_and_abs(h, w)

def mfreqz_2():
    pass
   
    
def _plotter_angle_and_abs(h, w):
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
    
def plot_normalize_analog(settings, af_cb, freq_axis, freq_sampling):
    freq_sampling = float(freq_sampling)
    w = 2*pi*freq_axis  
    w_complex = 1j*w
    
    # Abs
    h = _plot_AFC(w_complex, settings, af_cb)
    y_dB = to_dB(h)
    subplot(2, 1, 1)
    ylabel('K, 20*log(...)')
    xlabel('Norm. freq. f/fs')
    grid()   
    axis = freq_axis/freq_sampling#imag(w_complex)
    plot(axis, y_dB)
    xlim(0, freq_sampling/freq_sampling*0.5)
    
    # Angle
    phi = _plot_PFC(w_complex, settings, af_cb)
    subplot(2, 1, 2)
    grid()
    ylabel('Phase, deg')
    xlabel('Norm. freq. f/fs')
    plot(axis, phi)
    xlim(0, freq_sampling/freq_sampling*0.5)
    return h, phi

def _plot_AFC(w, settings, af_cb):
    y = af_cb(w, settings)
    y = real(conj(y)*y)**0.5
    return y

def _plot_PFC(w, settings, af_cb):
    h = af_cb(w, settings)
    y = angle(h, deg=True) 
    return y
    