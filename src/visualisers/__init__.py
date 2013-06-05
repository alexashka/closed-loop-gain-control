# coding: utf-8
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
    
def plot_normalize_analog(h, phi, freq_axis, freq_sampling, cut_position):
    # Abs
    y_dB = to_dB(h)
    subplot(2, 1, 1)
    ylabel('20*log(K)')
    xlabel('F, Hz')
    grid()   
    axis = freq_axis
    plot(axis, y_dB)
    plot(freq_axis[cut_position], y_dB[cut_position], 'o')
    xlim(0, freq_sampling/2)
    
    # Angle
    subplot(2, 1, 2)
    grid()
    ylabel('Phase, deg')
    xlabel('F, Hz')
    plot(axis, phi)
    plot(freq_axis[cut_position], phi[cut_position], 'o')
    xlim(0, freq_sampling/2)
    
def calc_half_fs_axis(total_points, fs):
    """ Геренирует ось до половины частоты дискр. с числом
    точек равным заданному
    """
    freq_axis = arange(total_points)*fs/2/total_points # Hz до половины fs
    return freq_axis
    
