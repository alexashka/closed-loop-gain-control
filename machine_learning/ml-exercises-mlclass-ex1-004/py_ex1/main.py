# coding: utf-8

"""

Model:
    h = theta_0+theta_1 * x

"""

import numpy
import pylab


def warm_up_exercise():
    return numpy.eye(5)


def load(filename):
    tmp = numpy.genfromtxt(filename, delimiter=',')
    return tmp


def plot_data(x, y):
    pylab.plot(x, y, '+')
    pylab.show()


def main():
    data = load('mlclass-ex1/ex1data1.txt')
    x = data[:, :1]
    y = data[:, 1:2]
    #plot_data(x, y)

    m = len(y)

    x = numpy.hstack([numpy.ones((m, 1)), x])
    print x

if __name__ == '__main__':
    main()

