 
from pylab import *
def to_dB(value):
     h_dB = 20 * log10 (abs(value))
     return h_dB