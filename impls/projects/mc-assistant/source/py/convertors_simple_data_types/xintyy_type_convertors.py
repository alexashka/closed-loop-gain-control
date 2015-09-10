#-*- coding: utf-8 -*-
""" 
    Need :
        перевод в дополнительный код
"""
import math as m


def char_to_bitarray(string):
    """ abs. : переводит байт в его бинарное представление """
    begin = 7
    src = string
    res = 0
    summary = ''
    for i in range(8):
        # сохраняемся перед делением
        res = src / m.pow(2, begin - i)

        # принимае решение о бите
        if res < 1:
            summary += '0'
        else:
            summary += '1'
            src -= int(res) * m.pow(2, begin - i)
    return summary


def bit_formatted_array_to_hex(src):
    """
    abs. : переводит тетрабы бинарных символов в их шест. предст

    pre. :
        1000 0000 0010 ... пробел обязателен
    """
    arr = src.split(' ')
    pos = 0
    outStr = ''
    for i in arr:
        if i == '0000':
            outStr += '0'
        elif i == '0001':
            outStr += '1'
        elif i == '0010':
            outStr += '2'
        elif i == '0011':
            outStr += '3'
        #
        elif i == '0100':
            outStr += '4'
        elif i == '0101':
            outStr += '5'
        elif i == '0110':
            outStr += '6'
        elif i == '0111':
            outStr += '7'

        #
        elif i == '1000':
            outStr += '8'
        elif i == '1001':
            outStr += '9'
        elif i == '1010':
            outStr += 'A'
        elif i == '1011':
            outStr += 'B'

        #
        elif i == '1100':
            outStr += 'C'
        elif i == '1101':
            outStr += 'D'
        elif i == '1110':
            outStr += 'E'
        elif i == '1111':
            outStr += 'F'

        pos += 1
        if (pos % 2 == 0):
            outStr += ' '
            # пробел
    return outStr


def hex2int(src):
    """
        abs. : переводит один шестнадцатитичный символ в десятичное число

        pre. : F-0
        post. : 15-0
    """
    res = ''
    if src == '0':
        res = 0
    elif src == '1':
        res = 1
    elif src == '2':
        res = 2
    elif src == '3':
        res = 3

    #
    elif src == '4':
        res = 4
    elif src == '5':
        res = 5
    elif src == '6':
        res = 6
    elif src == '7':
        res = 7

    #
    elif src == '8':
        res = 8
    elif src == '9':
        res = 9
    elif src == 'A':
        res = 10
    elif src == 'B':
        res = 11
    #
    elif src == 'C':
        res = 12
    elif src == 'D':
        res = 13
    elif src == 'E':
        res = 14
    elif src == 'F':
        res = 15
    return res


def uint4b2hex(src):
    """
    abs. : переводит один десятичый символ в его шест. предст.

    post. : F-0
    pre. : 15-0
    """
    res = ''
    if src == 0:
        res = '0'
    elif src == 1:
        res = '1'
    elif src == 2:
        res = '2'
    elif src == 3:
        res = '3'

    #
    elif src == 4:
        res = '4'
    elif src == 5:
        res = '5'
    elif src == 6:
        res = '6'
    elif src == 7:
        res = '7'

    #
    elif src == 8:
        res = '8'
    elif src == 9:
        res = '9'
    elif src == 10:
        res = 'A'
    elif src == 11:
        res = 'B'
    #
    elif src == 12:
        res = 'C'
    elif src == 13:
        res = 'D'
    elif src == 14:
        res = 'E'
    elif src == 15:
        res = 'F'
    else:
        res = 'None'
    return res


def hex_byte_to_uint(src):
    """ 0xHL """
    workSrc = src.replace('0x', '')
    H = workSrc[0]
    L = workSrc[1]
    h = hex2int(H)
    low = hex2int(L)
    h *= (2 * 2 * 2 * 2)    # сдвигаем на полбайта
    result = h + low
    return result


def hex_word_to_uint(src):
    workSrc = src.replace('0x', '')
    workSrc = workSrc.upper()
    uintlist = list()
    mul = m.pow(2, 16)
    mul /= m.pow(2, 4)
    sum = 0
    for i in range(len(workSrc)):
        uintlist.append(hex2int(workSrc[i]))
        uintlist[i] = uintlist[i] * mul
        sum += uintlist[i]

        mul /= m.pow(2, 4)
    return sum


def byte2hex(src):
    """ abs. : байт в его Hex-представления. Входное значени берется по модулю """
    return uint4b2hex(abs(src) / 16) + uint4b2hex((src) % 16)


def byte4hex(src):
    byte0 = src % 256
    byte1 = src / 256
    return byte2hex(byte1) + byte2hex(byte0)


def byte2strhex(src):
    return '0x' + str(byte2hex(src))


def byte4strhex(src):
    return '0x' + byte4hex(src)