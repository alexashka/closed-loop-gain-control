# coding: utf-8

"""

Model:
    h = theta_0+theta_1 * x

X - matrix
x - vector
"""

import numpy
import pylab

import numpy as np


def warm_up_exercise():
    return numpy.eye(5)


def load(filename):
    tmp = numpy.genfromtxt(filename, delimiter=',')
    return tmp


def plot_data(x, y):
    pylab.plot(x, y, '+')
    pylab.show()


def compute_cost(X, y, theta):
    j = 0
    for i, elem in enumerate(X):
        elem = np.mat(elem).T
        h_i = np.mat(theta).T * elem
        j += (h_i - y[i])**2
    j *= 1.0 / (2 * len(y))
    return j


def main():
    data = load('mlclass-ex1/ex1data1.txt')
    x = data[:, :1]
    y = data[:, 1:2]
    #plot_data(x, y)

    # Prepare data
    m = len(y)
    X = numpy.hstack([numpy.ones((m, 1)), x])

    # Params - zero point
    theta = numpy.zeros((1, 2)).T  # Превращаем в вектор

    # cost first iteration
    j = compute_cost(X, y, theta)

    # Iteration
    iterations = 1500
    alpha = 0.01

if __name__ == '__main__':
    main()

