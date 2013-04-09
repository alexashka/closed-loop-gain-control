# coding: utf-8

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

T = 1

from pylab import *
import scipy.signal as signal
b,a = signal.iirdesign(wp = [0.05, 0.3], ws= [0.02, 0.35], gstop= 60, gpass=1, ftype='ellip')


def mfreqz(b,a=1):
    w,h = signal.freqz(b,a)
    h_dB = 20 * log10 (abs(h))
    subplot(211)
    plot(w/max(w),h_dB)
    ylim(-150, 5)
    ylabel('Magnitude (db)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Frequency response')
    subplot(212)
    h_Phase = unwrap(arctan2(imag(h),real(h)))
    plot(w/max(w),h_Phase)
    ylabel('Phase (radians)')
    xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    title(r'Phase response')
    subplots_adjust(hspace=0.5)
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
    
print b, a
b = [1]
a = [1, -1]
mfreqz(b, a)

"""
def h(z):
    y = z+1/(z-0.7071)
    return y

s = arange(1000)/100.0
y = h(exp(1j*s*T))

plot(s*T/pi, (conj(y)*y))
show()"""
    