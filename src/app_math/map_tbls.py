from numpy import log
from numpy import ndarray
from numpy import arange

from pylab import plot
from pylab import show
from pylab import grid

print log(2.7)

def f1d(d):
    y = d**(1/(1-d))*(log(d)/(d-1)+(1+d)/d)-1
    return y
    
# Run
x = arange(100)/100.0
x = x[2:]
y = f1d(x)

plot(x, y); grid(); show()
