# coding: utf8
from pylab import *
from numpy import *
from scipy.optimize import leastsq

# Parametric function: 'v' is the parameter vector, 
#    'x' the independent varible
def fp(v, x):
    return v[0]/(x**v[1])*sin(v[2]*x)  # Sinc(x)
    

## Noisy function (used to generate data to fit)
v_real = [1.5, 0.1, 2.]
def fn(x, v_real): 
    return fp(v_real, x)

## Error function
#e = lambda v, x, y:   # **2
def e(v, x, y):
    return (fp(v,x)-y)

## Generating noisy data to fit
n = 30
xmin = 0.1
xmax = 5
x = linspace(xmin,xmax,n)

# Зашупленная функция
y = fn(x, v_real)+rand(len(x))*0.2*(fn(x, v_real).max()-fn(x, v_real).min())

## Initial parameter value
v0 = [3., 1, 4.]


## Fitting
v, success = leastsq(e, v0, args=(x,y), maxfev=10000)

## Plot
def plot_fit():
    print 'Estimater parameters: ', v
    print 'Real parameters: ', v_real
    X = linspace(xmin,xmax,n*5)
    plot(x,y,'ro', X, fp(v,X))

plot_fit()
show()

if __name__=="__main__":
    pass


