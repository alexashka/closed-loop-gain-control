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


def compute_cost(x, y, theta):
    j = 0
    for i, elem in enumerate(x):
        h_i = numpy.sum(elem*theta)
        j += (h_i - y[i])**2
    j *= 1.0 / (2 * len(x))
    return j


def main():
    data = load('mlclass-ex1/ex1data1.txt')
    x = data[:, :1]
    y = data[:, 1:2]
    #plot_data(x, y)
    m = len(y)
    x = numpy.hstack([numpy.ones((m, 1)), x])
    theta = numpy.zeros((1, 2))

    #
    j = compute_cost(x, y, theta)

    #
    iterations = 1500;
    alpha = 0.01

if __name__ == '__main__':
    main()

