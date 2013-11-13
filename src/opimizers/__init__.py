# coding: utf-8

# Other
from scipy.optimize import leastsq

def run_approximation(y, axis, v0, e):
    x = axis.get_axis()
    v, success = leastsq(e, v0, args=(x,y), maxfev=50000)
    return v