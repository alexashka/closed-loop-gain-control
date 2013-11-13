'''
Created on 13.06.2013

@author: 29613
'''
# coding: utf8

from pylab import exp
from pylab import ylabel
from pylab import show
from pylab import grid
from numpy import angle
from numpy import inf

def main():
    w = 100000000000000
    D1 = angle(((5.3226*1j*w)+1)*(3.0763*1j*w+1)+(2.1469*exp(-1j*0.8889*w)))
    D2 = angle(((5.3226*1j*w)+1)*(3.0763*1j*w+1))
    if ((D1-D2) > 0) or ((D1-D2) < 0):
        print "find other system"
    print    "stability"
    
     
 
if __name__=="__main__":
    main()
    print "Done"   

