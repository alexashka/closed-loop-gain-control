# coding: utf-8

import numpy
from numpy import matrix


def warm_up_exercise():
    return numpy.eye(5)


def load(filename):
    tmp = numpy.genfromtxt(filename, delimiter=',')
    tmp = numpy.matrix.transpose(tmp)
    return tmp

if __name__ == '__main__':
    data = load('mlclass-ex1/ex1data1.txt')
    print data[:1]

