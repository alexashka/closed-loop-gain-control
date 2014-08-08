# coding: utf8

# Sys

# Libs
from numpy import arange

# App
from opimizers.finder import curve_graph 
from app_plot_analog_filters import analog_filter_plot
from app_digital_filters import calc_digital_characteristics

if __name__=="__main__":
    """ Settings project """
    fs_work_iir = 5.0  # Hz
    
    """0. Получаем кривые, уровень сигнала по окончанию переходных процессов
    нормирован.
        
    """
    # curves = get_curves()

    
    no_mean_result = {}
    no_mean_result['b1'] = []
    no_mean_result['b2'] = []
    no_mean_result['a1'] = []
    no_mean_result['a2'] = []
    no_mean_result['k'] = []
    no_mean_result['fs_work_iir'] = []
    
    i = 0
    for curve in range(5):#curves:
    #if True:    
        """1. Восстановление переходных характеристик из таблицы
         данных и нахожение постоянных времени T1 и T2"""
        
        #y, T1, T2 = curve_graph()
        T1 = i+1
        T2 = i+2
        print "T1 = ", T1, "T2 = ", T2
        
        
        """ 2. Отобр. хар. полученного аналогового фильтра """
        #analog_filter_plot()
        
        """ 3. Переход от аналогового фильтра к цифровому.
               Построение характерисчтик цифрового фильтра. 
        """
        b1, a1, fake = calc_digital_characteristics(T1, fs_work_iir)
        b2, a2, fake = calc_digital_characteristics(T2, fs_work_iir)
        print b1, a1
        print b2, a2
        
        # Собираем результаты для усреднения
        #print i
        no_mean_result['b1'].append(b1)
        no_mean_result['b2'].append(b2)
        no_mean_result['a1'].append(a1)
        no_mean_result['a2'].append(a2)
        no_mean_result['k'].append([1, 1, 1])
        no_mean_result['fs_work_iir'].append([fs_work_iir, 1, 1])
        i += 1
        
    """ """
    for name in no_mean_result:
        slice = no_mean_result[name]
        len_array = len(slice)*1.0
        mean = [0, 0, 0]
        #print slice
        for record in slice:
            mean[0] += record[0]
            mean[1] += record[1]
            mean[2] += record[2]
        mean[0] = mean[0]/len_array
        mean[1] = mean[1]/len_array
        mean[2] = mean[2]/len_array
        
        # Пишем обратно
        no_mean_result[name] = mean
        
    """ 4. Пакуем результаты для дальнейшего моделирования """
    print no_mean_result
    
    print 'Done'
    
    
    
    
    