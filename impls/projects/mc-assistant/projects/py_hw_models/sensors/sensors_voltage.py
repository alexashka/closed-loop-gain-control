#-*- coding: utf-8 -*-
""" Сейчас порог (VOLTAGE_THRESHOLD) не рассчитывает

"""
# core
# utils

import json


# Other
import uasio.os_io.io_wrapper as iow
from jarvis.py_dbg_toolkit.doColoredConsole import co
import convertors_simple_data_types.xintyy_type_convertors as tc
import convertors_simple_data_types.float32_convertors as f32c

# App
import _sensors_uni as app_reuse_code

nprint = co.printN
wprint = co.printW
eprint = co.printE
def eprintValue(name, value):
    eprint(name+' : '+str(value)+'\n')
def wprintValue(name, value):
    wprint(name+' : '+str(value)+'\n')
def nprintValue(name, value):
    nprint(name+' : '+str(value)+'\n')
    
class SensorChannalVoltage(app_reuse_code.SensorChannalHall):
    def __init__(self, *args):
        SensorChannalHall.__init__(self, *args)
        
    def getSplitter(self):
        R1 = self._splitter_params['R1']
        R2 = self._splitter_params['R2']
        R3 = self._splitter_params['R3']
        R4 = self._splitter_params['R4']

        # расчет коэффицниента передачи
        U0 = 1.0
        U2 = U0*R2/(R1+R2)
        U4 = U2*R4/(R4+R3)
        splitter = U4/U0
        return splitter
        
SensorChannal = app_reuse_code.SensorChannalHall    # Для измерителя

value2voltage = app_reuse_code.value_to_voltage_hall    # кривая

# читае конфигурация сенсора
sensor_sets = app_reuse_code.get_sensor_cfg('U')

# Настройки прочитаны, можно разбирать их
metroChannal = app_reuse_code.SensorChannalHall(
    sensor_sets,
    'adc_metro',
    'splitter_metro_parems', 
    value2voltage)
thresholdChannal_max = app_reuse_code.SensorChannalHall(
    sensor_sets,
    'dac_threshes',
    'splitter_threshold_parems_max', 
    value2voltage)
thresholdChannal_min = app_reuse_code.SensorChannalHall(
    sensor_sets,
    'dac_threshes',
    'splitter_threshold_parems_min', 
    value2voltage)

def main(v_nom, merto_list):
    result_list = list('')
    sets = { 'name': 'voltage_header.h', 'howOpen': 'w', 'coding': 'cp1251'}
    
    # смещение нуля при обратоной обработке
    U = 0
    Udig_zero, capacity = app_reuse_code.calc_coeff_transform(U, metroChannal) 
    # Записать в файл шаблон
    result_list = list('')
    result_list.append('#define kZeroVoltageCorrect '+Udig_zero+"  ; "+str(U)+" V; bits - "+capacity)
    
    for name in merto_list:
        code, capacity = app_reuse_code.calc_coeff_transform(merto_list[name], metroChannal) 
        result_list.append(
            'constant k'+name+' = '+code+"  ; "+str(merto_list[name])+" V / "+capacity+" bits")
        
    
    # Порог
    U_nom = v_nom
    U_min = U_nom-U_nom/100.0*15
    U_max = U_nom+U_nom/100.0*13
    print U_min, U_max
    U_min_d, capacity = app_reuse_code.calc_coeff_transform(U_min, thresholdChannal_min) 
    U_max_d, capacity = app_reuse_code.calc_coeff_transform(U_max, thresholdChannal_max) 
    print U_min_d, U_max_d
    result_list.append('#define VOLTAGE_THR_MIN '+U_min_d+"  ; -15% V  bits - "+capacity)
    result_list.append('#define VOLTAGE_THR_MAX '+U_max_d+"  ; +13% V  bits - "+capacity+'\n')
            
    # Находим коэффициент пересчета
    U = U_nom
    Udig_value, capacity = app_reuse_code.calc_coeff_transform(U, thresholdChannal_min) 
    print Udig_value
    
    U = 42.0
    Udig_value, capacity = app_reuse_code.calc_coeff_transform(U, metroChannal) 
    #result_list.append('#define TEST_MOCK_VOLTAGE '+Udig_value+"\t;"+str(U)+" V; bits - "+capacity)
    
    
    
    realCodeVoltage = tc.hex_word_to_uint(Udig_value)-tc.hex_word_to_uint(Udig_zero)
    k = U/realCodeVoltage
    wprintValue('K code to V :', k)
    result_list.append(';const double kTAOneVoltagePSFactor_ = '+str(k)+';')
    
    k *= 10
    ieee, mchip = f32c.pack_f32_into_i32(k, None)
    mchip = ', 0x'.join(mchip.split(' '))
    mchip = '0x'+mchip[:-4]
    result_list.append('; mchip: '+mchip+' ; K*10 = '+str(k))

    # Закрываем запись
    iow.list2file(sets=sets, lst=result_list)

# Run 
if __name__ == '__main__':
    a
    main(a, b)
