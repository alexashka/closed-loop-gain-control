import numpy as np
from scipy import signal
from numpy import exp

from pylab import *

b = np.array([1.0]) 
a = np.array([3.0, 1.0]) 
B, A = signal.bilinear(b, a) 
print B, A
#print 7*B, 7*A
