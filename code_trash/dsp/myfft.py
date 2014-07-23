import math
import cmath
import scipy
import matplotlib
import matplotlib.pyplot as plt
a = scipy.array([[1,2,3,4,5,6]])
b = scipy.array([[1,2,3,4,5,6]])
s = scipy.fft(a)
print a
print s
#s = cmath.real(s)
print s

#fig = plt.figure()
#ax = fig.add_subplot( 111)
#ax.plot(a, b)
#fig.show()
#fig.savefig('symlog')