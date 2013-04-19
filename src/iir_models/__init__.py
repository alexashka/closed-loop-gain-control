from numpy import angle
from numpy import conj
from numpy import real

def plot_AFC(w, T1):
    y = 1/(1+w*T1)
    y = real(conj(y)*y)**0.5
    return y

def plot_PFC(w, T1):
    h = 1/(1+T1*w)
    y = angle(h, deg=True) 
    return y