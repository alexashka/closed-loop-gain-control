#-*- coding: utf-8 -*-

import math as m
import xintyy_type_convertors as xint_module


def hex_ieee_f32_str_to_float(src):
    """ seee_eeee emmm_mmmm mmmm_mmmm mmmm_mmmm    - по стандарту """
    src_list = src.split(' ')
    int_list = list('')
    for i in src_list:
        for j in i:
            int_list.append(xint_module.hex2int(j))

    # к обратному преобразованию готово
    extracted_exp = int_list[2] + int_list[1] * 16 + int_list[0] * 16 * 16
    extracted_exp >>= 3
    extracted_exp &= 255

    # мантисса
    mantissa = int_list[-1] + int_list[-2] * 16 + int_list[-3] * 16 * 16 + \
               int_list[-4] * 16 * 16 * 16 + \
               int_list[-5] * 16 * 16 * 16 * 16 + (int_list[-6] & 7) * 16 * 16 * 16 * 16 * 16

    mantissa = float(mantissa) / m.pow(2, 23) + 1  # полсностью в скобках
    summaryo = mantissa * m.pow(2, (extracted_exp - 127))
    if int_list[0] >= 9:
        summaryo = -summaryo
    return summaryo


def hex_mchip_f32_to_hex_ieee_f32(src):
    """ Функция преобразования float MICROCHIP 32 to IEEE float32
        seee_eeee emmm_mmmm mmmm_mmmm mmmm_mmmm    - по стандарту
        0    1    2    3    -4   -3   -2   -1
        eeee_eeee smmm_mmmm mmmm_mmmm mmmm_mmmm - микрочиповский формат
    """
    src_list = src.split(' ')
    int_list = list('')
    for i in src_list:
        for j in i:
            int_list.append(xint_module.hex2int(j))

    # к обратному преобразованию готово
    # выделяем экспаненту
    extracted_exp = int_list[1] + int_list[0] * 16

    # мантисса
    mantissa = int_list[-1] + \
               int_list[-2] * 16 + \
               int_list[-3] * 256 + \
               int_list[-4] * 16 * 256 + \
               int_list[-5] * 256 * 256 + \
               (int_list[-6] & 7) * 16 * 256 * 256

    mantissa = float(mantissa) / m.pow(2, 23) + 1  # полсностью в скобках
    result = mantissa * m.pow(2, (extracted_exp - 127))
    if int_list[-6] & 8 != 0:
        result = -result
    return result


def formatted_hex_mchip_float32_to_ieee_float32(src_string):
    """ 0xXX 0xYY 0xRR 0xVV """
    src_string = src_string.replace('0x', '')
    src_string = src_string.replace(',', '')
    return hex_mchip_f32_to_hex_ieee_f32(src_string)


def pack_f32_into_i32(float_value, plot_callback):
    """ """
    abs_in_value = abs(float_value)
    # Точность предельная
    count_steps = 23 + 1

    # поиск подходящей степени
    begin = 0
    while 1:
        power = m.pow(2, begin)
        if abs_in_value - int(power) < 0:
            begin -= 1     # нужно отнять
            break

        # степень растет
        begin += 1

    # степень отрицательная
    if abs_in_value < 1:
        begin = 0    # нолик всегда должен быть

    # представляем в двoичном коде
    res = 0
    summary = ''
    for i in range(count_steps):
        # сохраняемся перед делением
        res = abs_in_value / m.pow(2, begin - i)

        # принимае решение о бите
        if res < 1:
            summary += '0'
        else:
            summary += '1'
            abs_in_value -= int(res) * m.pow(2, begin - i)

        # ставим запятую
        if m.pow(2, begin - i) == 1:
            summary += ','

    # zero - ok
    #print summary

    # Нужно узнать экспаненту, ищем где запятая и первая 1
    first_one = summary.find('1')
    coma = summary.find(',')
    exp = 0
    if first_one != -1: # единиц нет
        if coma < first_one:
            exp = coma - first_one
        else:
            exp = coma - first_one - 1
    else:
        exp = -127

    # значение экспаненты
    exp += 127    # задаем смещение 

    exp = xint_module.char_to_bitarray(exp)

    # Итоговое формирование
    # ставим знак числа
    if str(float_value)[0] == '-':
        exp = '1' + exp
    else:
        exp = '0' + exp

    # Офформление мантиссы
    summary = summary.replace(',', '')
    position_firs_one = summary.find('1')
    value_mant_in_str = summary[position_firs_one + 1: -1]
    len_value_mant_in_str = len(value_mant_in_str)
    for j in range(23 - len_value_mant_in_str):
        value_mant_in_str += '0'

    # Итого сцепляем и выводим
    summary = exp + value_mant_in_str

    # Форматируем
    summary_tmp = '0000000' + summary + '0'
    str_f32 = ''
    for k in range(32 + 4 + 4):
        str_f32 += summary_tmp[k]
        if (k + 1) % 4 == 0:
            str_f32 += ' '
    aux_format_result = str_f32

    str_f32 = ''
    for k in range(32):
        str_f32 += summary[k]
        if (k + 1) % 4 == 0:
            str_f32 += ' '

    # первый результат
    ieee = str_f32

    # преобразование числа для pic
    pure_exp = aux_format_result.split(' ')
    pure_exp = pure_exp[2] + ' ' + pure_exp[3]
    sign = ieee[0][0]

    # разбиваем еще раз
    mplab_float = ieee.split(' ')  # seee0_eeee1 e
    mplab_format = pure_exp
    tmp = ''
    for i in mplab_float[3:]:
        tmp = tmp + ' ' + i

    # второй результат
    mplab_format = mplab_format + ' ' + sign + mplab_float[2][1:] + tmp

    # Проверка И вывод разультатов
    if plot_callback:
        plot_callback("IEEE : " + str(float_value) +
                      ' : ' + xint_module.bit_formatted_array_to_hex(ieee) + ' -> ' + ieee)
        plot_callback("MICROCHIP : " + str(float_value) +
                      ' : ' + xint_module.bit_formatted_array_to_hex(mplab_format) + ' -> ' + mplab_format)

    return 'ieee', xint_module.bit_formatted_array_to_hex(ieee), xint_module.bit_formatted_array_to_hex(mplab_format)



