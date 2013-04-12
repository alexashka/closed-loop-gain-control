# coding: utf-8

"""

Характеристики для цифрового фильтра

"""
import numpy as np
from scipy import signal
from numpy import exp

from pylab import *
""""h, w = signal.freqz(a,b)

import matplotlib.pyplot as plt
fig = plt.figure()
plt.title('Digital filter frequency response')
ax1 = fig.add_subplot(111)

plt.semilogy(w, np.abs(h), 'b')
plt.ylabel('Amplitude (dB)', color='b')
plt.xlabel('Frequency (rad/sample)')
plt.grid()
plt.legend()

ax2 = ax1.twinx()
angles = np.unwrap(np.angle(h))
plt.plot(w, angles, 'g')
plt.ylabel('Angle (radians)', color='g')
plt.show()"""

def mfreqz(b,a):
    w, h = signal.freqz(b,a)
    
    #plot(w, abs(h))
    
    #print w, h
    
    #print h, w
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

#a = exp(-0.0039)
Fd = 440.0
T1 = 0.01
a1 = -exp(-1/T1/Fd)
print a1


#print a
a = [1.0, a1]
b = [1.0*(1+a1)]

impz(b, a)
mfreqz(b, a)

'''
h, w = signal.freqz(b,a)

import matplotlib.pyplot as plt
fig = plt.figure()
plt.title('Digital filter frequency response')
ax1 = fig.add_subplot(111)

#plt.semilogy(w, np.abs(h), 'b')
plt.plot(w, np.abs(h), 'b')
plt.ylabel('Amplitude (dB)', color='b')
plt.xlabel('Frequency (rad/sample)')
plt.grid()
plt.legend()

ax2 = ax1.twinx()
angles = np.unwrap(np.angle(h))
plt.plot(w, angles, 'g')
plt.ylabel('Angle (radians)', color='g')
plt.show()'''




    
