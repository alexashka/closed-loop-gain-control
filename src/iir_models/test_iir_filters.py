'''
test_iir_filters

'''
# coding: utf8
from pylab import plot
from pylab import subplot
from pylab import show
from pylab import grid
from numpy import log
from numpy import ndarray
from numpy import arange
from numpy import arctan
from numpy import angle

def plot_AFC(w, T1):
    y = 1/(1+(w*T1)**2)**(0.5) 
    return y

def plot_PFC(w, T1):
    w = w*1j
    y = angle(1/(1+T1*w), deg=True) 
    return y
   # pass

def main():
    #run   
    T1 = .2
    K = 10
    x = arange(100)
    y1 = plot_AFC(x, T1)  
    subplot(2, 1, 1); plot(log(x), 10*log(y1*K)); grid()
    y2 = plot_PFC(x, T1)
    subplot(2, 1, 2); plot(log(x), y2); grid();
    show()  

 
if __name__ == "__main__":
    main()  
    