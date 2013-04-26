# coding: utf8
from numpy import array
from numpy import zeros
from numpy import ones

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
        
        print "Constr"
        self.b_ = b
        self.a_ = a[1:]  # Выход сумматроа не умножается ни на что!
        
        self.x_line_ = ones(len(b)-1)
        self.y_line_ = ones(len(self.a_))
        
        print self.x_line_
    
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

        print summ_line


if __name__=="__main__":
    b = [0.00694444,  0.01388889,  0.00694444]
    a = [1., -1.33333333,  0.44444444]
    
    
    # Fake
    #b = [1,1,1,1,2]
    #a = [1, 1, 1]
    
    x_signal = array([1,0,0,0,0,0,0,0])
    iir_model = FSMBaseIIR(b, a)
    iir_model.calc_response_(x_signal[0])
    
    print 'Done'
    