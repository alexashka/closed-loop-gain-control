# coding: utf-8

"""

Model:
    h = theta_0+theta_1 * x

X - matrix
x - vector

Local min:
http://book.caltech.edu/bookforum/showthread.php?p=10595
convex function

Danger:
 В NumPy операции с матрицами очень опасные - никакой защиты.
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
    y = y.T
    for i, elem in enumerate(X.T):
        elem = np.mat(elem).T
        h_i = theta.T * elem
        j += (h_i - y[i])**2
    j *= 1.0 / (2 * len(y))
    return j


def gradient_descent(X, y, theta, alpha, num_iterations):
    theta_local = numpy.zeros((1, 2)).T  # Превращаем в вектор
    m = len(y)
    y = y.T

    # 0
    h = np.mat(theta.T * X)
    dtheta0 = - alpha * 1/m * np.sum(h - y)
    print dtheta0

    # 1
    #dtheta1 = - alpha * 1/m * np.sum((h - np.mat(y).T) * )

    tmp0 = 0
    tmp1 = 0

    # atomic update


def main():
    # Похоже сортировка не нужна - или таки нужна?
    # J - Это сумма, поэтому скорее всего не важна
    data = load('mlclass-ex1/ex1data1.txt')
    x = data[:, :1]
    y = np.mat(data[:, 1:2]).T
    #plot_data(x, y)

    # Prepare data
    m = len(y.T)
    X = numpy.hstack([numpy.ones((m, 1)), x])
    X = X.T

    # Params - zero point
    theta = np.mat(numpy.zeros((1, 2))).T  # Превращаем в вектор

    # cost first iteration
    j = compute_cost(X, y, theta)  # just example

    # Iteration
    num_iterations = 1500
    alpha = 0.01

    # Find min
    gradient_descent(X, y, theta, alpha, num_iterations)

    # Plot data and estimated line

if __name__ == '__main__':
    main()

