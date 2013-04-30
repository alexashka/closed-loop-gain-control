# coding: utf8

#from pylab import plot
#from pylab import show
import dsp_modules.signal_generator as gen

import uasio.os_io.io_wrapper as dal

if __name__=='__main__':
    # Задаем начальные параметры
    num_column_in_rpt = 20;
    rpt = []
    Fs = 1.0  # Hz
    count_metro = 10
    sigma = 0.05
    num_points = num_column_in_rpt
    
    # Рассчитываем незашумленную кривую
    
    # Для каждого из опытов
    sum = ''
    first_line_rpt = ''
    for i in range(num_points+1):
            sum += str(i)+' , '
    print sum
    rpt.append(sum)   
        
        
    for idx in range(count_metro):
        one_line_rpt = ''
        
        # Generate noize
        y = gen.get_gauss_noise(sigma, num_points)
        
        acum = ''
        for sample in y:
            tmp = int(sample*1000)/1000.0
            acum += str(tmp)+', '
        
        one_line_rpt += str(idx+1)+' , '+acum
        #print idx
        # Зашумляем одну
        
        # Пишем в отчет *.csv 
        # 1, 2, 8
        # 3, 8, ...
        rpt.append(one_line_rpt)
     
     
    def printer(msg):
        print msg
    map(printer, rpt)
    
    sets = {}
    #dal.
    sets['name'] = 'source_rpt.csv'
    sets['howOpen'] = 'w'
    sets['coding'] = 'utf8'
    dal.list2file(sets, rpt)
        
    
    print 'Done'
