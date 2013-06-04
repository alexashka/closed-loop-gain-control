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
    
def plot_normalize_analog(params, af_action, freq_axis, freq_sampling):
    (h, phi) = calc_analog_filter_curves(params, freq_axis, af_action)
    
    # Abs
    y_dB = to_dB(h)
    subplot(2, 1, 1)
    ylabel('K, 20*log(...)')
    xlabel('Norm. freq. f/fs')
    grid()   
    axis = freq_axis/freq_sampling#imag(w_complex)
    plot(axis, y_dB)
    xlim(0, 0.5)
    
    # Angle
    subplot(2, 1, 2)
    grid()
    ylabel('Phase, deg')
    xlabel('Norm. freq. f/fs')
    plot(axis, phi)
    xlim(0, 0.5)
    return h, phi

def calc_analog_filter_curves(params, freq_axis, af_action):
    w_complex = 1j*2*pi*freq_axis 
    h, phi = calc_afc(w_complex, params, af_action), calc_pfc(w_complex, params, af_action)
    return (h, phi)

def calc_afc(w, params, af_action):
    y = af_action(w, params)
    y = real(conj(y)*y)**0.5
    return y

def calc_pfc(w, params, af_action):
    h = af_action(w, params)
    y = angle(h, deg=True) 
    return y
    