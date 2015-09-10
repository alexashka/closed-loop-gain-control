#-*- coding: utf-8 -*-
import sys
import json

# dev
import uasio.os_io.io_wrapper as iow
from py_dbg_toolkit.doColoredConsole import co
import convertors_simple_data_types.xintyy_type_convertors as tc
import convertors_simple_data_types.float32_convertors as f32c

# App
import _sensors_uni as app_reuse_code

_fname = 'threshes.h'
sets = { 'name': _fname, 'howOpen': 'w', 'coding': 'cp1251'}
    
nprint = co.printN
wprint = co.printW
eprint = co.printE
def eprintValue(name, value):
    eprint(name+' : '+str(value)+'\n')
def wprintValue(name, value):
    wprint(name+' : '+str(value)+'\n')
def nprintValue(name, value):
    nprint(name+' : '+str(value)+'\n')

def _init_sensors():
        # читае конфигурация сенсора
    sensor_sets = app_reuse_code.get_sensor_cfg('I')

    # Настройки прочитаны, можно разбирать их
    value2voltage = app_reuse_code.value_to_voltage_hall
    SensorChannal = app_reuse_code.SensorChannalHall

    metro_channal = SensorChannal(sensor_sets,'adc_metro','splitter_metro_parems', value2voltage)
    threshold_channal = SensorChannal(sensor_sets,'dac_threshes','splitter_threshold_parems', value2voltage)
    return metro_channal, threshold_channal
    
def main(list_of_currents, list_metro):
    metro_channal, threshold_channal = _init_sensors()
    
    result_list = list('')
    
    # смещение нуля при обратной обработке
    result_list.append('#ifdef HALL_SENSORS')
    
    # Коррекция нуля
    delta_zero_code, capacity = app_reuse_code.calc_coeff_transform(
        0, 
        metro_channal) 

    result_list.append('    constant kZeroHallCorrect = '+delta_zero_code+
        "  ; Metro: "+str(0)+" A / "+capacity+' bit')
        
    # Теперь можно говорить об измеренных значениях
    for I in list_metro:
        src_code, capacity = app_reuse_code.calc_coeff_transform(
            list_metro[I], 
            metro_channal) 

        real_current_code = tc.hex_word_to_uint(src_code)-tc.hex_word_to_uint(delta_zero_code)
        print 'real_current_code', real_current_code
        print 'delta_zero_code', delta_zero_code
        print 'src_code', src_code
        
        result_list.append('    constant k'+I+' = 0x'+tc.byte4hex(int(real_current_code))+
            "  ; Metro: "+str(list_metro[I])+" A / "+capacity+' bit')
        
    
    # Пороги
    for I in list_of_currents :
        wprintValue('\nI,A : ', I)
        Udig, capacity = app_reuse_code.calc_coeff_transform(I, threshold_channal) 
        eprintValue('Voltage code', Udig)
        result_list.append('    constant kCurrentThreshold = '+Udig+
            "  ; Threshes: "+str(I)+" A / "+capacity+' bit')

    # Находим коэффициент пересчета
    delta_zero_code, capacity = app_reuse_code.calc_coeff_transform(0, metro_channal) 
            
    I = 10
    Udig_value, capacity = app_reuse_code.calc_coeff_transform(I, metro_channal) 
    realCodeCurrent = tc.hex_word_to_uint(Udig_value)-tc.hex_word_to_uint(delta_zero_code)
    k = I/realCodeCurrent
    wprintValue('K code to A :', k)
    
    result_list.append(';const double kTAOneCurrentFactor_ = '+str(k)+';')
    
    k *= 10 # 3.3 -> 33 для упаковки
    
    ieee, mchip = f32c.pack_f32_into_i32(k, None)
    mchip = ', 0x'.join(mchip.split(' '))
    mchip = '0x'+mchip[:-4]
    result_list.append('; mchip: '+mchip+' ; K = '+str(k))


    # Закрываем запись
    result_list.append('#endif ;HALL_SENSOR\n')
   
    iow.list2file(sets=sets, lst=result_list)
    print 'Threshes write to file '+_fname

# Run 
if __name__ == '__main__':
    main()
    

''' 
# коэффициент перевода. Это чистое значение тока - для рассчетов и отображения
# Warning : немного расходится с прошитым, но прошитый откалиброван, поэтому 
#   наверное пусть как есть
Ktrans = I/Udig_corr  # A/ue

# переводим в плавающую точку
print 'capacity : ' + str(capacity)
co.printN('Udig_src, ue : ')
co.printE(tc.byte4strhex(Udig)+'\n')

msg = "Tr. I,A="
msg = msgSplit(msg)
f = open('treshes.log', 'at');
ILow = I%10
IHigh = (I-ILow)/10
f.write("\t#define I_MSG_HIGH '"+str(IHigh)+"'\n")
f.write("\t#define I_MSG_LOW '"+str(ILow)+"'\n")
#f.write("; "+msg+"I_MSG_HIGH,I_MSG_LOW"+",'/'\n")
f.write('\t#define CURRENT_THRESHOLD '+tc.byte4strhex(Udig)+"\t;"+str(I)+" A"+"\n\n")
f.close()
#print 'Udig_cor, ue :  ' + tc.byte4strhex(Udig_corr)
return Udig

'' ' Просто заглушка '' '
def printRpt(value, valueDisplacemented, valueScaled, valueCode, Kda):
    print '\n<< Output values:'
    print 'Code : '+str(valueCode)
    print 'Kda : '+str(Kda)
'''
#import ModelADDAC as adda
# проверяем
'''valueDict = {}
valueDict[ 'value' ] = I
valueDict['displacement'] = dU
valueDict['converter' ] = Kiu
valueDict['scale'] = Splitter
valueDict['capacity'] = capacity
valueDict['Vmax'] = Vmax 
code, Kda = adda.modelADC(valueDict, printRpt, adda.calcZeroDisplacmentY)'''
