# coding: utf8
from numpy import array
from numpy import zeros
from numpy import ones
from numpy import roll

from visualisers  import impz

class FSMBaseIIR(object):
    a_ = None
    b_ = None
    x_line_ = None
    y_line_ = None
   
    
    def rst(self):
        pass
    
    def __init__(self, b, a):  # Конструктор
        """ 
        Precond.:
            a[0] = 1
        """

        self.b_ = b
        self.a_ = a[1:]  # Выход сумматроа не умножается ни на что!
        
        self.x_line_ = zeros(len(b)-1)
        self.y_line_ = zeros(len(self.a_))

    
    def calc_response_(self, x):
        # FIR-part
        summ_line = 0
        for i in range(len(self.x_line_)):
            # Первый коэфф. возьмем отбельно
            summ_line += self.b_[i+1]*self.x_line_[i]
        
        # Умножаем и прибавляем отсчет входного сигнала
        summ_line += self.b_[0]*x
        
        # IIR-part
        for j in range(len(self.a_)):
            summ_line -= self.a_[j]*self.y_line_[j]

        return summ_line
        
    def clk(self, x):
        y = self.calc_response_(x)
        self.shift_lines_(x, y)
        return y
        
    def shift_lines_(self, x, y):
        self.x_line_ = roll(self.x_line_, 1)
        self.x_line_[0] = x
        
        
        self.y_line_ = roll(self.y_line_, 1)
        self.y_line_[0] = y


if __name__=="__main__":
    b = [0.00694444,  0.01388889,  0.00694444]
    a = [1., -1.33333333,  0.44444444]
    
    x_signal = ones(50)
    x_signal[0] = 0
    iir_model = FSMBaseIIR(b, a)
    response = []
    for it in x_signal:
        response.append(iir_model.clk(it))
        
    from pylab import *
    plot(range(len(response)), response, 'o')
    grid()
    show()
    
    print 'Done'
    