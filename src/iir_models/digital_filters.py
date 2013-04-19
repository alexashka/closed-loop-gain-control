# coding: utf-8

"""

Характеристики для цифрового фильтра

"""

# Other
import numpy as np
from scipy import signal

# App
from visualisers import mfreqz
from visualisers import impz

# Runner
if __name__=='__main__':
    b_analog = np.array([1.0]) 
    a_analog = np.array([3.0, 1.0]) 
    b, a = signal.bilinear(b_analog, a_analog)
    
    impz(b, a)
    mfreqz(b, a)


    
