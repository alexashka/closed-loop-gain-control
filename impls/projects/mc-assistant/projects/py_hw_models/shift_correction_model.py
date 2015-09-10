#-*- coding: utf-8 -*-
""" Convention : 
    cu - conventional unit - условная единица - шаг
    
"""
import sys
import math

# Other
import convertors_simple_data_types.xintyy_type_convertors as tc
import convertors_simple_data_types.float32_convertors as f32conv
from py_dbg_toolkit.doColoredConsole import co
import uasio.os_io.io_wrapper as iow

def _print_formatter(string):
    string = '0x'+string
    return string[:-1].replace(' ', ', 0x')

def _hex_word_to_int(hexWord):
    sum = 0
    for pos in range(0, len(hexWord)):
        oneIt =  tc.hex2int(hexWord[pos])*math.pow(16, len(hexWord)-pos-1)
        sum += oneIt
    return sum

def calc_for_ukv(
        correcting_mult,  # температурный коэффициент, V/oC
        T,  # Температура 8 бит бит/градус
        src_shift_code  # значение кода для установки смещения по умолчанию из EEPROM
        ):
        
        
    # Запираем здесь глобальное пространство имен
    # constants
    _kSets = { 'name': 'convertion.log', 'howOpen': 'a', 'coding': 'cp1251'}
    _kOutProportion = 4000/4.6    # cu/V число, загружаемое в ЦАП 
    
    """ Метод отображения результатов и плагины для вывода на комм. строку
        
        notes. : Низший модуль передает полностью всю информацию. Потом можно разбить
          регулярными выражениями

        rem. : функции обратного вызова можно собрать в кортеж и внизу управлять 
          действиями по имени
    """
    # подборка плагинов
    def plot_plugin(string):    # пустой
        None
        
    def plot_plugin_full(string):
        print string

    def _plot_item(msg, value):
        print msg+" "+str(value)
        ieee, mchip = f32conv.pack_f32_into_i32(value, _kPluginList["None"])
        mchip = _print_formatter(mchip)
        
        lst = list()
        lst.append(';    '+msg+' '+mchip+'  ; '+str(value)+'\n')
        iow.list2file(_kSets, lst)
        
    def _print_string(msg):
        lst = list()
        lst.append(';    '+msg+'\n')
        iow.list2file(_kSets, lst)


    def _plot_word(msg, word):
        """ msg : Lhl Hhl"""
        
        string = tc.byte2hex(int(word)%256)     # L
        string += ' '+ tc.byte2hex(int(word)/256)    # H
        print msg+' '+string

        lst = list()
        lst.append(';    '+msg+' '+string+'\n')
        iow.list2file(_kSets, lst)
        
    def _new_line():
        lst = list()
        lst.append('\n')
        iow.list2file(_kSets, lst)

    def _eprint_value(name, value):
        _eprint(name+' : '+str(value)+'\n')
    def _wprint_value(name, value):
        _wprint(name+' : '+str(value)+'\n')
    def _nprint_value(name, value):
        _nprint(name+' : '+str(value)+'\n')

    # shortcuts
    _nprint = co.printN
    _wprint = co.printW
    _eprint = co.printE
    _kPluginList = {"None" : plot_plugin, 'Full':plot_plugin_full}
    
    """ Расчет для УКВ ЧМ
        @version : 1.0
        
        @notes:
        v 1.0
          precond.:
            1. попр. коэфф. всегда берется по модулю
            2. при коррекции кода склад. или выч. в зависимости от знака коэфф. коррекции
          contraints :
                
        @math:
        u_shift = u_shift_src+K*T    [float32]
        u_shift_code = to_code*(from_code*u_shift_src_code+K*T) = 
            u_shift_src+to_code*(K*T) = u_shift_src + int(T*(to_code*K)) = 
            u_shift_src+sign(K)*int(T*(to_code*abs(K)))
    """

    # Измерены вольтметром
    out_dac_voltage = 4.37
    real_shift = 10.9
    
    result = 0
    # Run
    abs_correcting_mult = math.fabs(correcting_mult)    # ufloat
    dVwave = abs_correcting_mult*T  # реальные вольты
    dVdigital = _kOutProportion*dVwave  # напряжение в cu
    
    # Коррекция из-за усилителя - значение кода должно уменшится
    dVdigital *= (out_dac_voltage/real_shift)
    
    # поправка
    K = dVdigital/T  # cu(uint16)/oC положительная!

    # значение изначального кода смещения для расчетов
    src_shift_code = _hex_word_to_int(src_shift_code)

    # uintXX = uintXX+(or -)uintXX
    out_shift_code = src_shift_code+math.copysign(1, abs_correcting_mult)*dVdigital  # вычитание вот здесь
    
    # Report
    msg = 'T oC :'
    _plot_word(msg, T)
    _plot_item(msg, T)
    msg = 'dU, cu LH:'
    _plot_word(msg, dVdigital)
    msg = 'dU, cu :'
    _plot_item(msg, dVdigital)
    msg = 'Out shift value, cu LH:'
    _plot_word(msg, out_shift_code)
    msg = 'Out shift value, cu float32:'
    _plot_item(msg, out_shift_code)
    
    msg = 'K, cu(uint16)/oC:'
    _print_string(msg+' '+str(K))
    _plot_item('mK_to_Barg ', K)
    
    _new_line()

if __name__=='__main__' :
    kCorrectingMult = 4.9*5*1e-3    # Коэффициент перевода величины, V/oC
    print 'kCorrectingMult', kCorrectingMult
    T = 10
    src_shift_code = '0111'    # Исходно зачение EEPROM
    calc_for_ukv(
        kCorrectingMult, 
        T,
        src_shift_code)


