# coding: utf-8

"""

Model:
    h = theta_0+theta_1 * x

x_m - matrix
x - vector

Local min:
http://book.caltech.edu/bookforum/showthread.php?p=10595
convex function

Danger:
 В NumPy операции с матрицами очень опасные - никакой защиты.

Numpy:
http://wiki.scipy.org/NumPy_for_Matlab_Users
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


def compute_cost(m_x, y, theta):
    j = 0
    h = m_x * theta  # (AB)^T = B^T * A^T
    j = 1/(2.0 * m_x.shape[0]) * np.sum(np.square(h - y))
    return j


def gradient_descent(m_x, y, theta, alpha, num_iterations):
    theta_local = np.copy(theta)
    m = m_x.shape[0]

    # 0
    h = (theta.T * m_x.T).T
    dtheta0 = - alpha * 1/m * np.sum(h - y)

    # 1
    x = m_x[:, 1]
    dtheta1 = - alpha * 1/m * np.sum(np.multiply((h - y), x))

    # May iterate

    tmp0 = 0
    tmp1 = 0

    # atomic update


def main():
    # Похоже сортировка не нужна - или таки нужна?
    # J - Это сумма, поэтому скорее всего не важна
    #
    # Извлекаем два !вектора! входных данных
    data = load('mlclass-ex1/ex1data1.txt')
    x = np.mat(data[:, :1])
    y = np.mat(data[:, 1:2])
    #plot_data(x, y)

    # Prepare data
    m = len(y)
    m_x = numpy.hstack([numpy.ones((m, 1)), x])

    # Params - zero point
    theta = np.mat(numpy.zeros((1, 2))).T  # Превращаем в !вектор

    # cost first iteration
    j = compute_cost(m_x, y, theta)  # just example

    # Iteration
    num_iterations = 1500
    alpha = 0.01

    # Find min
    gradient_descent(m_x, y, theta, alpha, num_iterations)

    # Plot data and estimated line

if __name__ == '__main__':
    main()

