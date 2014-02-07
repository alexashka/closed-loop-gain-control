# coding: utf-8

import numpy


def warm_up_exercise():
    return numpy.eye(5)


def load(filename):
    return numpy.genfromtxt(filename, delimiter=',')

if __name__ == '__main__':
    data = load('mlclass-ex1/ex1data1.txt')

